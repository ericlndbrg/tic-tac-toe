# frozen_string_literal: true

# this class defines and applies the rules of the game
class Referee
  CORNER_CELLS = %w[a1 a3 c1 c3].freeze
  MIDDLE_CELL = 'b2'

  def winner_found?(selection, grid, turn_count)
    # the minimum number of turns to win is 5, no need to apply
    # the rules if we haven't had the chance to have a winner yet
    return false if turn_count < 5

    # discern which rules need to be applied based on selection
    #   all cells need row and column rules applied, but
    #   the diagonal rule only applies to the corner cells and the middle cell
    rules_to_apply = gather_relevant_rules(selection)

    # apply the relevant rules
    rules_to_apply.each do |rule|
      return true if send(rule, selection, grid)
    end

    # if we get here, the current player didn't win
    false
  end

  private

  def gather_relevant_rules(selection)
    relevant_rules = %i[winner_in_row? winner_in_column?]

    if CORNER_CELLS.include?(selection) || selection == MIDDLE_CELL
      relevant_rules << :winner_in_diagonal?
    end

    relevant_rules
  end

  def winner_in_row?(selection, grid)
    # find out which row we're dealing with
    row = selection.chars[0]
    # get a list of all the cells in that row
    row_cells = ["#{row}1", "#{row}2", "#{row}3"]
    # remove selection from the list of cells
    cells_to_analyze = remove_irrelevant_cell(row_cells, selection)
    # look for an unbroken chain of X's or O's horizontally
    chars_contiguous?(cells_to_analyze, grid, selection)
  end

  def winner_in_column?(selection, grid)
    # find out which column we're dealing with
    column = selection.chars[1]
    # get a list of all the cells in that column
    column_cells = ["a#{column}", "b#{column}", "c#{column}"]
    # remove selection from the list of cells
    cells_to_analyze = remove_irrelevant_cell(column_cells, selection)
    # look for an unbroken chain of X's or O's vertically
    chars_contiguous?(cells_to_analyze, grid, selection)
  end

  def winner_in_diagonal?(selection, grid)
    if selection == MIDDLE_CELL
      # the middle cell requires two corner checks
      # check a1 --> c3 and bail out if it passes
      return true if winner_in_opposite_corner?('a1', grid)

      # check c1 --> a3
      winner_in_opposite_corner?('c1', grid)
    else
      # the corner cells require one corner check
      winner_in_opposite_corner?(selection, grid)
    end
  end

  def winner_in_opposite_corner?(selection, grid)
    # resolve the opposite corner cell
    opposite_corner_row = selection.chars[0] == 'a' ? 'c' : 'a'
    opposite_corner_column = selection.chars[1] == '1' ? '3' : '1'
    opposite_corner_cell = opposite_corner_row + opposite_corner_column
    cells_to_analyze = ['b2', opposite_corner_cell]
    # look for an unbroken chain of X's or O's diagonally
    chars_contiguous?(cells_to_analyze, grid, selection)
  end

  def remove_irrelevant_cell(cells, selection)
    cells.reject { |cell| cell == selection }
  end

  def chars_contiguous?(cells_to_analyze, grid, selection)
    cells_to_analyze.each do |cell|
      # bail out as soon as it's clear that char isn't present contiguously
      return false unless grid.cell_hash[cell] == grid.cell_hash[selection]
    end
    # if we get here, the current player won
    true
  end
end
