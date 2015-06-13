$ = require 'jquery'

class MessageboardActions

	constructor: (@dispatcher) ->

	fetchMessages: =>
		# push starting fetch to dispatcher
		@dispatcher.push
			action: 'startingFetch'
		# fetch messages from server
		promise = @$fetchMessages() 
		promise.done (messages) =>
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