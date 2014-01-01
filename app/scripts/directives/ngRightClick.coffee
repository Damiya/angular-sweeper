'use strict'

#Courtesy Bastien Caudan
#http://stackoverflow.com/questions/15731634/how-do-i-handle-right-click-events-in-angular-js
# Super elegant solution. Thanks Bastien

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