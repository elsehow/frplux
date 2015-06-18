MessageboardActions = require './actions.coffee'
MessageboardStore = require './store.coffee'
Messageboard = require './components/messageboard.coffee'

React = require 'react'

render = (state, actions) ->
	React.render(
		React.createElement(Messageboard, { state: state, actions: actions })
		, document.body)

# this gets called from app/entry.coffee
# we pass in an application-wide dispatcher 
setup = (dispatcher) ->

	# we can call functions in actions
	actions = new MessageboardActions dispatcher
	# we recieve application state from store.store
	store = new MessageboardStore(dispatcher).store

	# render initial state
	render store.get(), actions

	store.on 'update', (state) -> 
		# DEBUG: print our new state
		# console.log 'new state!', state
		# update the view whenever a new state comes in
		render state, actions

	# do an initial fetch
	actions.fetchMessages()


exports.setup = setup