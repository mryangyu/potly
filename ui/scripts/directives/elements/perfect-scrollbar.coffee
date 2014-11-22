# FORKED FROM: https://github.com/itsdrewmiller/angular-perfect-scrollbar
angular.module("perfect_scrollbar", []).directive "perfectScrollbar", ($parse, $timeout, $log) ->
	restrict: "E"
	transclude: true
	template: "<div><div ng-transclude></div></div>"
	replace: true
	link: ($scope, $elem, $attr) ->
		$elem.perfectScrollbar
			wheelSpeed: $parse($attr.wheelSpeed)() or 50
			wheelPropagation: $parse($attr.wheelPropagation)() or false
			minScrollbarLength: $parse($attr.minScrollbarLength)() or false
			useBothWheelAxes: $parse($attr.useBothWheelAxes)() or false
			suppressScrollX: $parse($attr.suppressScrollX)() or false
			suppressScrollY: $parse($attr.suppressScrollY)() or false

		if $attr.refreshOnChange
			$scope.$watchCollection $attr.refreshOnChange, (newNames, oldNames) ->
				$timeout (-> $elem.perfectScrollbar "update"),  10
				# MRYANGYU: Added to allow content to be docking to bottom
				if $attr.dock is "bottom"
					$timeout -> 
						$elem.animate scrollTop:$elem[0].scrollHeight
					,  200
					
				return

		$elem.bind "$destroy", ->
			$elem.perfectScrollbar "destroy"
			return

		return