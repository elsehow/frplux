_ = require 'lodash'
React = require 'react'
Message = require './message.coffee'
InputBox = require './inputbox.coffee'
noJsxMixin = require "react-no-jsx/mixin"

Messageboard = React.createClass
	displayName: "Messageboard"
	mixins: [noJsxMixin]

	renderEachMessage: () ->
		return _.map @props.messages, (msg) ->
			return [Message, { key: msg._id, message: msg }]

	renderMessagesArea: () ->
		if @props.loadingMessages then return ["div", "loading......"]
		else return ["div", @renderEachMessage()]

	renderTree: () ->
		return ["div", { className: "messageboardContainer"}
			[InputBox]
			@renderMessagesArea()
		]
		

module.exports  = Messageboard
