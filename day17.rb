# --- Day 17: Two Steps Forward ---
#
# You're trying to access a secure vault protected by a 4x4 grid of small rooms connected by doors. You start in the
# top-left room (marked S), and you can access the vault (marked V) once you reach the bottom-right room:
#
# #########
# #S| | | #
# #-#-#-#-#
# # | | | #
# #-#-#-#-#
# # | | | #
# #-#-#-#-#
# # | | |
# ####### V
#
# Fixed walls are marked with #, and doors are marked with - or |.
#
# The doors in your current room are either open or closed (and locked) based on the hexadecimal MD5 hash of a passcode
# (your puzzle input) followed by a sequence of uppercase characters representing the path you have taken so far (U for
# up, D for down, L for left, and R for right).
#
# Only the first four characters of the hash are used; they represent, respectively, the doors up, down, left, and
# right from your current position. Any b, c, d, e, or f means that the corresponding door is open; any other character
# (any number or a) means that the corresponding door is closed and locked.
#
# To access the vault, all you need to do is reach the bottom-right room; reaching this room opens the vault and all
# doors in the maze.
#
# For example, suppose the passcode is hijkl. Initially, you have taken no steps, and so your path is empty: you simply
# find the MD5 hash of hijkl alone. The first four characters of this hash are ced9, which indicate that up is open
# (c), down is open (e), left is open (d), and right is closed and locked (9). Because you start in the top-left
# corner, there are no "up" or "left" doors to be open, so your only choice is down.
#
# Next, having gone only one step (down, or D), you find the hash of hijklD. This produces f2bc, which indicates that
# you can go back up, left (but that's a wall), or right. Going right means hashing hijklDR to get 5745 - all doors
# closed and locked. However, going up instead is worthwhile: even though it returns you to the room you started in,
# your path would then be DU, opening a different set of doors.
#
# After going DU (and then hashing hijklDU to get 528e), only the right door is open; after going DUR, all doors lock.
# (Fortunately, your actual passcode is not hijkl).
#
# Passcodes actually used by Easter Bunny Vault Security do allow access to the vault if you know the right path. For
# example:
#
# If your passcode were ihgpwlah, the shortest path would be DDRRRD.
# With kglvqrro, the shortest path would be DDUDRLRRUDRD.
# With ulqzkmiv, the shortest would be DRURDRUDDLLDLUURRDULRLDUUDDDRR.
#
# Given your vault's passcode, what is the shortest path (the actual path, not just the length) to reach the vault?
#
# Your puzzle input is gdjjyniy
#
# --- Part Two ---
#
# You're curious how robust this security solution really is, and so you decide to find longer and longer paths which
# still provide access to the vault. You remember that paths always end the first time they reach the bottom-right room
# (that is, they can never pass through it, only end in it).
#
# For example:
#
# If your passcode were ihgpwlah, the longest path would take 370 steps.
# With kglvqrro, the longest path would be 492 steps long.
# With ulqzkmiv, the longest path would be 830 steps long.
#
# What is the length of the longest path that reaches the vault?
require 'digest/md5'

$input = 'gdjjyniy'

class Node
  attr_accessor :x, :y, :route
  def initialize(x, y, route)
    @x = x
    @y = y
    @route = route
  end
end

def get_hash(route)
  Digest::MD5.hexdigest($input + route)[0..3]
end

def get_open_doors(hash)
  options = []
  hash.each_char { |c| if 'bcdef'.include?(c) then options << 1 else options << 0 end }
  options
end

def get_adjacent_open_doors(node)
  open_doors = get_open_doors(get_hash(node.route))
  adjacent_cells = []
  adjacent_cells << Node.new(node.x, node.y - 1, node.route + 'U') if open_doors[0] == 1 && node.y - 1 > -1
  adjacent_cells << Node.new(node.x, node.y + 1, node.route + 'D') if open_doors[1] == 1 && node.y + 1 < 4
  adjacent_cells << Node.new(node.x - 1, node.y, node.route + 'L') if open_doors[2] == 1 && node.x - 1 > -1
  adjacent_cells << Node.new(node.x + 1, node.y, node.route + 'R') if open_doors[3] == 1 && node.x + 1 < 4
  adjacent_cells
end

def depth_first_search(start_node, target)
  node_stack = [start_node]
  valid_routes = []
  loop do
    curr_node = node_stack.pop
    return valid_routes if curr_node == nil
    if curr_node.x == target[0] && curr_node.y == target[1]
      valid_routes << curr_node.route
    else
      get_adjacent_open_doors(curr_node).each { |n| node_stack << n }
    end
  end
end

origin = [0, 0]
target = [3, 3]

routes = depth_first_search(Node.new(origin[0], origin[1], ''), target).sort_by(&:length)

puts "Part 1: #{routes[0]}"
puts "Part 2: #{routes[-1].length}"
