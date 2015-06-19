class MessageboardActions

	# see https://github.com/elsehow/frplux/issues/5

	# the constructor returns the Actions object
	constructor: (@dispatcher) -> 
	dispatch: (msg) => @dispatcher.emit msg

	# actions here
	actions: () =>

		fetchMessages: =>
			@dispatch
				actionType: 'fetchMessages'
			
		deleteMessage: (messageid) =>
			@dispatch
				actionType: 'deleteMessage'
				messageid: messageid

		postMessage: (content) =>
			# debug
			console.log 'posting', content
			@dispatch
				actionType: 'postMessage'
				content: content
	
module.exports = MessageboardActions