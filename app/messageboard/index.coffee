MessageboardActions = require './actions.coffee'
MessageboardStore = require './store.coffee'
Messageboard = require './components/messageboard.coffee'

React = require 'react'

render = (state, actions, element) ->
	React.render(
		React.createElement(Messageboard, { state: state, actions: actions })
		, element)

# this gets called from app/entry.coffee
# we pass in an application-wide dispatcher 
setup = (dispatcher, element) ->

	# we can call functions in actions
	actions = new MessageboardActions(dispatcher).actions()
	# we recieve application state from our store
	store = new MessageboardStore(dispatcher).store

	# render initial state
	initialState = store.get()
	render initialState, actions, element

	# update the view whenever a new state comes in
	store.on 'update', (state) -> 
		render state, actions, element
		# DEBUG: print our new state
		# console.log 'new state!', state

	# do an initial fetch
	actions.fetchMessages()


exports.setup = setup