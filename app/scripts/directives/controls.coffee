'use strict'

angular.module('minesweeperApp')
  .directive('controls', () ->
    templateUrl: 'views/partials/controls.html'
    restrict: 'E'
    link: (scope, element, attrs) ->
      scope.startNewGame = () ->
        scope.game.startNewGame()
  )
