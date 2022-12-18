require_relative 'grid'
require_relative 'input_validator'
require_relative 'player'

class Game
	CORNER_CELLS = ['a1', 'a3', 'c1', 'c3'].freeze
  MIDDLE_CELL = 'b2'.freeze

	def initialize
		self.grid = Grid.new
		self.input_validator = InputValidator.new
		self.turn_counter = 0
		self.x_player = Player.new('X')
		self.o_player = Player.new('O')
		self.current_player = self.x_player
		self.we_have_a_winner = false
		self.grid.draw
	end

	def play
		begin
			# prompt player for their cell selection
			selection = get_player_cell_selection
			# validate user input
			self.input_validator.validate_user_input(selection, self.grid.cell_hash[selection])
		rescue => e
			puts e.message
			# re-prompt the user for input if validation failed
			retry
		end

		# quit if the player enters 'q' as their selection
		abort('Quitting...') if selection == 'q'

		# update the grid with player's selection
		self.grid.update(selection, self.current_player.char)

		# increment the turn_counter
		self.turn_counter += 1

		# apply the rules of the game
		apply_rules(selection)

		# display updated grid
		self.grid.draw

		# end the game if somebody won
		abort("#{self.current_player.char}'s win!") if self.we_have_a_winner

		# end the game if the board is full and nobody has won
		abort('stalemate!') if self.we_have_a_winner == false && self.turn_counter == 9

		# switch players
		self.current_player = self.current_player == self.x_player ? self.o_player : self.x_player

		# play another turn
		play
	end

	private

	attr_accessor :grid,
		:turn_counter,
		:we_have_a_winner,
		:input_validator,
		:current_player,
		:x_player,
		:o_player

	def get_player_cell_selection
		self.current_player.get_cell_selection
	end

	def apply_rules(selection)
		# the minimum number of turns to win is 5, no need to apply
		# the rules if we haven't had the chance to have a winner
		return if self.turn_counter < 5

		# discern which rules need to be applied based on selection
    # all cells need row and column rules applied
    rules_to_apply = [:row_rule, :column_rule]
    # the diagonal rule only applies to the corner cells and the middle cell
    rules_to_apply << :diagonal_rule if CORNER_CELLS.include?(selection) || selection == MIDDLE_CELL

    # apply the relevant rules
	  rules_to_apply.each do |rule|
	  	send(rule, selection)
	  	break if self.we_have_a_winner
	  end
	end

	def row_rule(selection)
		# find out which row we're dealing with
	  row = selection.chars[0]
	  # get a list of all the cells in that row
	  row_cells = ["#{row}1", "#{row}2", "#{row}3"]
	  # remove selection from the list of cells
	  cells_to_analyze = row_cells.delete_if { |cell| cell == selection }
	  # for each cell we must look at
	  cells_to_analyze.each do |cell|
	  	# bail out as soon as it's clear that self.current_player.char isn't present contiguously
	    return unless self.grid.cell_hash[cell] == self.grid.cell_hash[selection]
	  end
	  # if we get here, self.current_player.char's won
	  self.we_have_a_winner = true
	end

	def column_rule(selection)
		# find out which column we're dealing with
	  column = selection.chars[1]
	  # get a list of all the cells in that column
	  column_cells = ["a#{column}", "b#{column}", "c#{column}"]
	  # remove selection from the list of cells
	  cells_to_analyze = column_cells.delete_if { |cell| cell == selection }
	  # for each cell we must look at
	  cells_to_analyze.each do |cell|
	  	# bail out as soon as it's clear that self.current_player.char isn't present contiguously
	    return unless self.grid.cell_hash[cell] == self.grid.cell_hash[selection]
	  end
	  # if we get here, self.current_player.char's won
	  self.we_have_a_winner = true
	end

	def diagonal_rule(selection)
		if selection == 'b2'
			# the middle cell requires two corner checks
			# check a1 --> c3
			opposite_corner_rule('a1')
			# bail out if the first corner check passes
			return if self.we_have_a_winner == true
			# check c1 --> a3
			opposite_corner_rule('c1')
		else
			# the corner cells require one corner check
			opposite_corner_rule(selection)
		end
	end

	def opposite_corner_rule(selection)
		# resolve the opposite corner cell
		opposite_corner_row = selection.chars[0] == 'a' ? 'c' : 'a'
		opposite_corner_column = selection.chars[1] == '1' ? '3' : '1'
		opposite_corner_cell = opposite_corner_row + opposite_corner_column
		cells_to_analyze = ['b2', opposite_corner_cell]
		# for each cell we must look at
		cells_to_analyze.each do |cell|
			# bail out as soon as it's clear that self.current_player.char isn't present contiguously
	    return unless self.grid.cell_hash[cell] == self.grid.cell_hash[selection]
	  end
	  # if we get here, self.current_player.char's won
	  self.we_have_a_winner = true
	end
end
