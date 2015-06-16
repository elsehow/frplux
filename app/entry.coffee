docReady = require 'doc-ready'
Kefir = require 'kefir'
Bus = require 'kefir-bus'
Messageboard = require './messageboard/index.coffee'

init = ->
	# setup app
	dispatcher = Bus()
	Messageboard.setup dispatcher
	# all done
	console.log 'main app done+launched'

# launch the app
docReady () -> init()
