React = require 'react'
noJsxMixin = require "react-no-jsx/mixin"

deleteButton = (msg, actions) ->
	return ["button", "x"]

getError = (msg) ->
	if msg.error 
		return ["div",  msg.error]
	else 
		return null

getMessageContent = (msg) ->
	return ["span", msg.content]

getClassName = (msg) ->
	if msg.deletePending 
		return '.message.deletePending' 
	else return '.message'

Message = React.createClass
	mixins: [noJsxMixin]
	displayName: "Message"

	renderTree: () ->
		return [ "div", { className: getClassName(@props.message) }
			getError(@props.message),
			deleteButton(@props.message),
			getMessageContent(@props.message)
		]

module.exports = Message
