'use strict'

angular.module('minesweeperApp')
  .directive('ngRightClick', ($parse) ->
    (scope, element, attrs) ->
      fn = $parse(attrs.ngRightClick)
      element.bind('contextmenu', (event) ->
        scope.$apply(() ->
          event.preventDefault()
          fn(scope, {$event:event})
        )
      )
  )