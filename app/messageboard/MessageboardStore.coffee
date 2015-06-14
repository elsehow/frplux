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
		messageActionModel =  {
			# fetch messages
			'startingFetch' : @messagesAreLoading
			'fetchSuccess' : @setMessages
			# delete messages
			'deleteMessagePending' : @deleteMessagePending
			'deleteSuccess' : @deleteMessage
			'deleteFailure' : @deleteMessageFailed
		}

		# check out this function for implementation details
		@wire messageActionModel
		
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
	pushState: =>  # pushes state over @stateStream
		@stateStream.push @state
	action: (str) ->  # filters for msg.action
		return (msg) -> msg.action is str
	wire: (msgActionModel) => # wires functions to messages
		_.each msgActionModel, (fn, message) ->
			@dispatcher
				.filter @action message
				.onValue fn	

	# hacky functions for manipulating app state
	# ignore these 
	updateMessage = (messages, msgID, key, value) ->
		_.forEach messages, (msg, k) ->
			if msg._id is msgID then msg[key] = value
	deleteMessage = (messages, msgID) ->
		_.reject messages, '_id', msgID 


module.exports = MessageboardStore