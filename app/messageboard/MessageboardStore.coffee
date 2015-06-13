Bacon = require 'baconjs'
_ = require 'lodash'


updateMessage = (messages, msgID, key, value) ->
	_.forEach messages, (msg, k) ->
		if msg._id is msgID
			msg[key] = value

deleteMessage = (messages, msgID) ->
	_.reject messages, '_id', msgID 

class MessageboardStore

	stateStream: new Bacon.Bus()
	state: 
		loadingMessages: false
		messages: []

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
			.onValue (v) => @deleteMessagePending v.messageID
		@dispatcher
			.filter @action 'deleteSuccess'
			.onValue (v) => @deleteMessage v.messageID
		@dispatcher
			.filter @action 'deleteFailure'
			.onValue (v) => @deleteMessageFailed v.messageID

	pushState: => 
		@stateStream.push @state

	action: (str) -> 
		(v) -> v.action is str

	messagesAreLoading: =>
		@state.loadingMessages = true
		@pushState()

	setMessages: (dispatch) =>
		@state.loadingMessages = false
		@state.messages = dispatch.messages 
		@pushState()

	deleteMessagePending: (messageID) =>
		updateMessage @state.messages, messageID, 'deletePending', true 
		@pushState()

	deleteMessageFailed: (messageID) =>
		updateMessage @state.messages, messageID, 'deletePending', false 
		updateMessage @state.messages, messageID, 'error'
			, 'The server encountered an error while trying to delete your message. :( Try again.'
		@pushState()

	deleteMessage: (messageID) ->
		console.log messageID
		@state.messages = deleteMessage @state.messages, messageID
		@pushState()



module.exports = MessageboardStore