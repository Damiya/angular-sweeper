'use strict'

angular.module('minesweeperApp')
  .factory 'gameFactory', () ->
    # Service logic
    # ...

    # Public API here
    {
      getNewGame: () ->
        game = new Game()
        game
    }

class Cell
  constructor: (@x, @y) ->
    @hasMine = false
    @visible = false
    @adjacentCells = []

  explode: () ->
    console.log "You lose"

  interact: () ->
    @visible = true
    if @count == 0
      for cell in @adjacentCells
        if cell.count == 0
          console.log("Something's happening here")

  updateCount: () ->
    @count = 0
    for cell in @adjacentCells
      if cell.hasMine
        @count++


class Board
  constructor: (@width, @height, @numMines) ->
    @rows = []

  directionGrid: [
    {x: 0, y: 1},
    # N
    {x: 1, y: -1},
    {x: 1, y: 0},
    # E
    {x: 1, y: 1},
    {x: 0, y: -1},
    # S
    {x: -1, y: -1},
    {x: -1, y: 0},
    # W
    {x: -1, y: 1}
  ]

  getCell: (x, y) ->
    if x < 0 || y < 0 || x > @width - 1 || y > @height - 1
      undefined
    else
      @rows[y][x]

  setAdjacentCells: (cell) ->
    cellX = cell.x
    cellY = cell.y
    for direction in @directionGrid
      modX = direction.x
      modY = direction.y
      neighborCell = @getCell(cellX + modX, cellY + modY)
      cell.adjacentCells.push(neighborCell) if neighborCell

  randomInRange: (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

  getRandomCell: () ->
    x = @randomInRange(0, @width - 1)
    y = @randomInRange(0, @height - 1)
    @getCell(x, y)

  setupMines: () ->
    # There's the potential for duplicates in getRandomCell so we should do some checking to make sure we get an acceptable number of mines
    # Could make it a while loop?
    for i in [1..@numMines]
      cell = @getRandomCell()
      cell.hasMine = true
      console.log "Mined #{i}: #{cell.x}, #{cell.y}"

  createCells: () ->
    for y in [0..@height - 1]
      row = []
      for x in [0..@width - 1]
        row.push(new Cell(x, y))
      @rows.push(row)

  setupBoard: () ->
    @createCells()

    for row in @rows
      for cell in row
        @setAdjacentCells(cell)

    @setupMines()

    for row in @rows
      for cell in row
        cell.updateCount()

class Game
  constructor: () ->
    console.log "Game Constructor"

  startNewGame: () ->
    @board = new Board(8, 8, 10)
    @board.setupBoard()