conf = require './config/init'
url = require 'url'

module.exports = (app) ->
	app.get '/_info', (req, res) ->
		res.json 
			app: conf.app.name
			env: conf.env
			status: 'online'

	# TODO: this should really be part of the compiled assets, but that won't work since at compile time the environment is using development
	app.get "/js/conf.js", (req,res) ->
		# configuration needed by client
		data = 
			env: conf.env
			app: conf.app
			endpoints: conf.endpoints
			public_keys: conf.public_keys
		
		res.setHeader 'content-type', 'text/javascript'
		res.send "var conf = #{JSON.stringify(data)};"

	# all other routes
	app.get "/*", (req, res) ->
		# environment varaibles needed by server views
		res.render "server/root",
			env: 
				site_name: conf.app.site_name
				proxy: conf.proxy
				public_keys: conf.public_keys
				version: 1
