# --- Day 25: Clock Signal ---
#
# You open the door and find yourself on the roof. The city sprawls away from you for miles and miles.
#
# There's not much time now - it's already Christmas, but you're nowhere near the North Pole, much too far to deliver
# these stars to the sleigh in time.
#
# However, maybe the huge antenna up here can offer a solution. After all, the sleigh doesn't need the stars, exactly;
# it needs the timing data they provide, and you happen to have a massive signal generator right here.
#
# You connect the stars you have to your prototype computer, connect that to the antenna, and begin the transmission.
#
# Nothing happens.
#
# You call the service number printed on the side of the antenna and quickly explain the situation. "I'm not sure what
# kind of equipment you have connected over there," he says, "but you need a clock signal." You try to explain that
# this is a signal for a clock.
#
# "No, no, a clock signal - timing information so the antenna computer knows how to read the data you're sending it. An
# endless, alternating pattern of 0, 1, 0, 1, 0, 1, 0, 1, 0, 1...." He trails off.
#
# You ask if the antenna can handle a clock signal at the frequency you would need to use for the data from the stars.
# "There's no way it can! The only antenna we've installed capable of that is on top of a top-secret Easter Bunny
# installation, and you're definitely not-" You hang up the phone.
#
# You've extracted the antenna's clock signal generation assembunny code (your puzzle input); it looks mostly
# compatible with code you worked on just recently.
#
# This antenna code, being a signal generator, uses one extra instruction:
#
# out x transmits x (either an integer or the value of a register) as the next value for the clock signal.
# The code takes a value (via register a) that describes the signal to generate, but you're not sure how it's used.
# You'll have to find the input to produce the right signal through experimentation.
#
# What is the lowest positive integer that can be used to initialize register a and cause the code to output a clock
# signal of 0, 1, 0, 1... repeating forever?
#
# --- Part Two ---
#
# The antenna is ready. Now, all you need is the fifty stars required to generate the signal for the sleigh, but you
# don't have enough.
#
# You look toward the sky in desperation... suddenly noticing that a lone star has been installed at the top of the
# antenna! Only 49 more to go.
#
# You activate all fifty stars and transmit the signal. The star atop the antenna begins to glow.
#
# Suddenly, you see the sleigh fly past you!
#
# Looks like Santa was already waiting for your signal.
#
# Congratulations! You've finished every puzzle in Advent of Code 2016!
def find_solution(reg_a, instructions)
  registers = { 'a' => reg_a, 'b' => 0, 'c' => 0, 'd' => 0 }
  i = 0
  expected_output = 0
  sequence_so_far = []
  puts "\nRegister A = #{reg_a}"

  while i < instructions.length
    instr, arg0, arg1 = instructions[i].split
    case instr
    when "cpy"
      registers[arg1] = registers[arg0] != nil ? registers[arg0] : arg0.to_i
    when "inc"
      registers[arg0] += 1
    when "dec"
      registers[arg0] -= 1
    when "jnz"
      if (registers[arg0] != 0 && registers[arg0] != nil) || arg0.to_i != 0
        i += arg1.to_i
        next
      end
    when "out"
      print "#{registers[arg0]},"
      return false if registers[arg0] != expected_output
      sequence_so_far << registers[arg0]
      return true if sequence_so_far.length > 100
      expected_output = expected_output == 0 ? 1 : 0
    end
    i += 1
  end
end

input = 'day25_input.txt'

instructions = File.read(input).lines
reg_a = 1
while !find_solution(reg_a, instructions)
  reg_a += 1
end

puts "\n\nPart 1: #{reg_a}"
