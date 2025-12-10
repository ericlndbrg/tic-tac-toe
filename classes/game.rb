# frozen_string_literal: true

class Game
  ROW_LETTERS = ['A', 'B', 'C'].freeze
  COLUMN_NUMBERS = ['1', '2', '3'].freeze
  TOP_BOTTOM_BORDER = '  +-------+'
  DEFAULT_CELL_VALUE = '-'
  PLAYERS = 'XO'

  attr_accessor :turn_counter
  attr_reader :player, :winner

  def initialize
    self.grid = []
    3.times { self.grid.push(Array.new(3, DEFAULT_CELL_VALUE)) }
    self.player = PLAYERS[0]
    self.turn_counter = 0
    self.winner = nil
  end

  def draw_grid
    puts "    #{COLUMN_NUMBERS.join(' ')}"
    puts TOP_BOTTOM_BORDER

    grid.each_with_index do |row, index|
      print "#{ROW_LETTERS[index]} | "
      row.each { |cell| print "#{cell} " }
      puts '|'
    end

    puts TOP_BOTTOM_BORDER
  end

  def update_cell(cell)
    self.coordinates = cell_to_coords(cell)

    # the cell state must be '-' prior to the transition
    unless grid[coordinates[0]][coordinates[1]] == DEFAULT_CELL_VALUE
      raise 'that cell has already been taken'
    end

    self.grid[coordinates[0]][coordinates[1]] = player
  end

  def apply_rules(cell)
    return if turn_counter < 5

    rules_to_apply = [:row?, :col?]

    case cell
    when 'B2'
      rules_to_apply.push(:diag_nw_se?, :diag_sw_ne?)
    when 'A1', 'C3'
      rules_to_apply.push(:diag_nw_se?)
    when 'C1', 'A3'
      rules_to_apply.push(:diag_sw_ne?)
    end

    rules_to_apply.each do |rule|
      if send(rule)
        self.winner = player
        break
      end
    end

    return if winner

    self.winner = 'nobody' if turn_counter == 9
  end

  def switch_players
    self.player = player == PLAYERS[0] ? PLAYERS[1] : PLAYERS[0]
  end

  private

  attr_accessor :grid, :coordinates
  attr_writer :player, :winner

  def cell_to_coords(cell)
    # cell must be only 2 characters
    raise 'invalid cell selection' if cell.length != 2
    # the 2 characters must represent a cell on the grid
    raise 'invalid row selection' unless ROW_LETTERS.include?(cell[0])
    raise 'invalid column selection' unless COLUMN_NUMBERS.include?(cell[1])

    [ROW_LETTERS.index(cell[0]), COLUMN_NUMBERS.index(cell[1])]
  end

  def row?
    grid[coordinates[0]].all?(player)
  end

  def col?
    [grid[0][coordinates[1]], grid[1][coordinates[1]], grid[2][coordinates[1]]].all?(player)
  end

  def diag_nw_se?
    # A1, B2, C3
    [grid[0][0], grid[1][1], grid[2][2]].all?(player)
  end

  def diag_sw_ne?
    # C1, B2, A3
    [grid[2][0], grid[1][1], grid[0][2]].all?(player)
  end
end
