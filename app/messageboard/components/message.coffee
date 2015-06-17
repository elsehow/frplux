# h = require "virtual-dom/h"
React = require 'react'

deleteButton = (msg, actions) ->
	React.createElement("button", null, "x")

getError = (msg) ->
	if msg.error 
		React.createClass "div", null, msg.error
	else 
		return null

# getClass = (msg) ->
# 	if msg.deletePending 
# 		return '.message.deletePending' 
# 	else
# 		return '.message'


Message = React.createClass
	# 	displayName: "HelloMessage"
	render: () ->
		console.log '???', @props
		return React.createElement "div", null, 
			getError(@props.children),
			deleteButton(@props.children),
			React.createElement("span", null, @props.children.content)


module.exports = Message
