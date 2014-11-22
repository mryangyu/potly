app.controller 'NavbarCtrl', ($rootScope, $routeParams, $scope, $http, $location, Notifications)->
	navbar = $('nav.navbar:first')
	toggle = navbar.find('.navbar-toggle:first')
	$scope.notifications = new Notifications()

	$scope.isActive = (controllers, id) -> 
		ctrlMatch = false
		idMatch = id is $routeParams.id
		if _.isArray(controllers)
			ctrlMatch = $rootScope.mainController in controllers
		else
			ctrlMatch = $rootScope.mainController is controllers
		idMatch and ctrlMatch

	$rootScope.collapsedNav = ->
		return if toggle.hasClass 'collapsed'
		toggle.click()

	navbar.on "click", "a[href]", null, -> 
		$rootScope.collapsedNav()
		
	collapser = navbar.find('.navbar-collapse')
	collapser.on 'shown.bs.collapse', -> 
		navbar.find('.expand-xs')
			.addClass('open')
			.on "hide.bs.dropdown", (e) ->
				return true unless navbar.hasClass('open')
				e.preventDefault()
				return false

		navbar.addClass('open')
	collapser.on 'hidden.bs.collapse', -> 
		navbar.removeClass('open')
