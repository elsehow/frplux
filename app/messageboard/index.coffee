MessageboardActions = require './actions.coffee'
MessageboardStore = require './store.coffee'
Messageboard = require './components/messageboard.coffee'
mainLoop = require 'main-loop'

# this gets called from app/entry.coffee
# we pass in an application-wide dispatcher 
setup = (dispatcher) ->

	# we can call functions in actions
	actions = new MessageboardActions dispatcher
	# we recieve application state from store.stateStream
	store = new MessageboardStore dispatcher 
	stateStream = store.stateStream

	# this gets called whenever a new state comes in
	# notice that we're passing in our actions !
	# this is so we can bind actions to events e.g. clicks
	render = (state) -> Messageboard state, actions

	mloop = mainLoop { loadingMessages: true }, render, {
	    create: require("virtual-dom/create-element"),
	    diff: require("virtual-dom/diff"),
	    patch: require("virtual-dom/patch") }
	document.body.appendChild(mloop.target)

	# DEBUG - log what comes thru stateStream
	stateStream.log 'state'

	# whenever a new state comes in
	# we update the view
	stateStream.onValue mloop.update 

	# do an initial fetch
	actions.fetchMessages()

exports.setup = setup