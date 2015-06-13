Bacon = require 'baconjs'
_ = require 'lodash'

class MessageboardStore

	# the STATE STREAM is a bacon bus
	stateStream: new Bacon.Bus()
	# for now, we'll just use a vanilla js object as our state
	state: 
		loadingMessages: false
		messages: []

	# wire actions to dispatch events here
	constructor: (@dispatcher) ->

		# fetch messages
		@dispatcher
			.filter @action 'startingFetch'
			.onValue @messagesAreLoading
		@dispatcher
			.filter @action 'fetchSuccess'
			.onValue @setMessages

		# delete messages
		@dispatcher
			.filter @action 'deleteMessagePending'
			.onValue @deleteMessagePending
		@dispatcher
			.filter @action 'deleteSuccess'
			.onValue @deleteMessage
		@dispatcher
			.filter @action 'deleteFailure'
			.onValue @deleteMessageFailed

	# methods for loading messages
	messagesAreLoading: =>
		@state.loadingMessages = true
		@pushState()

	setMessages: (dispatch) =>
		@state.loadingMessages = false
		@state.messages = dispatch.messages 
		@pushState()

	# methods for deleting messages
	deleteMessagePending: (dispatch) =>
		updateMessage @state.messages, dispatch.messageID, 'deletePending', true 
		@pushState()

	deleteMessageFailed: (dispatch) =>
		updateMessage @state.messages, dispatch.messageID, 'deletePending', false 
		updateMessage @state.messages, dispatch.messageID, 'error'
			, 'The server encountered an error while trying to delete your message. :( Try again.'
		@pushState()

	deleteMessage: (dispatch) =>
		@state.messages = deleteMessage @state.messages, dispatch.messageID
		@pushState()

	# utility methods
	pushState: => 
		@stateStream.push @state
	action: (str) -> 
		return (v) -> v.action is str

	# hacky functions for manipulating app state
	# ignore these 
	updateMessage = (messages, msgID, key, value) ->
		_.forEach messages, (msg, k) ->
			if msg._id is msgID then msg[key] = value
	deleteMessage = (messages, msgID) ->
		_.reject messages, '_id', msgID 


module.exports = MessageboardStore