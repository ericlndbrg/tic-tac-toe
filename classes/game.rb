class Game
	VALID_USER_INPUT = ['a1', 'a2', 'a3', 'b1', 'b2', 'b3', 'c1', 'c2', 'c3', 'q'].freeze
	CORNER_CELLS = ['a1', 'a3', 'c1', 'c3'].freeze
  MIDDLE_CELL = 'b2'.freeze

	def initialize
		self.grid = {
		  'a1' => ' ', 'a2' => ' ', 'a3' => ' ',
		  'b1' => ' ', 'b2' => ' ', 'b3' => ' ',
		  'c1' => ' ', 'c2' => ' ', 'c3' => ' '
		}
		self.turn_counter = 0
		self.char = 'X'
		self.we_have_a_winner = false
		draw_grid
	end

	def play
		begin
			# prompt player for selection
			selection = get_user_selection
			# validate user input
			validate_user_input(selection)
		rescue => e
			puts e.message
			# re-prompt the user for input if validation failed
			retry
		end

		# quit if the player enters 'q' as their selection
		abort('Quitting...') if selection == 'q'

		# update the grid with player's selection
		self.grid[selection] = self.char

		# increment the turn_counter
		self.turn_counter += 1

		# apply the rules of the game
		apply_rules(selection)

		# display updated grid
		draw_grid

		# end the game if somebody won
		abort("#{self.char}'s win!") if self.we_have_a_winner

		# end the game if the board is full and nobody has won
		abort('stalemate!') if self.we_have_a_winner == false && self.turn_counter == 9

		# switch chars
		self.char = self.char == 'X' ? 'O' : 'X'

		# play another turn
		play
	end

	private

	attr_accessor :grid, :turn_counter, :char, :we_have_a_winner

	def draw_grid
		puts '    1   2   3'
		puts '  -------------'
		puts "A | #{self.grid['a1']} | #{self.grid['a2']} | #{self.grid['a3']} |"
		puts '  -------------'
		puts "B | #{self.grid['b1']} | #{self.grid['b2']} | #{self.grid['b3']} |"
		puts '  -------------'
		puts "C | #{self.grid['c1']} | #{self.grid['c2']} | #{self.grid['c3']} |"
		puts '  -------------'
	end

	def get_user_selection
		puts "Enter 'q' to quit"
		print 'Enter a selection: '
		gets.chomp
	end

	def validate_user_input(selection)
		# check if the input is allowed
		unless VALID_USER_INPUT.include?(selection)
			raise(StandardError, 'invalid input, please try again')
		end

		# break out if selection == 'q'
		return if selection == 'q'

		# check if the selected cell is available
		unless self.grid[selection] == ' '
			raise(StandardError, 'that cell is already taken, please try again')
		end
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
	  	# bail out as soon as it's clear that self.char isn't present contiguously
	    return unless self.grid[cell] == self.grid[selection]
	  end
	  # if we get here, self.char's won
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
	  	# bail out as soon as it's clear that self.char isn't present contiguously
	    return unless self.grid[cell] == self.grid[selection]
	  end
	  # if we get here, self.char's won
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
			# bail out as soon as it's clear that self.char isn't present contiguously
	    return unless self.grid[cell] == self.grid[selection]
	  end
	  # if we get here, self.char's won
	  self.we_have_a_winner = true
	end
end
