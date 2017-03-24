# --- Day 20: Firewall Rules ---
#
# You'd like to set up a small hidden computer here so you can use it to get back into the network later. However, the
# corporate firewall only allows communication with certain external IP addresses.
#
# You've retrieved the list of blocked IPs from the firewall, but the list seems to be messy and poorly maintained,
# and it's not clear which IPs are allowed. Also, rather than being written in dot-decimal notation, they are written
# as plain 32-bit integers, which can have any value from 0 through 4294967295, inclusive.
#
# For example, suppose only the values 0 through 9 were valid, and that you retrieved the following blacklist:
#
# 5-8
# 0-2
# 4-7
#
# The blacklist specifies blacklist of IPs (inclusive of both the start and end value) that are not allowed. Then, the
# only IPs that this firewall allows are 3 and 9, since those are the only numbers not in any range.
#
# Given the list of blocked IPs you retrieved from the firewall (your puzzle input), what is the lowest-valued IP that
# is not blocked?
# 
# --- Part Two ---
#
# How many IPs are allowed by the blacklist?
input = 'day20_input.txt'
max_address = 4294967295
blacklist = []

File.read(input).split.each_with_index { |e,i| blacklist[i] = e.scan(/\d+/).map(&:to_i)  }
blacklist.sort!

whitelist = []
black_min = blacklist[0][0]
black_max = blacklist[0][1]
white_min = white_max = 0

blacklist.length.times do |i|
  if blacklist[i][0] > black_max + 1
    white_min = black_max + 1
    white_max = blacklist[i][0] - 1
    whitelist << [white_min, white_max]
    black_min = blacklist[i][0]
    black_max = blacklist[i][1]
  end
  black_max = blacklist[i][1] if blacklist[i][0] <= black_max+1 && blacklist[i][1] > black_max
end

# Add final range if blacklist doesn't reach max ip address
whitelist << [black_max + 1, max_address] if black_max < max_address

permitted_ips = 0
whitelist.each { |r| permitted_ips += r[1] - r[0] + 1 } # +1 because ranges are inclusive

puts "Part 1: #{whitelist.first[0]}"
puts "Part 2: #{permitted_ips}"
