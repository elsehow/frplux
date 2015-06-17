h = require "virtual-dom/h"

deleteButton = (msg, actions) ->
	return h "button.delete"
		, { onclick: () -> actions.deleteMessage msg._id }
		, "x"

getError = (msg) ->
	if msg.error 
		return h "div.error", msg.error
	else 
		return null

getClass = (msg) ->
	if msg.deletePending 
		return '.message.deletePending' 
	else
		return '.message'

message = (msg, actions) ->
	return h("div#{getClass msg}",
		[
			getError msg
			deleteButton msg, actions
			h "span", msg.content
		] )

module.exports = message
