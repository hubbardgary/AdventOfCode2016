# --- Day 1: No Time for a Taxicab ---
#
# Santa's sleigh uses a very high-precision clock to guide its movements, and the clock's oscillator is regulated by stars.
# Unfortunately, the stars have been stolen... by the Easter Bunny. To save Christmas, Santa needs you to retrieve all fifty
# stars by December 25th.
#
# Collect stars by solving puzzles. Two puzzles will be made available on each day in the advent calendar; the second puzzle
# is unlocked when you complete the first. Each puzzle grants one star. Good luck!
#
# You're airdropped near Easter Bunny Headquarters in a city somewhere. "Near", unfortunately, is as close as you can get -
# the instructions on the Easter Bunny Recruiting Document the Elves intercepted start here, and nobody had time to work them
# out further.
#
# The Document indicates that you should start at the given coordinates (where you just landed) and face North. Then, follow
# the provided sequence: either turn left (L) or right (R) 90 degrees, then walk forward the given number of blocks, ending at
# a new intersection.
#
# There's no time to follow such ridiculous instructions on foot, though, so you take a moment and work out the destination.
# Given that you can only walk on the street grid of the city, how far is the shortest path to the destination?
#
# For example:
#
# Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
# R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away.
# R5, L5, R5, R3 leaves you 12 blocks away.
# How many blocks away is Easter Bunny HQ?
#
# --- Part Two ---
#
# Then, you notice the instructions continue on the back of the Recruiting Document. Easter Bunny HQ is actually at the first
# location you visit twice.
#
# For example, if your instructions are R8, R4, R4, R8, the first location you visit twice is 4 blocks away, due East.
#
# How many blocks away is the first location you visit twice?

require 'set'

input = 'day01_input.txt'
$directions = 'NESW'
$north = 0
$east = 0
$visited_locations = Set["0,0"]
$part2_solution

def get_instructions(string)
  string.scan(/L\d+|R\d+/)
end

def get_new_direction(current_direction, turn)
  index = $directions.index(current_direction)

  turn == 'L' ? index -= 1 : index += 1
  index = 3 if index < 0
  index = 0 if index > $directions.length - 1

  $directions[index]
end

def update_locations(direction, distance)
  distance.times do
    if direction == 'N'
      $north += 1
    elsif direction == 'S'
      $north -= 1
    elsif direction == 'E'
      $east += 1
    elsif direction == 'W'
      $east -= 1
    end

    if !$part2_solution
      location = "#{$east},#{$north}"
      if $visited_locations.include?(location)
        $part2_solution = "Part 2: #{$north.abs + $east.abs}"
      else
        $visited_locations.add location
      end
    end
  end
end

instructions = get_instructions(File.read(input))
direction = 'N'

instructions.each do |instr|
  current_north = $north
  current_east = $east
  direction = get_new_direction(direction, instr[0])
  distance = instr[1..-1].to_i
  update_locations(direction, distance)
end

puts "Part 1: #{$north.abs + $east.abs}"
puts $part2_solution
