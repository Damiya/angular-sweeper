'use strict'

describe 'Service: Board', () ->

  # load the service's module
  beforeEach module 'minesweeperApp'

  # instantiate service
  Board = {}
  beforeEach inject (_Board_) ->
    Board = _Board_

  it 'should do something', () ->
    expect(!!Board).toBe true
