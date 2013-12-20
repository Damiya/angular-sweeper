'use strict'

angular.module('minesweeperApp')
.directive('cell', () ->
    templateUrl: 'views/partials/cell.html'
    restrict: 'E'
    scope:
      cell: '='
      board: '='
    link: (scope, element, attrs) ->
      #console.log "Cell created with scope #{scope.$id}"
      cell = scope.cell

      updateVisibility = () ->
        element.children().addClass('visible')

        if cell.hasMine
          element.children().text("BOMB")
        else
          element.children().text(cell.count)

      scope.$watch('cell.visible', (newVal, oldVal)->
        updateVisibility() if newVal
      )

      return
  )
