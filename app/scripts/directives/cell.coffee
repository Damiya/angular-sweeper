'use strict'

angular.module('minesweeperApp')
.directive('cell', () ->
    restrict: 'E'
    scope:
      cell: '='
      board: '='
    link: (scope, element, attrs) ->
      cell = scope.cell

      updateVisibility = () ->
        element.addClass('visible')

        if cell.hasMine
          element.addClass('mined')
        else
          if cell.hasFlag
            element.addClass('misflagged')
          else
            element.text(cell.count) if cell.count > 0

      updateFlag = (value) ->
        if value
          element.addClass('flagged')
        else
          element.removeClass('flagged')


      scope.$watch('cell.visible', (newVal) ->
        updateVisibility() if newVal
      )

      scope.$watch('cell.hasFlag', (newVal) ->
        updateFlag(newVal)
      )

      return # Explicit return because otherwise Angular thinks I'm returning some aspect of the DOM which makes it unhappy
  )
