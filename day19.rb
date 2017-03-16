# --- Day 19: An Elephant Named Joseph ---
#
# The Elves contact you over a highly secure emergency channel. Back at the North Pole, the Elves are busy
# misunderstanding White Elephant parties.
#
# Each Elf brings a present. They all sit in a circle, numbered starting with position 1. Then, starting with
# the first Elf, they take turns stealing all the presents from the Elf to their left. An Elf with no presents
# is removed from the circle and does not take turns.
#
# For example, with five Elves (numbered 1 to 5):
#
#   1
# 5   2
#  4 3
#
# Elf 1 takes Elf 2's present.
# Elf 2 has no presents and is skipped.
# Elf 3 takes Elf 4's present.
# Elf 4 has no presents and is also skipped.
# Elf 5 takes Elf 1's two presents.
# Neither Elf 1 nor Elf 2 have any presents, so both are skipped.
# Elf 3 takes Elf 5's three presents.
# So, with five Elves, the Elf that sits starting in position 3 gets all the presents.
#
# With the number of Elves given in your puzzle input, which Elf gets all the presents?
#
# Your puzzle input is 3001330.
#
# --- Part Two ---
#
# Realizing the folly of their present-exchange rules, the Elves agree to instead steal presents from the Elf directly
# across the circle. If two Elves are across the circle, the one on the left (from the perspective of the stealer) is
# stolen from. The other rules remain unchanged: Elves with no presents are removed from the circle entirely, and the
# other elves move in slightly to keep the circle evenly spaced.
#
# For example, with five Elves (again numbered 1 to 5):
#
# The Elves sit in a circle; Elf 1 goes first:
#
#   1
# 5   2
#  4 3
#
# Elves 3 and 4 are across the circle; Elf 3's present is stolen, being the one to the left. Elf 3 leaves the circle,
# and the rest of the Elves move in:
#
#   1           1
# 5   2  -->  5   2
#  4 -          4
#
# Elf 2 steals from the Elf directly across the circle, Elf 5:
#
#   1         1
# -   2  -->     2
#   4         4
#
# Next is Elf 4 who, choosing between Elves 1 and 2, steals from Elf 1:
#
#  -          2
#     2  -->
#  4          4
#
# Finally, Elf 2 steals from Elf 4:
#
#  2
#     -->  2
#  -
#
# So, with five Elves, the Elf that sits starting in position 2 gets all the presents.
#
# With the number of Elves given in your puzzle input, which Elf now gets all the presents?
input = 3001330

# Part 1
# If we remove elves that have no presents, at each round it will always
# be every second elf that loses a present. Repeat until only one remains.
elves = []
input.times { |i| elves[i] = i + 1 }

while elves.length > 1
  elves.each_with_index { |e, i| elves[i] = nil if i.odd? }
  # if there's an odd number of elves, the last elf steals the first elf's presents
  elves[0] = nil if elves.length.odd?
  elves.compact!
end

puts "Part 1: #{elves.first}"

# Part 2
# Split the circle into 2 queues and keep them of equal length.
# Where there is an odd amount of elves, the remaining elf goes to queue2.
# The head of queue1 is the elf whose turn it is. The head of queue2 is the elf opposite him.
# Now we can just remove the head of queue2 (who is eliminated) and move the head of queue 1 to the rear of queue 2.
# If the queues are unbalanced, move the head of queue2 to the back of queue1.
queue1 = []
queue2 = []

(input.to_f / 2).floor.times { |i| queue1[i] = i + 1 }
(input.to_f / 2).ceil.times { |i| queue2[i] = i + (input / 2).ceil + 1 }

while queue2.length > 1
  queue2.shift # Head of queue2 is eliminated
  queue2 << queue1.shift # Head of queue1 goes to the back of queue2
  queue1 << queue2.shift if queue2.length - queue1.length > 1 # If queue lengths are uneven by more than 1, move the head of queue2 to the back of queue1
end

puts "Part 2: #{queue1.first}"
