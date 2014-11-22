app.controller 'HomeCtrl', ($rootScope, $scope, $http, $log, $location, $timeout) ->
	$rootScope.hide_header = true
	$timeout ->
		$location.path "/dashboard"
	, 2000