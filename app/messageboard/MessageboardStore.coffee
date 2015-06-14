Kefir = require 'kefir'
Bus = require 'kefir-bus'
$ = require 'jquery'
_ = require 'lodash'

class MessageboardStore

	# the STATE STREAM is a bacon bus
	stateStream: Bus()
	# for now, we'll just use a vanilla js object as our state
	state: 
		loadingMessages: false
		messages: []

	# wire actions to dispatch events here
	constructor: (@dispatcher) ->
		# this object relates `message.action` strings to functions
		# check out wire function for implementation details
		@wire
			'fetchMessages' : @fetchMessages
			'deleteMessage' : @deleteMessage 
	#
	# methods for loading messages
	#
	fetchMessages: =>
		# we're starting to fetch messages now
		@messagesAreBeingFetched()
		# make the AJAX request
		promise = $.ajax
			url: '/messages'
			method: 'GET'
		# if it succeeds,
		promise.done (messages) =>
			@doneFetchingMessages()
			@setMessages messages
		promise.fail () =>
			@doneFetchingMessages()

	messagesAreBeingFetched: =>
		@state.loadingMessages = true
		@pushState()

	doneFetchingMessages: =>
		@state.loadingMessages = false
		@pushState()

	setMessages: (messages) =>
		@state.messages = messages 
		@pushState()

	#
	# methods for deleting messages
	#
	deleteMessage: (dispatch) =>
		# gray out the thing we're about to delete
		@deleteMessagePending dispatch
		# start AJAX req to delete message
		promise = $.ajax 
			url: '/messages'
			method: 'DELETE'
			data: JSON.stringify { messageID: dispatch.messageID }
			contentType: 'application/json; charset=utf-8'
		promise.done () =>
			@removeMessageFromModel dispatch
		promise.fail () =>
			@deleteMessageFailed dispatch

	deleteMessagePending: (dispatch) =>
		updateInState @state.messages, dispatch.messageID, 'deletePending', true 
		@pushState()

	deleteMessageFailed: (dispatch) =>
		updateInState @state.messages, dispatch.messageID, 'deletePending', false 
		updateInState @state.messages, dispatch.messageID, 'error'
			, 'The server encountered an error while trying to delete your message. :( Try again.'
		@pushState()

	removeMessageFromModel: (dispatch) =>
		@state.messages = delFromState @state.messages, dispatch.messageID
		@pushState()

	#
	# utility methods
	#
	pushState: =>  # pushes state over @stateStream
		@stateStream.emit @state
	action: (str) ->  # filters for msg.action
		return (msg) -> msg.action is str
	wire: (obj) => # takes an object of { 'message':fn }
		_.each obj, (fn, message) =>
			# sets @dispatcher to fn(message) on message.action
			@dispatcher
				.filter @action message
				.onValue (m) -> fn m 

	# hacky functions for manipulating app state
	# you can ignore these 
	updateInState = (messages, msgID, key, value) ->
		_.forEach messages, (msg, k) =>
			if msg._id is msgID then msg[key] = value
	delFromState = (messages, msgID) ->
		_.reject messages, '_id', msgID 


module.exports = MessageboardStore