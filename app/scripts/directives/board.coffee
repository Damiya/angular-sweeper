'use strict'

angular.module('minesweeperApp')
  .directive('board', () ->
    templateUrl: 'views/partials/board.html'
    restrict: 'E'
    link: (scope, element, attrs) ->
      console.log("Board created with scope: #{scope.$id}")

  )
