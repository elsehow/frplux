class ToolbarActions 

	# see https://github.com/elsehow/frplux/issues/5

	# the constructor returns the Actions object
	constructor: (@dispatcher) -> 
	dispatch: (msg) => @dispatcher.emit msg

	# actions here
	actions: () =>

		fetchNotifications: =>
			@dispatch
				actionType: 'fetchNotifications'
			
module.exports = ToolbarActions 