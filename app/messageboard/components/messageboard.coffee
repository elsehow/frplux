_ = require 'lodash'
h = require "virtual-dom/h"
message = require './message.coffee'

messageboard = (state, actions) ->

	if state.loadingMessages 
		return h("span", "loading")

	return h("div", [
		# h("span", "sup")
        h "div", _.map state.messages, (msg) -> message msg, actions 
		])

module.exports = messageboard