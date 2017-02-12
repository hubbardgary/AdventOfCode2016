# --- Day 13: A Maze of Twisty Little Cubicles ---
#
# You arrive at the first floor of this new building to discover a much less welcoming environment than the shiny atrium of
# the last one. Instead, you are in a maze of twisty little cubicles, all alike.
#
# Every location in this area is addressed by a pair of non-negative integers (x,y). Each such coordinate is either a wall
# or an open space. You can't move diagonally. The cube maze starts at 0,0 and seems to extend infinitely toward positive x
# and y; negative values are invalid, as they represent a location outside the building. You are in a small waiting area at
# 1,1.
#
# While it seems chaotic, a nearby morale-boosting poster explains, the layout is actually quite logical. You can determine
# whether a given x,y coordinate will be a wall or an open space using a simple system:
#
# Find x*x + 3*x + 2*x*y + y + y*y.
# Add the office designer's favorite number (your puzzle input).
# Find the binary representation of that sum; count the number of bits that are 1.
# If the number of bits that are 1 is even, it's an open space.
# If the number of bits that are 1 is odd, it's a wall.
# For example, if the office designer's favorite number were 10, drawing walls as # and open spaces as ., the corner of the
# building containing 0,0 would look like this:
#
#   0123456789
# 0 .#.####.##
# 1 ..#..#...#
# 2 #....##...
# 3 ###.#.###.
# 4 .##..#..#.
# 5 ..##....#.
# 6 #...##.###
#
# Now, suppose you wanted to reach 7,4. The shortest route you could take is marked as O:
#
#   0123456789
# 0 .#.####.##
# 1 .O#..#...#
# 2 #OOO.##...
# 3 ###O#.###.
# 4 .##OO#OO#.
# 5 ..##OOO.#.
# 6 #...##.###
#
# Thus, reaching 7,4 would take a minimum of 11 steps (starting from your current location, 1,1).
#
# What is the fewest number of steps required for you to reach 31,39?
#
# Your puzzle input is 1352.
#
# --- Part Two ---
#
# How many locations (distinct x,y coordinates, including your starting location) can you reach in at most 50 steps?
require 'set'

$maze = []
$height, $width = 50, 50
input = 1352
target = [31,39]
$part1 = 0
$part2 = 0

class Node
  attr_accessor :x, :y, :steps
  def initialize(x, y, steps)
    @x = x
    @y = y
    @steps = steps
  end
end

def build_maze(input)
  $width.times do |x|
    $maze[x] = []
    $height.times do |y|
      is_wall = ((x*x + 3*x + 2*x*y + y + y*y) + input).to_s(2).count("1").odd?
      $maze[x][y] = is_wall ? '#' : '.'
    end
  end
end

def print_maze()
  $maze.transpose.each { |row| puts row.join }
end

def get_adjacent_cells(node)
  [
    Node.new(node.x + 1, node.y, node.steps + 1),
    Node.new(node.x - 1, node.y, node.steps + 1),
    Node.new(node.x, node.y + 1, node.steps + 1),
    Node.new(node.x, node.y - 1, node.steps + 1)
  ]
end

def is_wall(x, y)
  $maze[x][y] == '#'
end

def out_of_bounds(x, y)
  x < 0 || y < 0 || x > $width-1 || y > $height-1
end

def breadth_first_search(target)
  queue = [Node.new(1, 1, 0)]
  visited = Set[[1,1]]

  while queue.length > 0
    current = queue.shift

    # If we're taking the 51st step, we've visited all we can in 50 steps
    $part2 = visited.count if current.steps == 51 && $part2 == 0

    visited << [current.x, current.y]
    return current.steps if [current.x, current.y] == target

    get_adjacent_cells(current).each { |n| queue << n if !(is_wall(n.x, n.y) || out_of_bounds(n.x, n.y) || visited.include?([n.x, n.y])) }
  end
end

build_maze(input)
#print_maze()
$part1 = breadth_first_search(target)

puts "Part 1: #{$part1}"
puts "Part 2: #{$part2}"
