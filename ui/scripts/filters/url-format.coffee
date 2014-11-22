app.filter "urlFormat", ->
	(str) ->
		return '' unless str?.length
		str.toLowerCase().replace(' ','-')