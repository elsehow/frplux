docReady = require 'doc-ready'
Kefir = require 'kefir'
Bus = require 'kefir-bus'
Messageboard = require './messageboard/index.coffee'
Toolbar = require './toolbar/index.coffee'

init = ->
	# setup app
	dispatcher = Bus()
	Toolbar.setup dispatcher, document.getElementById 'toolbar'
	Messageboard.setup dispatcher, document.getElementById 'messageboard'
	# all done
	console.log 'main app done+launched'

# launch the app
docReady () -> init()
