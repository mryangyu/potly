require('coffee-script/register');
var http = require("http"),
		app = require('./app')

instance = http.createServer(app).listen(app.get('port'), function() {
	console.log(app.get('name') + ' server started on port ' + app.get('port') + '...')
});

module.exports = instance