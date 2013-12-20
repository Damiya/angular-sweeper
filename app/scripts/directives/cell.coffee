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
          element.children().text('B')
        else
          element.children().text(cell.count) if cell.count > 0

      scope.$watch('cell.visible', (newVal, oldVal)->
        updateVisibility() if newVal
      )

      return
  )
