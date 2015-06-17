MessageboardActions = require './actions.coffee'
MessageboardStore = require './store.coffee'
Messageboard = require './components/messageboard.coffee'

React = require 'react'

# this gets called from app/entry.coffee
# we pass in an application-wide dispatcher 
setup = (dispatcher) ->

	# we can call functions in actions
	actions = new MessageboardActions dispatcher
	# we recieve application state from store.store
	store = new MessageboardStore(dispatcher).store

	React.render React.createElement(Messageboard, store.get()), document.body

	store.on 'update', (state) -> 
		# DEBUG: print our new state
		console.log 'new state!', state
		React.render React.createElement(Messageboard, state), document.body
		# update the view whenever a new state comes in
		# mloop.update state

	# do an initial fetch
	actions.fetchMessages()


exports.setup = setup