_ = require 'lodash'
$ = require 'jquery'
Bacon = require 'baconjs'
bjq = require 'bacon.jquery'
bm = require 'bacon.model'
MessageboardActions = require './MessageboardActions.coffee'
MessageboardStore = require './MessageboardStore.coffee'
renderMessages = require './components/renderMessages.coffee'

messageID = (el) ->
	$(el).attr('data-messageID')

messageboardContainerDiv = ->
	$ _.template('<div id="messageboard"></div>')()

renderState = ($div, actions, state) ->
	# DEBUG
	console.log 'state', state
	$div.empty()
	# show 'loading' if messages haven't been fetched yet
	if state.loadingMessages
		$div.html('loading messages...')
	else
		# render each message
		renderMessages $div, state.messages
	# listen for delete button clicks
	$('.delete').asEventStream 'click'
		.onValue (v) -> actions.deleteMessage messageID v.target

exports.setup = (dispatcher) ->
	# render basic DOM
	$messageboard = messageboardContainerDiv()	
	$('body').append $messageboard

	actions = new MessageboardActions dispatcher
	store = new MessageboardStore dispatcher

	store.stateStream
		.onValue renderState, $messageboard, actions

	# do an initial fetch
	actions.fetchMessages()


