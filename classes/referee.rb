# frozen_string_literal: true

# this class defines and applies the rules of the game
class Referee
  CORNER_CELLS = %w[a1 a3 c1 c3].freeze
  MIDDLE_CELL = 'b2'

  def apply_rules(selection, grid, turn_count)
    # the minimum number of turns to win is 5, no need to apply
    # the rules if we haven't had the chance to have a winner
    return if turn_count < 5

    # discern which rules need to be applied based on selection
    # all cells need row and column rules applied
    rules_to_apply = %i[row_rule column_rule]
    # the diagonal rule only applies to the corner cells and the middle cell
    rules_to_apply << :diagonal_rule if CORNER_CELLS.include?(selection) || selection == MIDDLE_CELL

    # apply the relevant rules
    rules_to_apply.each do |rule|
      return true if send(rule, selection, grid)
    end
    # if we get here, the current player didn't win
    false
  end

  def row_rule(selection, grid)
    # find out which row we're dealing with
    row = selection.chars[0]
    # get a list of all the cells in that row
    row_cells = ["#{row}1", "#{row}2", "#{row}3"]
    # remove selection from the list of cells
    cells_to_analyze = row_cells.delete_if { |cell| cell == selection }
    # for each cell we must look at
    cells_to_analyze.each do |cell|
      # bail out as soon as it's clear that self.current_player.char isn't present contiguously
      return false unless grid.cell_hash[cell] == grid.cell_hash[selection]
    end
    # if we get here, self.current_player.char's won
    true
  end

  def column_rule(selection, grid)
    # find out which column we're dealing with
    column = selection.chars[1]
    # get a list of all the cells in that column
    column_cells = ["a#{column}", "b#{column}", "c#{column}"]
    # remove selection from the list of cells
    cells_to_analyze = column_cells.delete_if { |cell| cell == selection }
    # for each cell we must look at
    cells_to_analyze.each do |cell|
      # bail out as soon as it's clear that self.current_player.char isn't present contiguously
      return false unless grid.cell_hash[cell] == grid.cell_hash[selection]
    end
    # if we get here, self.current_player.char's won
    true
  end

  def diagonal_rule(selection, grid)
    if selection == MIDDLE_CELL
      # the middle cell requires two corner checks
      # check a1 --> c3
      # bail out if the first corner check passes
      return true if opposite_corner_rule('a1', grid)

      # check c1 --> a3
      opposite_corner_rule('c1', grid)
    else
      # the corner cells require one corner check
      opposite_corner_rule(selection, grid)
    end
  end

  def opposite_corner_rule(selection, grid)
    # resolve the opposite corner cell
    opposite_corner_row = selection.chars[0] == 'a' ? 'c' : 'a'
    opposite_corner_column = selection.chars[1] == '1' ? '3' : '1'
    opposite_corner_cell = opposite_corner_row + opposite_corner_column
    cells_to_analyze = ['b2', opposite_corner_cell]
    # for each cell we must look at
    cells_to_analyze.each do |cell|
      # bail out as soon as it's clear that self.current_player.char isn't present contiguously
      return false unless grid.cell_hash[cell] == grid.cell_hash[selection]
    end
    # if we get here, self.current_player.char's won
    true
  end
end
