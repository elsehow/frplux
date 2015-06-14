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

		# this object relates `message.action` strings to functions
		# whenever a `message` comes in whose `message.action` matches one of these strings
		# the related function is called on `message`
		# check out wire function for implementation details
		@wire {
			# fetch messages
			'startingFetch' : @messagesBeingFetched
			'doneFetching' : @doneFetchingMessages
			'fetchSuccess' : @setMessages
			# delete messages
			'deleteMessagePending' : @deleteMessagePending
			'deleteSuccess' : @deleteMessage
			'deleteFailure' : @deleteMessageFailed
		} 
		
	# methods for loading messages
	messagesBeingFetched: =>
		@state.loadingMessages = true
		@pushState()

	doneFetchingMessages: =>
		@state.loadingMessages = false
		@pushState()

	setMessages: (dispatch) =>
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
	pushState: =>  # pushes state over @stateStream
		@stateStream.push @state
	action: (str) ->  # filters for msg.action
		return (msg) -> msg.action is str
	wire: (obj) => # takes an object of { 'message':fn }
		_.each obj, (fn, message) =>
			# sets @dispatcher to fn(message) on message.action
			@dispatcher
				.filter @action message
				.onValue (m) -> fn m 

	# hacky functions for manipulating app state
	# ignore these 
	updateMessage = (messages, msgID, key, value) ->
		_.forEach messages, (msg, k) =>
			if msg._id is msgID then msg[key] = value
	deleteMessage = (messages, msgID) ->
		_.reject messages, '_id', msgID 


module.exports = MessageboardStore