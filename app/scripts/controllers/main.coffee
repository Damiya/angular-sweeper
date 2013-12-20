'use strict'

angular.module('minesweeperApp')
  .controller 'MainCtrl', ["$scope","gameFactory",
    ($scope,gameFactory) ->
      $scope.game = gameFactory.getNewGame()
      $scope.game.startNewGame()
  ]
