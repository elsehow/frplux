h = require "virtual-dom/h"

deleteButton = (msg, actions) ->
	h "button.delete", {
		onclick: () -> actions.deleteMessage msg._id
	}, "x"

getError = (msg) ->
	if msg.error 
		h "div.error", msg.error
	else 
		null

getClass = (msg) ->
	if msg.deletePending 
		'.message.deletePending' 
	else
		'.message'

message = (msg, actions) ->
	return h("div#{getClass msg}",
		[
			getError msg
			deleteButton msg, actions
			h "span", msg.content
		] )

module.exports = message
