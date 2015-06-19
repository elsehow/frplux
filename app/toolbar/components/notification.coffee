React = require 'react'
noJsxMixin = require "react-no-jsx/mixin"

Notification = React.createClass
	mixins: [noJsxMixin]
	displayName: "Notification"

	renderTree: () ->
		["div", { className: "notification" }, @props.notification.content ]

module.exports = Notification
