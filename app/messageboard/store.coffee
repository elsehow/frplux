Freezer = require 'freezer-js'
$ = require 'jquery'
_ = require 'lodash'

action = (str) -> return (msg) -> msg.action is str
# sets side-effects of a stream given a map { "message": fn }
wire = (stream, fnMap) => 
	_.each fnMap, (fn, msg) => 
		stream.filter(action msg).onValue (m) -> fn m

class MessageboardStore

	# an immutable datastore
	store: new Freezer
		loadingMessages: true
		messages: {} 

	# think of this like @dispatcher.register
	# see https://github.com/elsehow/frplux/issues/3
	constructor: (@dispatcher) ->
		# this object relates `message.action` strings to functions
		# check out wire function for implementation details
		wire @dispatcher,
			'fetchMessages' : @fetchMessages
			'deleteMessage' : @deleteMessage 
		# index subscribes to changes in this store
		return @store

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

module.exports = MessageboardStore