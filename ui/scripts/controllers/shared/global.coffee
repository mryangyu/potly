app.controller 'GlobalCtrl', ($rootScope, $scope, $timeout, $log, SignupService, LoginService, Alert, MixpanelService)->
	authorizeModal = $('#authorize.modal:first')

	$scope.alerts = Alert.alerts

	$rootScope.requireAuth = (done, action="action", accountTypes = ["consumer","entertainer","agency"], city) ->
		return if authorizeModal.hasClass('in') # already open

		ZopimService.enableChat()
		
		if $rootScope.authUser?
			$log.debug accountTypes, $rootScope.authUser.account.type
			if $rootScope.authUser.account.type in accountTypes
				return done($rootScope.authUser)
			else
				new Alert("You are not authorized to #{action}", "warning").show()
				return done() 

		city = $rootScope.nav.city unless city?
		
		_authUser = null
		authenticated = (authUser) ->
			_authUser = authUser
			authorizeModal.modal('hide')
			new Alert("Now back to #{action}...").show()

		loginAuthenticated = (authUser) ->
			MixpanelService.trackRequireAuth "login", action, authUser
			authenticated(authUser)

		signUpAuthenticated = (authUser) ->
			MixpanelService.trackRequireAuth "signup", action, authUser
			authenticated(authUser)
		
		authorizeModal.off()
		$scope.action = action
		$scope.accountTypes = accountTypes
		$scope.signup = new SignupService(signUpAuthenticated)
		$scope.login = new LoginService(loginAuthenticated)
		$scope.signup.account.city_id = city.id if city?
		$rootScope.safeApply() # show does not trigger angular binding

		authorizeModal.modal('show')
		MixpanelService.trackRequireAuth "show", action

		authorizeModal.on 'hide.bs.modal', (e) ->
			MixpanelService.trackRequireAuth "cancel", action unless _authUser?
			$rootScope.nav.leaveWarningOff()
			done(_authUser)
			return true

		authorizeModal.on 'hidden.bs.modal', (e) ->
			authorizeModal.off()
			finish = null
			$scope.signup = null
			$scope.login = null
			$scope.accountTypes = null
			return