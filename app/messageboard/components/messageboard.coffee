_ = require 'lodash'
React = require 'react'
Message = require './message.coffee'
InputBox = require './inputbox.coffee'
noJsxMixin = require "react-no-jsx/mixin"

Messageboard = React.createClass
	displayName: "Messageboard"
	mixins: [noJsxMixin]

	renderEachMessage: () ->
		return _.map @props.state.messages, (msg) =>
			return [Message, { 
				key: msg._id
				message: msg
				actions: @props.actions }]

	renderMessagesArea: () ->
		if @props.state.loadingMessages then ["div", "loading......"]
		else ["div", @renderEachMessage()]

	renderTree: () ->
		return ["div", { className: "messageboardContainer"}
			[InputBox, { actions: @props.actions }]
			@renderMessagesArea()
		]
		

module.exports  = Messageboard
