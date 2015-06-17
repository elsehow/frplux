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

	postMessage: (content) =>
		console.log 'post message', content
		@dispatch
			action: 'postMessage'
			content: content
	
module.exports = MessageboardActions