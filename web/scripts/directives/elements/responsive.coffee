app.directive "responsive", ($window, $timeout, $rootScope, $log)->
	restrict: "E"
	scope:
		containerLg: '@'
		containerMd: '@'
		containerSm: '@'
	link: ($scope, $element, $attrs) ->
		changeContainer = ->
			$newParent = null
			# TODO: fallback defaults
			if $rootScope.layout.lt('md')
				$newParent = angular.element($scope.containerSm)
			else 
				$newParent = angular.element($scope.containerMd)
			
			if $newParent?.attr('id') isnt $element.parent().attr('id')
				$element.appendTo $newParent

		changeContainer()

		$(window).on 'resize', changeContainer
		$element.bind "$destroy", -> 
			$(window).off 'resize', changeContainer
		return
