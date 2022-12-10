class Game
	VALID_USER_INPUT = ['a1', 'a2', 'a3', 'b1', 'b2', 'b3', 'c1', 'c2', 'c3', 'q'].freeze

	def initialize
		self.grid = {
		  'a1' => ' ', 'a2' => ' ', 'a3' => ' ',
		  'b1' => ' ', 'b2' => ' ', 'b3' => ' ',
		  'c1' => ' ', 'c2' => ' ', 'c3' => ' '
		}
		self.turn_counter = 0
		self.char = 'X'
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
			retry
		end

		# quit if the player enters 'q' as their selection
		abort('Quitting...') if selection == 'q'

		# update the grid with player's selection
		self.grid[selection] = self.char

		# increment the turn_counter
		self.turn_counter += 1

		# apply rules
		# apply_rules

		# display updated grid
		draw_grid

		# switch chars
		self.char = self.char == 'X' ? 'O' : 'X'

		# play another turn
		play
	end

	private

	attr_accessor :grid, :turn_counter, :char

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

	def apply_rules(selection, grid, turn_counter)
		# the direction checks can be bailed out of if an X is next to an O
		# no need to look across an entire row if it's impossible to have 3
		# of the same symbol all the way across
		#   ex. |X|O|X|
		#
		# no need to call this method if the turn count is < 5
		# stalemate = turn count = 9 and no one has won, abort if so
		#
		# break the selection into a row and column
		#   row, column = selection.split(/\B/)
		#
		# all cells need row and column rules applied
		# the corner cells require a diagonal rule (to opposite corner) applied as well
		# the middle cell requires two diagonal rules (to both opposite corners) applied as well
	end
end
