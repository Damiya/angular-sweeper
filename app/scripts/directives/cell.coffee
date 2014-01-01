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
          element.children().addClass('mined')
        else
          if cell.hasFlag
            element.children().addClass('misflagged')
          else
            element.children().text(cell.count) if cell.count > 0

      updateFlag = (value) ->
        if value
          element.children().addClass('flagged')
        else
          element.children().removeClass('flagged')


      scope.$watch('cell.visible', (newVal) ->
        updateVisibility() if newVal
      )

      scope.$watch('cell.hasFlag', (newVal) ->
        updateFlag(newVal)
      )

      return # Explicit return because otherwise Angular thinks I'm returning some aspect of the DOM which makes it unhappy
  )
