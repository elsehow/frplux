Freezer = require 'freezer-js'
$ = require 'jquery'
_ = require 'lodash'

actionType = (str) -> return (msg) -> msg.actionType is str
# sets side-effects of a stream given a map { "message": fn }
wire = (stream, fnMap) => 
	_.each fnMap, (fn, msg) => 
		stream
			.filter(actionType msg)
			.onValue (m) -> fn m

class ToolbarStore 

	# an immutable datastore
	store: new Freezer
		loadingNotifications: true
		notifications: {}

	# think of this like @dispatcher.register
	# see https://github.com/elsehow/frplux/issues/3
	constructor: (@dispatcher) ->
		# this object relates `message.action` strings to functions
		# check out wire function for implementation details
		# NB: you can get WAY fancier than this.
		# since @dispatcher is just a stream, you can filter, throttle, debounce, whatever!
		wire @dispatcher,
			'fetchNotifications' : @fetchNotifications
		# index subscribes to changes in this store
		return @store

	setLoadingNotifications: (value) ->
		@store.get().set 'loadingNotifications', value

	fetchNotifications: =>
		# we're starting to fetch messages now
		@setLoadingNotifications true
		# make the AJAX request
		promise = $.ajax
			url: '/notifications'
			method: 'GET'
		# if it succeeds,
		promise.done (notifications) =>
			@store.get().notifications.set notifications 
		# stop loading thing regardless
		promise.always () =>
			@setLoadingNotifications false 

module.exports = ToolbarStore 