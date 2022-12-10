#!/usr/bin/env ruby

require_relative 'classes/game'
require 'byebug'

def main
	game = Game.new
	game.play
end

main
