app.controller 'LoginCtrl', ($rootScope, $scope, $location, $window, $routeParams, LoginService)->
	$scope.login = new LoginService (user) -> 
		if LoginService.returnUrl?
			$location.url(LoginService.returnUrl) 
			LoginService.returnUrl = null
		else
			if user.sign_in_count is 1
				$location.url '/members/me'
			else
				$location.url '/account'
		
	$scope.login.forgot = $routeParams.forgot
	if $location.path() is '/logout'
		$scope.login.logout ->
			$location.url('/login').replace()
	else if $location.path() is '/login/forgot'
		$scope.login.forgot = true