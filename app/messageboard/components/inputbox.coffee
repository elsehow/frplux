h = require "virtual-dom/h"

inputbox = (actions) ->

	return h("div", [
        h "input#postInput"
        h "button#postButton", "say"
		])

module.exports = inputbox