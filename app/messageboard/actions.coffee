class MessageboardActions

	# this looks simple
	# but how could it be more "neutral" , flexible?
	#
	# it would be nice to "just call" functions in store 
	# but need to define/write prototypes for them here
	#	
	# bc right now i have a definition here
	# , some weird MESSAGE to coordinate
	# and a definition in STORE
	#
	# cant i feel like im calling smoe subset of store?
	#

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
		# DEBUG
		console.log 'posting', content
		@dispatch
			action: 'postMessage'
			content: content
	
module.exports = MessageboardActions