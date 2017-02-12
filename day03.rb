# --- Day 3: Squares With Three Sides ---
#
# Now that you can think clearly, you move deeper into the labyrinth of hallways and office furniture that makes up this part
# of Easter Bunny HQ. This must be a graphic design department; the walls are covered in specifications for triangles.
#
# Or are they?
#
# The design document gives the side lengths of each triangle it describes, but... 5 10 25? Some of these aren't triangles. You
# can't help but mark the impossible ones.
#
# In a valid triangle, the sum of any two sides must be larger than the remaining side. For example, the "triangle" given above
# is impossible, because 5 + 10 is not larger than 25.
#
# In your puzzle input, how many of the listed triangles are possible?
#
#
# --- Part Two ---
#
# Now that you've helpfully marked up their design documents, it occurs to you that triangles are specified in groups of three
# vertically. Each set of three numbers in a column specifies a triangle. Rows are unrelated.
#
# For example, given the following specification, numbers with the same hundreds digit would be part of the same triangle:
#
# 101 301 501
# 102 302 502
# 103 303 503
# 201 401 601
# 202 402 602
# 203 403 603
#
# In your puzzle input, and instead reading by columns, how many of the listed triangles are possible?
input = 'day03_input.txt'

possible_triangles_p1 = 0
possible_triangles_p2 = 0

# Part 1
File.foreach(input) do |line|
  sides = line.split.map { |s| s.to_i }.sort
  possible_triangles_p1 += 1 if sides[0] + sides[1] > sides[2]
end

# Part 2
sides = []
File.foreach(input) { |line| sides << line.split.map { |s| s.to_i  } }
sides = sides.transpose.flatten

i = 0
while i < sides.length
  triangle = [sides[i], sides[i+1], sides[i+2]].sort
  possible_triangles_p2 += 1 if triangle[0] + triangle[1] > triangle[2]
  i += 3
end

puts "Part 1: #{possible_triangles_p1}"
puts "Part 2: #{possible_triangles_p2}"
