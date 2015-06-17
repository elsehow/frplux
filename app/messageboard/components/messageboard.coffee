_ = require 'lodash'
React = require 'react'
Message = React.createFactory require './message.coffee'
# inputbox = require './inputbox.coffee'

Messageboard = React.createClass
	render: () ->
		if @props.loadingMessages
			return React.createElement("div", null, "loading......")
		return React.createElement("div"
			, null
			, _.map @props.messages, (msg) -> 
				Message(key=msg._id, message=msg))

module.exports  = Messageboard

# Timer = React.createClass(
# 	displayName: "Timer"
# 	getInitialState: () ->
# 		return {secondsElapsed: 0}

# 	tick: () ->
# 		this.setState({secondsElapsed: this.state.secondsElapsed + 1})

# 	componentDidMount: () ->
# 		this.interval = setInterval(this.tick, 1000)

# 	componentWillUnmount: () ->
# 		clearInterval(this.interval)

# 	render: () ->
# 		return (
# 			React.createElement("div", null, "Seconds Elapsed: ", this.state.secondsElapsed)
# 		)
# )

# module.exports = Timer