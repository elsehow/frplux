docReady = require 'doc-ready'
Kefir = require 'kefir'
Bus = require 'kefir-bus'
Messageboard = require './messageboard/index.coffee'
Toolbar = require './toolbar/index.coffee'
Aviator = require 'aviator'
React = require 'react'
noJsxMixin = require "react-no-jsx/mixin"

# a high-level app component 
App = React.createClass
	mixins: [noJsxMixin]
	displayName: "App"
	renderTree: () ->
		["div", { className: "container" },
			["div", { id: "toolbar" } ], 
			["div", { id: "content" } ] ]

init = ->

	dispatcher = Bus()

	# and boostraps the page html
	AppBaseTarget =
		setupLayout: () =>
			React.render React.createElement(App), document.body
			Toolbar.setup dispatcher, document.getElementById 'toolbar'

	MessageboardTarget = 
		show: (req) =>
			board = { id: req.params.id };
			Messageboard.setup dispatcher, board.id, document.getElementById 'content'

	# defining routes - see this 
	# https://gist.github.com/hojberg/9549330
	Aviator.setRoutes
		target: AppBaseTarget,
		# setupLayout is run for every route in the route tree.
		'/*': 'setupLayout'
		'/messageboard': 
			target: MessageboardTarget,
			# '/': 'list'
			'/:id': 'show'
			
	# start routing
	Aviator.dispatch()

	# all done
	console.log 'main app done+launched'

# launch the app
docReady () -> init()
