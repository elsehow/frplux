Freezer = require 'freezer-js'
$ = require 'jquery'
_ = require 'lodash'

class MessageboardStore

	# an immutable datastore
	store: new Freezer
		loadingMessages: true
		messages: {} 

	# wire actions to dispatch events here
	constructor: (@dispatcher) ->
		# this object relates `message.action` strings to functions
		# check out wire function for implementation details
		@wire
			'fetchMessages' : @fetchMessages
			'deleteMessage' : @deleteMessage 

	# high-level methods
	fetchMessages: =>
		# we're starting to fetch messages now
		@setLoadingMessages true
		# make the AJAX request
		promise = $.ajax
			url: '/messages'
			method: 'GET'
		# if it succeeds,
		promise.done (messages) =>
			@store.get().messages.set messages 
		# stop loading thing regardless
		promise.always () =>
			@setLoadingMessages false 

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
			@removeMessage dispatch
		promise.fail () =>
			@deleteMessageFailed dispatch

	#
	# helper methods 
	#
	setLoadingMessages: (value) ->
		@store.get().set 'loadingMessages', value 

	setDeletePending: (msgID, value) =>
		@store.get().messages[msgID].set 'deletePending', value

	setError: (msgID, errMsg) =>
		@store.get().messages[msgID]. set 'error', errMsg

	deleteMessagePending: (dispatch) =>
		msgID = dispatch.messageID
		@setDeletePending msgID, true

	deleteMessageFailed: (dispatch) =>
		msgID = dispatch.messageID
		@setDeletePending msgID, false 
		@setError msgID
			, 'The server encountered an error while trying to delete your message. :( Try again.'

	removeMessage: (dispatch) =>
		@store.get().messages.remove dispatch.messageID

	#
	# utility methods
	#
	# filters for msg.action
	action: (str) -> return (msg) -> msg.action is str
	# takes an object of { 'message':fn }
	# sets @dispatcher to fn(message) on message.action
	wire: (obj) => 
		_.each obj, (fn, message) =>
			@dispatcher
				.filter @action message
				.onValue (m) -> fn m 

module.exports = MessageboardStore