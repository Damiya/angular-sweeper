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

  uncover: () ->
    @visible = true

  updateCount: () ->
    @count = 0
    for cell in @adjacentCells
      if cell.hasMine
        @count++


class Board
  constructor: (@width, @height, @numMines, @game) ->
    @rows = []
    @updateList = []

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

  interact: (x,y) ->
    return unless @game.status == "inProgress" # Noop if the game is over
    cell = @getCell(x,y)
    if cell.hasMine
      cell.uncover()
      @game.gameOver(false)
      return
    @updateList = [cell]
    @performCellUpdateCascade()

  performCellUpdateCascade: () ->
    cell = @updateList.pop()
    cell.uncover()
    if cell.count == 0
      for adjCell in cell.adjacentCells
        @updateList.push(adjCell) if !adjCell.visible
    @performCellUpdateCascade() unless @updateList.length==0

  revealAll: () ->
    for row in @rows
      for cell in row
        cell.uncover()

  randomInRange: (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

  getRandomCell: () ->
    x = @randomInRange(0, @width - 1)
    y = @randomInRange(0, @height - 1)
    @getCell(x, y)

  setupMines: () ->
    mineCount = 0
    while mineCount<@numMines
      cell = @getRandomCell()
      unless cell.hasMine # If we want 10 mines, we need 10 mines. This prevents dupe results from getRandomCell
        cell.hasMine = true
        mineCount++

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
    @status = ""

  startNewGame: () ->
    @board = new Board(8, 8, 10, this)
    @status = "inProgress" #Todo: Pull these out someplace to be reused and sync'd into our non-model logic
    @board.setupBoard()

  gameOver: (wasVictory) ->
    if wasVictory
      @status = "victory"
      @board.revealAll()
      alert("You win!")
    else
      @status = "failure"
      @board.revealAll()
      alert("You lose!")
