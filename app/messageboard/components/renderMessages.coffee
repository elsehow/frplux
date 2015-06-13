$ = require 'jquery'
_ = require 'lodash'

messageDiv = (message) ->
	html = _.template('''
		<div class = "message <%= deletePending %>">
			<% if (error) { %>
				<div class = "error"> <%= error %> </div>
			<% } %>
			<button class = "delete" data-messageid="<%= message._id %>"> x </button>
			<%= message.content %>
		</div>
		''')({
			message : message
			deletePending : if message.deletePending then 'deletePending' else null
			error : if message.error then message.error else null
			})
	$(html)

renderMessages = ($div, messages) ->
	_.each messages, (msg) ->
		$div.append messageDiv msg

module.exports =renderMessages 