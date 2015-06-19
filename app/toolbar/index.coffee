ToolbarActions = require './actions.coffee'
ToolbarStore = require './store.coffee'
Toolbar = require './components/toolbar.coffee'

React = require 'react'

render = (state, actions, element) ->
	React.render(
		React.createElement(Toolbar, { state: state, actions: actions })
		, element)

# this gets called from app/entry.coffee
# we pass in an application-wide dispatcher 
setup = (dispatcher, element) ->

	# we can call functions in actions
	actions = new ToolbarActions(dispatcher).actions()
	# we recieve application state from our store
	store = new ToolbarStore dispatcher 

	# render initial state
	initialState = store.get()
	render initialState, actions, element

	# update the view whenever a new state comes in
	store.on 'update', (state) -> 
		render state, actions, element
		# DEBUG: print our new state
		console.log 'new toolbar state!', state

	# do an initial fetch
	actions.fetchNotifications()


exports.setup = setup