$ = require 'jquery'

class MessageboardActions

	constructor: (@dispatcher) ->

	fetchMessages: =>
		# tell dispatcher we're starting to fetch messages
		@dispatcher.push action: 'startingFetch'
		# start the ajax request 
		promise = @$fetchMessages() 
		promise.done (messages) =>
			# we're done fetching now
			@dispatcher.push action: 'doneFetching'
			# here are our messages
			@dispatcher.push
				action: 'fetchSuccess'
				messages: messages
	deleteMessage: (messageID) =>
		# push starting delete to dispatcher
		@dispatcher.push
			action: 'deleteMessagePending'
			messageID: messageID
		# start AJAX request to delete
		promise = @$deleteMessage messageID
		promise.done () =>
			@dispatcher.push
				action: 'deleteSuccess'
				messageID: messageID
		promise.fail (err) =>
			@dispatcher.push
				action: 'deleteFailure'
				messageID: messageID
				err: err

	# private methods
	$deleteMessage: (id) ->
		$.ajax 
			url: '/messages'
			method: 'DELETE'
			data: JSON.stringify { messageID: id }
			contentType: 'application/json; charset=utf-8'

	$fetchMessages: ->
		$.ajax
			url: '/messages'
			method: 'GET'
		
module.exports = MessageboardActions