_ = require 'lodash'
$ = require 'jquery'
Kefir = require 'kefir'
Bus = require 'kefir-bus'
Messageboard = require './messageboard/MessageboardEntry.coffee'

init = ->
	# setup app
	dispatcher = Bus()
	Messageboard.setup(dispatcher)
	# all done
	console.log 'main app done+launched'

# launch the app
$(document).ready init
