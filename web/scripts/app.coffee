# app.js file will be generated using grunt compress, or there is a watch #
app = angular.module(conf.app.site_name, [
		'ngRoute'
		'ngAnimate'
		'ngCookies'
		'angularMoment'
		'angular-loading-bar'
		'perfect_scrollbar'
		'infinite-scroll'
		'angularFileUpload'
		'nya.bootstrap.select'
		'oc.lazyLoad'
	])

app.config ($logProvider, $provider) ->
	$logProvider.debugEnabled(conf.app.console.debug)
	#  $provide.decorator '$log', -> 
	# to override: http://vinnylinck.tumblr.com/post/58833687265/angularjs-how-to-override-log-implementation

app.config (cfpLoadingBarProvider) ->
	cfpLoadingBarProvider.includeBar = true;
	cfpLoadingBarProvider.includeSpinner = false
	cfpLoadingBarProvider.latencyThreshold = 100

# app.constant 'angularMomentConfig',
# 	preprocess: 'utc'

app.run ($rootScope, $location, $routeParams, $window, $http, $templateCache, $filter, $log) ->
	FastClick.attach document.body
	$log.info 'App loaded'
	
	$rootScope.env = env
	$rootScope.conf = conf

	$rootScope.isBinding = ->
		$rootScope.$$phase in ["$apply", "$digest"]

	$rootScope.safeApply = ->
		$rootScope.$apply() if not $rootScope.isBinding()

		# not angular safe
	$rootScope.onLoaded = (next) ->
		setTimeout =>
			return next?() if $rootScope.ajaxCount is 0 and not $rootScope.isBinding()
			$rootScope.onLoaded(next)
		, 800

	$rootScope.template = ->
		for template in arguments
			template = $filter('urlFormat')(template)
			if $templateCache.get template
				return template
		return
