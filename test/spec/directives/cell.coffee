'use strict'

describe 'Directive: cell', () ->

  # load the directive's module
  beforeEach module 'minesweeperApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<cell></cell>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the cell directive'
