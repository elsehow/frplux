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
		updated = @store.get().set 'loadingMessages', true
		# make the AJAX request
		promise = $.ajax
			url: '/messages'
			method: 'GET'
		# if it succeeds,
		promise.done (messages) =>
			@store.get().messages.set messages 
		# stop loading thing regardless
		promise.always () =>
			@store.get().set 'loadingMessages', false

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

	#
	# helper methods for deleting messages
	#
	deleteMessagePending: (dispatch) =>
		msgID = dispatch.messageID
		@store.get().messages[msgID].set 'deletePending', true

	deleteMessageFailed: (dispatch) =>
		msgID = dispatch.messageID
		@store.get().messages[msgID].set 'deletePending', false
		@store.get().messages[msgID]. set 'error'
			, 'The server encountered an error while trying to delete your message. :( Try again.'

	removeMessageFromModel: (dispatch) =>
		@store.get().messages.remove dispatch.messageID

	#
	# utility methods
	#
	action: (str) ->  # filters for msg.action
		return (msg) -> msg.action is str
	wire: (obj) => # takes an object of { 'message':fn }
		_.each obj, (fn, message) =>
			# sets @dispatcher to fn(message) on message.action
			@dispatcher
				.filter @action message
				.onValue (m) -> fn m 

module.exports = MessageboardStore