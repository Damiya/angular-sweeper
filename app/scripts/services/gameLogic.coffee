'use strict'

angular.module('minesweeperApp')
  .factory 'gameFactory', () ->
    {
      getNewGame: () ->
        game = new Game()
        game
    }

class Cell
  constructor: (@x, @y) ->
    @hasMine = false
    @hasFlag = false
    @visible = false
    @adjacentCells = []

  setFlag: (value) ->
    unless @visible
      @hasFlag = value

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

  flag: (x,y) ->
    return unless @game.status == "inProgress" # Noop if the game is over
    cell = @getCell(x,y)
    cell.setFlag(!cell.hasFlag)

  reveal: (x,y) ->
    return unless @game.status == "inProgress" # Noop if the game is over
    cell = @getCell(x,y)
    if cell.hasFlag
      return # Clicking on a cell with a flag does nothing

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
    @eachCell((cell) ->
      cell.uncover()
    )

  randomInRange: (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

  getRandomCell: () ->
    x = @randomInRange(0, @width - 1)
    y = @randomInRange(0, @height - 1)
    @getCell(x, y)

  setupMines: () ->
    mineCount = 0
    while mineCount<@numMines # While loop guarantees numMines (prevents dupe results from getRandomCell)
      cell = @getRandomCell()
      unless cell.hasMine
        cell.hasMine = true
        mineCount++

  createCells: () ->
    for y in [0..@height - 1]
      row = []
      for x in [0..@width - 1]
        row.push(new Cell(x, y))
      @rows.push(row)

  eachCell: (func) ->
    for row in @rows
      for cell in row
        func(cell)

  setupBoard: () ->
    self = this # Reference for the eachCell closure later

    @createCells()

    @eachCell((cell) ->
      self.setAdjacentCells(cell)
    )

    @setupMines()

    @eachCell((cell) ->
      cell.updateCount()
    )

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
