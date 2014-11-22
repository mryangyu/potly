app.filter "readable", ->
	(obj) ->
		return "" unless obj
		if _.isArray(obj)
			obj.join(', ')
		else if _.isString(obj)
			obj
		else 
			JSON.stringify(obj)