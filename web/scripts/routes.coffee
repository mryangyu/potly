# http://stackoverflow.com/questions/21630534/node-js-angular-js-caution-provisional-headers-are-shown

app.config ($routeProvider, $locationProvider, $httpProvider) ->
	$httpProvider.interceptors.push('opHttp')

	$routeProvider
		.when '/', 
			title: 'Home'
			controller: 'HomeCtrl'
			templateUrl: 'tmpl/home.html'

		.when '/alerts', 
			title: 'Alerts'
			controller: 'AlertsCtrl'
			templateUrl: 'tmpl/alerts.html'

		.when '/dashboard', 
			title: 'Dashboard'
			controller: 'DashboardCtrl'
			templateUrl: 'tmpl/dashboard.html'

		.when '/settings', 
			title: 'Settings'
			controller: 'SettingsCtrl'
			templateUrl: 'tmpl/settings.html'

		.otherwise
			redirectTo: '/'
			
	$locationProvider
		.html5Mode(enabled: true, requireBase: false)
		.hashPrefix('!')