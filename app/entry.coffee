Messageboard = require './messageboard/MessageboardEntry.coffee'
$ = require 'jquery'
Bacon = require 'baconjs'

init = ->
	dispatcher = new Bacon.Bus()
	Messageboard.setup(dispatcher)
	console.log 'main app done+launched'

# launch the app
$(document).ready(() ->
	init() )
