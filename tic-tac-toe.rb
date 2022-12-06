#!/usr/bin/env ruby

require 'byebug'

# set initial values
grid = {
  'a1' => ' ', 'a2' => ' ', 'a3' => ' ',
  'b1' => ' ', 'b2' => ' ', 'b3' => ' ',
  'c1' => ' ', 'c2' => ' ', 'c3' => ' '
}
# turn_counter = 0
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

# def apply_rules(selection, grid, turn_counter)
# 	# the direction checks can be bailed out of if an X is next to an O
# 	# no need to look across an entire row if it's impossible to have 3
# 	# of the same symbol all the way across
# 	# ex. |X|O|X|
# 	return if turn_counter < 5
# 	# break the selection into a row and column
# 	row, column = selection.split(/\B/)
# 	# all cells need row and column rules applied
# 	# the corner cells require a diagonal rule (to opposite corner) applied as well
# 	# the middle cell requires two diagonal rules (to both opposite corners) applied as well
# 	# apply row rule
# 	# apply column rule
# 	# if selection is a corner cell
# 	#   apply diagonal rule (to opposite corner)
# 	# if selection is a middle cell
# 	#   apply two diagonal rules (to both opposite corners)
# end

def play(char, grid)
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

	# increment the turn_counter
	# turn_counter += 1

	# apply rules
	# apply_rules(selection, grid, turn_counter)

	# display updated grid
	draw_grid(grid)

	we_have_a_winner = false
	if we_have_a_winner
		abort("#{char}'s won!")
	else
		# switch chars and play another turn
		new_char = char == 'X' ? 'O' : 'X'
		play(new_char, grid)
	end
end

# display the initialized grid
draw_grid(grid)

# play the game
play('X', grid)
