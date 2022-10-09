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
	# if so, continue
	# if not, reprompt the player for their selection

	# quit if the player enters 'q' as their selection
	abort('Quitting...') if selection == 'q'

	# check if the selected cell is available
	# if so, update the grid with player's selection
	grid[selection] = char
	# if not, reprompt the player for their selection

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
