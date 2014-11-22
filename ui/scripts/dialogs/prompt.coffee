app.factory 'Prompt', ->
	class PromptDialog
		constructor: (@msg, @defaultValue = "") ->
		show: (next) ->
			input = prompt(@msg, @defaultValue) # TODO upgrade to nicer dialog
			next?(input)
