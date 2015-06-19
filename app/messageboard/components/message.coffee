React = require 'react'
noJsxMixin = require "react-no-jsx/mixin"

Message = React.createClass
	mixins: [noJsxMixin]
	displayName: "Message"

	getError: (msg) ->
		if msg.error then ["div", { className: 'error' },  msg.error]
		else null 
			
	messageContent: (msg) -> 
		msg.content

	className: (msg) ->
		if msg.deletePending then 'message deletePending' 
		else 'message'

	handleDelete: () -> 
		@props.actions.deleteMessage @props.message._id

	renderTree: () ->
		["div", { className: @className @props.message }
			, @getError(@props.message)
			, ["button", { onClick: @handleDelete }, "x"]
			, ["span", @messageContent(@props.message) ] ]

module.exports = Message
