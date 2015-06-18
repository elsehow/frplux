React = require 'react'
noJsxMixin = require "react-no-jsx/mixin"

getError = (msg) ->
	if msg.error then ["div", { className: 'error' },  msg.error] 
		
getMessageContent = (msg) ->
	["span", msg.content]

getClassName = (msg) ->
	if msg.deletePending then 'message deletePending' 
	else 'message'

Message = React.createClass
	mixins: [noJsxMixin]
	displayName: "Message"

	handleDelete: () ->
		@props.actions.deleteMessage(@props.message._id)

	renderTree: () ->
		return [ "div"
			, { className: getClassName(@props.message) }
			, getError(@props.message)
			, ["button", { onClick: @handleDelete }, "x"]
			, getMessageContent(@props.message)
		]

module.exports = Message
