app.factory 'Alert', ($rootScope, $timeout) ->

	variableDuration = 
		min: 
			char: 10
			duration: 3000
		max: 
			char: 100
			duration: 6000

		getDuration: (textLength = 0) ->
			goodLength = Math.max(@min.char, Math.min(@max.char, textLength))
			perc = (goodLength-@min.char)/(@max.char-@min.char)
			Math.floor(perc * (@max.duration - @min.duration) + @min.duration)

	class AlertDialog
		@alerts: []
		constructor: (@message, @class = "info") ->
			@obj = true if _.isObject(@message)
			@length = @_getMessageLength()
		_getMessageObjLength: ->
			length = 0
			length += val.length for key, val in @message
			length
		_getMessageLength: ->
			if @obj? then @_getMessageObjLength() else @message.length
		show: (next, duration) ->
			duration or= variableDuration.getDuration(@length)
			AlertDialog.alerts.push @
			$rootScope.safeApply()
			$timeout (=> 
				AlertDialog.alerts.remove @
				next?()
			), duration
		close: ->
			AlertDialog.alerts.remove @
