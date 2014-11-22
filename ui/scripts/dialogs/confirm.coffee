app.factory 'Confirm', ($rootScope) ->
	class ConfirmDialog
		constructor: (@message, @action, @title, @cancellable=true, @cancelAction) ->
			@modal = $('#confirm.modal:first')
		show: (next) ->
			$rootScope.confirm = @
			@modal.modal('show')
			@modal.on 'hidden.bs.modal', (e) => 
				@modal.off()
				next(@ok)
				$rootScope.safeApply()
				return
			return
		submit: (ok) ->
			@ok = ok
			@modal.modal('hide')
			return