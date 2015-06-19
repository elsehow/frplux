_ = require 'lodash'
React = require 'react'
noJsxMixin = require "react-no-jsx/mixin"
Notification = require './notification.coffee'

Toolbar = React.createClass
	displayName: "Toolbar"
	mixins: [noJsxMixin]
		
	notifications: () ->
		if @props.state.loadingNotifications
			"loading......"
		else 
			_.map @props.state.notifications, (n) =>
				[Notification, { 
					key: n._id
					notification: n 
					actions: @props.actions }]

	renderTree: () ->
		["div", { className: "toolbar"},
			["h2", "coolbook"],
			["div", { className: "notificationsContainer" }, @notifications()]
		]
		

module.exports  = Toolbar
