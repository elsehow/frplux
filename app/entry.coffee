_ = require 'lodash'
$ = require 'jquery'
Bacon = require 'baconjs'
Messageboard = require './messageboard/MessageboardEntry.coffee'

init = ->
	# setup app
	dispatcher = new Bacon.Bus()
	Messageboard.setup(dispatcher)
	# all done
	console.log 'main app done+launched'

# launch the app
$(document).ready init
