class MessageboardActions

	constructor: (@dispatcher) ->
	dispatch: (msg) => @dispatcher.emit msg

	fetchMessages: =>
		@dispatch
			action: 'fetchMessages'
		
	deleteMessage: (messageID) =>
		@dispatch
			action: 'deleteMessage'
			messageID: messageID
	
module.exports = MessageboardActions