express = require 'express'
path = require 'path'
app = express()
server = require('http').Server(app);
bodyParser = require 'body-parser'
logger = require 'express-logger'
fs = require 'fs'
randomInRange = require 'random-number-in-range'

delay = (t, cb) -> setTimeout cb, t

fakeDb =  
	"1":    
		"_id": "1"
		"content": "is this tite" 

	"2": 
		"_id": "2",
		"content": "will i ever die" 

	"3": 
		"_id": "3"
		"content": "does she love me" 


#
# express config
#
port = 3000
publicDir = "#{__dirname}/dist"
app.use express.static publicDir
app.use bodyParser.json()
# debug logger
app.use logger {path: './logs/logfile.txt'}

read = (file) ->
    fs.createReadStream path.join publicDir, file

#
# HTTP routes
#
app.get '/', (req, res) -> read 'index.html' .pipe res 

app.get '/messages', (req, res) -> 
	delay 500, () -> res.json fakeDb

app.delete '/messages', (req, res) -> 
	messageID = req.body.messageID
	# a fake wait time
	delay 1000, () ->
		# 1 in 2 chance that the request fails
		if randomInRange() < 50
			res.json { messageID: messageID }
		else
			res.sendStatus 500
#
# run server
#
server.listen port
console.log 'server listening on ' + port
