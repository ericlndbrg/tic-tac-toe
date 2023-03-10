# frozen_string_literal: true

require_relative 'grid'
require_relative 'input_validator'
require_relative 'player'
require_relative 'referee'
require_relative 'printer'

# this class orchestrates the game
class Game
  def initialize
    self.grid = Grid.new
    self.input_validator = InputValidator.new
    self.x_player = Player.new('X')
    self.o_player = Player.new('O')
    self.referee = Referee.new
    self.current_player = x_player
    self.we_have_a_winner = false
    self.turn_counter = 0
    grid.draw
  end

  def play
    begin
      # prompt player for their cell selection
      selection = current_player.get_cell_selection
      # validate user input
      input_validator.validate_user_input(selection, grid.cell_hash[selection])
    rescue StandardError => e
      Printer.print_output(e.message)
      # re-prompt the user for input if validation failed
      retry
    end

    # quit if the player enters 'q' as their selection
    end_game('Thanks for playing!') if selection == 'q'

    # update the grid with player's selection
    grid.update(selection, current_player.char)

    # increment the turn_counter
    self.turn_counter += 1

    # apply the rules of the game
    self.we_have_a_winner = referee.winner_found?(selection, grid, turn_counter)

    # display updated grid
    grid.draw

    # end the game if somebody won
    end_game("#{current_player.char}'s win!") if we_have_a_winner

    # end the game if the board is full and nobody has won
    end_game('Stalemate!') if we_have_a_winner == false && turn_counter == 9

    # switch players
    self.current_player = current_player == x_player ? o_player : x_player

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
                :o_player,
                :referee

  def end_game(msg)
    Printer.print_output(msg)
    abort
  end
end
