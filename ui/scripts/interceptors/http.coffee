app.factory 'opHttp', ($q, $log, $location, $rootScope, $window, GoogleAnalyticsService, MixpanelService, Alert, Confirm) ->

	timeout = conf.app.ui.timeout
	request: (config) ->
		config.timeout = timeout
		config.withCredentials = true

		$rootScope.ajaxCount = ($rootScope.ajaxCount ? 0) + 1
		$rootScope.busy = true unless $rootScope.busy or config.background
		GoogleAnalyticsService.trackApiCall(config) if not config.cached
		if config.method isnt 'GET'
			# remove all of the private properties used in views
			if config.data?
				config.data = _.pickGood config.data

		return config || $q.when(config)

	response: (response) ->
		$rootScope.ajaxCount-- if $rootScope.ajaxCount
		$rootScope.busy = false if $rootScope.busy and $rootScope.ajaxCount is 0

		return response || $q.when(response)

	responseError: (rejection) ->
		$rootScope.ajaxCount-- if $rootScope.ajaxCount
		done = ->
			$rootScope.busy = false if $rootScope.busy and $rootScope.ajaxCount is 0
			$q.reject(rejection)

		switch rejection.status 
			when 0
				unless rejection.config.url in [ContextProvider.getUserUrl, ContextProvider.loginUrl]
					if rejection.config.background isnt true
						new Alert('There seems to be an internet network issue. Please try again.', 'info').show(null, 5000)
			when 403
				new Alert('You are unauthorized to perform this action', 'warning').show()
				return done()
			when 401
				unless rejection.config.url in [ContextProvider.getUserUrl, ContextProvider.loginUrl]
					if $rootScope.authUser?
						MixpanelService.trackHttpRejection(rejection)
						new Confirm('It appears you are no longer logged in. Do you want to login?').show (ok) ->
							return unless ok
							$rootScope.nav.to("login") # add return rediction path
					$rootScope.deauthenticate()
				return done()
		
		MixpanelService.trackHttpRejection(rejection)

		if not _.isEmpty(rejection.data)
			new Alert(rejection.data.error ? rejection.data, 'warning').show()
			return done()
		else 
			return done()