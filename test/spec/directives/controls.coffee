'use strict'

describe 'Directive: controls', () ->

  # load the directive's module
  beforeEach module 'minesweeperApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<controls></controls>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the controls directive'
