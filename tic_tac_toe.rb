#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'classes/game'
# require 'byebug'

def play
  game = Game.new
  game.draw_grid

  loop do
    begin
      print "Select a cell for the #{game.player}: "
      player_selection = gets.chomp
      game.update_cell(player_selection)
    rescue => e
      puts e.message
      puts 'Lets try this again...'
      retry
    end
    game.turn_counter += 1
    game.apply_rules(player_selection)
    game.draw_grid
    break if game.winner
    game.switch_players
  end

  result = game.winner == 'nobody' ? 'Stalemate!' : "#{game.winner}'s won!"
  puts result
end

play
