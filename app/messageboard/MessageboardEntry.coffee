_ = require 'lodash'
$ = require 'jquery'
Bacon = require 'baconjs'
bjq = require 'bacon.jquery'
bm = require 'bacon.model'
MessageboardActions = require './MessageboardActions.coffee'
MessageboardStore = require './MessageboardStore.coffee'
addMessage = require './components/addMessage.coffee'

msgboardContainerTmpl = -> _.template('<div id="messageboard"></div>')()
messageboardContainerDiv = -> $(msgboardContainerTmpl())
messageID = (el) -> $(el).attr('data-messageID')

# this gets called whenever a new state comes in
# in production, we'd do some fancy DOM-diffing or st,
# but we're keeping it simple for this example
update = ($div, actions, state) ->
	# clear everything
	$div.empty()
	# show 'loading' if messages haven't been fetched yet
	if state.loadingMessages then $div.html 'loading messages...'
	# append each message to the DOM
	else _.each state.messages, (msg) -> addMessage $div, msg
	# listen for delete button clicks
	$('.delete').asEventStream 'click'
		.onValue (v) -> 
			actions.deleteMessage messageID v.target

# this gets called from app/entry.coffee
# we pass in an application-wide dispatcher 
setup = (dispatcher) ->

	# render basic DOM
	$messageboard = messageboardContainerDiv()	
	$('body').append $messageboard

	# this component calls functions in actions
	actions = new MessageboardActions dispatcher
	# this component recieves application state from store.stateStream
	store = new MessageboardStore dispatcher 
	stateStream = store.stateStream


	# DEBUG - log what comes thru stateStream
	stateStream.log('state')

	# whenever a new state comes in
	# we update the view
	stateStream
		.onValue (state) -> update $messageboard, actions, state

	# do an initial fetch
	actions.fetchMessages()

exports.setup = setup