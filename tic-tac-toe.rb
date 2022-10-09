#!/usr/bin/env ruby

require 'byebug'

# set initial values
grid = {
  'a1' => ' ', 'a2' => ' ', 'a3' => ' ',
  'b1' => ' ', 'b2' => ' ', 'b3' => ' ',
  'c1' => ' ', 'c2' => ' ', 'c3' => ' '
}
selection = nil
char = 'X'
we_have_a_winner = false
VALID_USER_INPUT = ['a1', 'a2', 'a3', 'b1', 'b2', 'b3', 'c1', 'c2', 'c3', 'q'].freeze

def draw_grid(grid)
	puts '    1   2   3'
	puts '  -------------'
	puts "A | #{grid['a1']} | #{grid['a2']} | #{grid['a3']} |"
	puts '  -------------'
	puts "B | #{grid['b1']} | #{grid['b2']} | #{grid['b3']} |"
	puts '  -------------'
	puts "C | #{grid['c1']} | #{grid['c2']} | #{grid['c3']} |"
	puts '  -------------'
end

def get_user_selection
	yield if block_given?
	puts "Enter 'q' to quit"
	print 'Enter a selection: '
	gets.chomp
end

# display the initialized grid
draw_grid(grid)

# play the game
until selection == 'q'
	# prompt player for selection
	selection = get_user_selection

	# check that selection is either a cell address on the grid or 'q'
	# if not, reprompt the player for their selection
	unless VALID_USER_INPUT.include?(selection)
		selection = get_user_selection { puts 'invalid input, please try again' }
	end

	# quit if the player enters 'q' as their selection
	abort('Quitting...') if selection == 'q'

	# check if the selected cell is available
	# if not, reprompt the player for their selection
	unless grid[selection] == ' '
		selection = get_user_selection { puts 'that cell is already taken, please try again' }
	end

	# update the grid with player's selection
	grid[selection] = char

	# apply rules

	# display updated grid
	draw_grid(grid)

	if we_have_a_winner
		abort("#{char}'s won!")
	else
		# switch chars and play another turn
		char = char == 'X' ? 'O' : 'X'
	end
end
