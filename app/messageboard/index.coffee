MessageboardActions = require './actions.coffee'
MessageboardStore = require './store.coffee'
Messageboard = require './components/messageboard.coffee'
mainLoop = require 'main-loop'

# this gets called from app/entry.coffee
# we pass in an application-wide dispatcher 
setup = (dispatcher) ->

	# we can call functions in actions
	actions = new MessageboardActions dispatcher
	# we recieve application state from store.store
	store = new MessageboardStore(dispatcher).store

	# this gets called whenever a new state comes in
	render = (store) -> Messageboard store, actions
	# notice that we're passing in our actions !
	# this is so we can bind actions to events e.g. clicks

	# the main loop
	mloop = mainLoop store.get(), render, {
	    create: require "virtual-dom/create-element"
	    diff: require "virtual-dom/diff"
	    patch: require "virtual-dom/patch"
	}
	document.body.appendChild(mloop.target)

	store.on 'update', (state) -> 
		console.log '-->', state 
		# DEBUG: print our new state
		console.log 'new state!', state
		# update the view whenever a new state comes in
		mloop.update state

	# do an initial fetch
	actions.fetchMessages()

exports.setup = setup