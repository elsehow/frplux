_ = require 'lodash'
React = require 'react'
Message = require './message.coffee'
InputBox = require './inputbox.coffee'
noJsxMixin = require "react-no-jsx/mixin"

Messageboard = React.createClass
	displayName: "Messageboard"
	mixins: [noJsxMixin]

	messages: () ->
		
	messages: () ->
		if @props.state.loadingMessages
			"loading......"
		else 
			_.map @props.state.messages, (msg) =>
				[Message, { 
					key: msg._id
					message: msg
					actions: @props.actions }]

	renderTree: () ->
		["div", { className: "messageboardContainer"}
			[InputBox, { actions: @props.actions }]
			["div", { className: "messagesContainer" }, @messages()]
		]
		

module.exports  = Messageboard
