# --- Day 21: Scrambled Letters and chars ---
#
# The computer system you're breaking into uses a weird scrambling function to store its passwords. It shouldn't be
# much trouble to create your own scrambled password so you can add it to the system; you just have to implement the
# scrambler.
#
# The scrambling function is a series of operations (the exact list is provided in your puzzle input). Starting with
# the password to be scrambled, apply each operation in succession to the string. The individual operations behave as
# follows:
#
# swap position X with position Y means that the letters at indexes X and Y (counting from 0) should be swapped.
# swap letter X with letter Y means that the letters X and Y should be swapped (regardless of where they appear in the
# string).
# rotate left/right X steps means that the whole string should be rotated; for example, one right rotation would turn
# abcd into dabc.
# rotate based on position of letter X means that the whole string should be rotated to the right based on the index
# of letter X (counting from 0) as determined before this instruction does any rotations. Once the index is determined,
# rotate the string to the right one time, plus a number of times equal to that index, plus one additional time if the
# index was at least 4.
# reverse positions X through Y means that the span of letters at indexes X through Y (including the letters at X and
# Y) should be reversed in order.
# move position X to position Y means that the letter which is at index X should be removed from the string, then
# inserted such that it ends up at index Y.
#
# For example, suppose you start with abcde and perform the following operations:
#
# swap position 4 with position 0 swaps the first and last letters, producing the input for the next step, ebcda.
# swap letter d with letter b swaps the positions of d and b: edcba.
# reverse positions 0 through 4 causes the entire string to be reversed, producing abcde.
# rotate left 1 step shifts all letters left one position, causing the first letter to wrap to the end of the string:
# bcdea.
# move position 1 to position 4 removes the letter at position 1 (c), then inserts it at position 4 (the end of the
# string): bdeac.
# move position 3 to position 0 removes the letter at position 3 (a), then inserts it at position 0 (the front of the
# string): abdec.
# rotate based on position of letter b finds the index of letter b (1), then rotates the string right once plus a
# number of times equal to that index (2): ecabd.
# rotate based on position of letter d finds the index of letter d (4), then rotates the string right once, plus a
# number of times equal to that index, plus an additional time because the index was at least 4, for a total of 6
# right rotations: decab.
#
# After these steps, the resulting scrambled password is decab.
#
# Now, you just need to generate a new scrambled password and you can access the system. Given the list of scrambling
# operations in your puzzle input, what is the result of scrambling abcdefgh?
input = 'day21_input.txt'
password = 'abcdefgh'

def rotate_position(cmd, chars, decode)
  letter = cmd.scan(/letter \w/)[0].split.last
  pos = chars.index(letter)
  if decode
    # Below is the translation necessary to decode the current position
    # and return to the original position. There's a clear pattern for
    # even and odd positions, with position 0 being a special case.
    # Subtract the result of this from the current position to get
    # the rotate_amount.
    #
    # pos		old pos
    # 0 		7       special case
    # 1 		0 			(n-1)/2
    # 2 		4	  		(n/2)+3
    # 3 		1		   	(n-1)/2
    # 4 		5			  (n/2)+3
    # 5 		2			  (n-1)/2
    # 6 		6			  (n/2)+3
    # 7 		3			  (n-1)/2
    if pos == 0
      rotate_amount = 1
    elsif pos.odd?
      rotate_amount = pos - ((pos - 1) / 2)
    elsif pos.even?
      rotate_amount = pos - ((pos / 2) + 3)
    end
  else
    rotate_amount = -(pos >= 4 ? pos + 2 : pos + 1)
  end
  chars = chars.rotate(rotate_amount)
  chars
end

def rotate_steps(cmd, chars, decode)
  steps = cmd.scan(/\d/)[0].chars.last.to_i
  steps = -steps if (cmd.include?('left') && decode) || (cmd.include?('right') && !decode)
  chars.rotate!(steps)
end

def swap_letter(cmd, chars)
  a, b = cmd.scan(/letter (\w)/).map(&:first)
  chars.join.tr("#{a}#{b}", "#{b}#{a}").chars
end

def swap_position(cmd, chars)
  a, b = cmd.scan(/\d/).map(&:to_i)
  chars[a], chars[b] = chars[b], chars[a]
  chars
end

def reverse_positions(cmd, chars)
  from, to = cmd.scan(/\d/).map(&:to_i)
  chars[from..to] = chars[from..to].reverse
  chars
end

def move_position(cmd, chars, decode)
  from, to = cmd.scan(/\d/).map(&:to_i)
  from, to = to, from if decode == true
  c = chars[from]
  chars[from] = nil
  chars.compact!
  chars.insert(to, c)
  chars
end

chars = password.chars
commands = File.read(input).lines

# Part 1
commands.each do |cmd|
  if cmd.start_with?('rotate based on position')
    chars = rotate_position(cmd, chars, false)
  elsif cmd.start_with?('rotate')
    chars = rotate_steps(cmd, chars, false)
  elsif cmd.start_with?('swap letter')
    chars = swap_letter(cmd, chars)
  elsif cmd.start_with?('swap position')
    chars = swap_position(cmd, chars)
  elsif cmd.start_with?('reverse positions')
    chars = reverse_positions(cmd, chars)
  elsif cmd.start_with?('move position')
    chars = move_position(cmd, chars, false)
  end
end

puts "Part 1: #{chars.join}"

# Part 2
commands = commands.reverse
chars = "fbgdceah".chars
commands.each do |cmd|
  if cmd.start_with?('rotate based on position')
    chars = rotate_position(cmd, chars, true)
  elsif cmd.start_with?('rotate')
    chars = rotate_steps(cmd, chars, true)
  elsif cmd.start_with?('swap letter')
    chars = swap_letter(cmd, chars)
  elsif cmd.start_with?('swap position')
    chars = swap_position(cmd, chars)
  elsif cmd.start_with?('reverse positions')
    chars = reverse_positions(cmd, chars)
  elsif cmd.start_with?('move position')
    chars = move_position(cmd, chars, true)
  end
end

puts "Part 2: #{chars.join}"
