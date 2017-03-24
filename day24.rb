# --- Day 24: Air Duct Spelunking ---
#
# You've finally met your match; the doors that provide access to the roof are locked tight, and all of the controls
# and related electronics are inaccessible. You simply can't reach them.
#
# The robot that cleans the air ducts, however, can.
#
# It's not a very fast little robot, but you reconfigure it to be able to interface with some of the exposed wires that
# have been routed through the HVAC system. If you can direct it to each of those locations, you should be able to
# bypass the security controls.
#
# You extract the duct layout for this area from some blueprints you acquired and create a map with the relevant
# locations marked (your puzzle input). 0 is your current location, from which the cleaning robot embarks; the other
# numbers are (in no particular order) the locations the robot needs to visit at least once each. Walls are marked as
# #, and open passages are marked as .. Numbers behave like open passages.
#
# For example, suppose you have a map like the following:
#
# ###########
# #0.1.....2#
# #.#######.#
# #4.......3#
# ###########
# To reach all of the points of interest as quickly as possible, you would have the robot take the following path:
#
# 0 to 4 (2 steps)
# 4 to 1 (4 steps; it can't move diagonally)
# 1 to 2 (6 steps)
# 2 to 3 (2 steps)
#
# Since the robot isn't very fast, you need to find it the shortest route. This path is the fewest steps (in the above
# example, a total of 14) required to start at 0 and then visit every other location at least once.
#
# Given your actual map, and starting from location 0, what is the fewest number of steps required to visit every non-0
# number marked on the map at least once?
#
# --- Part Two ---
#
# Of course, if you leave the cleaning robot somewhere weird, someone is bound to notice.
#
# What is the fewest number of steps required to start at 0, visit every non-0 number marked on the map at least once,
# and then return to 0?
require 'set'

class Node
  attr_accessor :x, :y, :steps
  def initialize(x, y, steps)
    @x = x
    @y = y
    @steps = steps
  end
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

def breadth_first_search(targets)
  distances = []
  targets.each_pair do |key, value|
    queue = [Node.new(value[0], value[1], 0)]
    visited = Set[[value[0],value[1]]]
    distances[key] = []
    distances[key][key] = 0 # distance to self is 0

    while queue.length > 0
      current = queue.shift
      visited << [current.x, current.y]
      if $maze[current.x][current.y] != "#" && $maze[current.x][current.y] != "." && distances[key][$maze[current.x][current.y].to_i] == nil
        distances[key][$maze[current.x][current.y].to_i] = current.steps
      end

      get_adjacent_cells(current).each do |n|
        queue << n if !(visited.include?([n.x, n.y]) || is_wall(n.x, n.y))
        visited << [n.x, n.y]
      end
    end
  end
  return distances
end

def find_shortest_path(possible_paths, distances)
  shortest_distance = -1
  shortest_path = nil

  possible_paths.each do |path|
    i = 0
    distance = 0
    while i < path.length - 1
      from = path[i]
      to = path[i + 1]
      distance += distances[from][to]
      i += 1
    end
    if distance < shortest_distance || shortest_distance == -1
      shortest_distance = distance
      shortest_path = path
    end
  end
  return shortest_distance, shortest_path
end

input = 'day24_input.txt'
$maze = File.read(input).lines.map(&:chop!).map(&:chars)

targets = {}
$maze.each_with_index { |row,x| row.each_with_index { |cell,y| targets[cell.to_i] = [x, y] if (cell != "#" && cell != ".") } }

# Build matrix of distances between each node
distances = breadth_first_search(targets)

puts "Distances matrix:"
distances.each { |d| puts d.inspect }
puts

# Part 1
possible_paths = targets.keys.sort[1..-1].permutation.map { |e| e.unshift(0)  }
shortest_distance, shortest_path = find_shortest_path(possible_paths, distances)

puts "Part 1: #{shortest_distance} #{shortest_path.inspect}"

# Part 2
possible_paths = possible_paths.map { |e| e << 0  }
shortest_distance, shortest_path = find_shortest_path(possible_paths, distances)

puts "Part 2: #{shortest_distance} #{shortest_path.inspect}"
