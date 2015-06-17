React = require 'react'
noJsxMixin = require "react-no-jsx/mixin"

InputBox = React.createClass
	displayName: "InputBox"
	mixins: [noJsxMixin]

	componentWillMount: () ->
		console.log 'i could set up all my shit now'

	renderTree: () ->
		return ["div", { className: "inputDiv" }
	        [ "input" ],
	        [ "button", "say" ]
		]

module.exports = InputBox