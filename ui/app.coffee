conf = require "./config/init"
express = require "express"
path = require "path"
compress = require "compression"
favicon = require "serve-favicon"
errorHandler = require "errorhandler"

app = express()

app.set "name", conf.app.name
app.set "port", process.env.PORT
app.set "view engine", "jade"
app.set "views", path.join(__dirname, "views")

app.use compress()

# app.use favicon(path.join(__dirname, "public/assets/img/favicon.png"))
app.use express.static(path.join(__dirname, "public"),
	maxAge: conf.cache.assets.age
)

require("./routes") app

if conf.env is 'development'
	app.use errorHandler(dumpExceptions: true, showStack: true)

module.exports = app