React = require 'react'
noJsxMixin = require "react-no-jsx/mixin"

# just setting up someting goofy for the sake of a test
$ = require 'jquery'
Bacon = require 'baconjs'
bjq = require 'bacon.jquery'
bm = require 'bacon.model'
nonEmpty = (v) -> v.length > 0
$setEnabled = ($div, value) -> $div.prop('disabled', !value)

InputBox = React.createClass
	displayName: "InputBox"
	mixins: [noJsxMixin]

	componentDidMount: () ->
		$sayButton = 		$('#sayButton')
		sayInputValue = 	bjq.textFieldValue $("#sayInput")
		sayButtonEnabled = 	sayInputValue.map(nonEmpty)
		saidThings = 		sayInputValue.sampledBy $sayButton.asEventStream 'click'
		# enable / disable say button depending on the input field's value
		sayButtonEnabled.assign $setEnabled, $sayButton
		# post message on say button click
		saidThings.onValue @props.actions.postMessage

	renderTree: () ->
		return ["div", 
	        [ "input", { id: "sayInput"} ],
	        [ "button", { id: "sayButton" }, "say" ]
		]

module.exports = InputBox