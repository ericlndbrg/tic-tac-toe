#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'classes/game'
require 'byebug'

def main
  game = Game.new
  game.play
end

main
