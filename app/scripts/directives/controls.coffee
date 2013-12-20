'use strict'

angular.module('minesweeperApp')
  .directive('controls', () ->
    template: '<div></div>'
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.text 'this is the controls directive'
  )
