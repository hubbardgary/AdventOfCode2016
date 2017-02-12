# --- Day 7: Internet Protocol Version 7 ---
#
# While snooping around the local network of EBHQ, you compile a list of IP addresses (they're IPv7, of course;
# IPv6 is much too limited). You'd like to figure out which IPs support TLS (transport-layer snooping).
#
# An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA. An ABBA is any four-character
# sequence which consists of a pair of two different characters followed by the reverse of that pair, such as
# xyyx or abba. However, the IP also must not have an ABBA within any hypernet sequences, which are contained by
# square brackets.
#
# For example:
#
# abba[mnop]qrst supports TLS (abba outside square brackets).
# abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
# aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different).
# ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string).
# How many IPs in your puzzle input support TLS?
#
# --- Part Two ---
#
# You would also like to know which IPs support SSL (super-secret listening).
#
# An IP supports SSL if it has an Area-Broadcast Accessor, or ABA, anywhere in the supernet sequences (outside any
# square bracketed sections), and a corresponding Byte Allocation Block, or BAB, anywhere in the hypernet sequences.
# An ABA is any three-character sequence which consists of the same character twice with a different character
# between them, such as xyx or aba. A corresponding BAB is the same characters but in reversed positions: yxy and
# bab, respectively.
#
# For example:
#
# aba[bab]xyz supports SSL (aba outside square brackets with corresponding bab within square brackets).
# xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy).
# aaa[kek]eke supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence is not related,
# because the interior character must be different).
# zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even though zaz and zbz
# overlap).
#
# How many IPs in your puzzle input support SSL?
input = 'day07_input.txt'
supports_tls = 0
supports_ssl = 0

def contains_abba(sequences)
  sequences.each do |s|
    (s.length - 3).times do |i|
      abba = s[i..i + 3]
      return true if abba[0] != abba[1] && abba == abba.reverse
    end
  end
  return false
end

def get_bab(aba)
  aba[1] + aba[0] + aba[1]
end

def supports_tls(supernets, hypernets)
  contains_abba(supernets) && !contains_abba(hypernets)
end

def supports_ssl(supernets, hypernets)
  supernets.each do |s|
    (s.length - 2).times do |i|
      aba = s[i..i + 2]
      if aba[0] != aba[1] && aba == aba.reverse
        hypernets.each { |h| return true if h.index(get_bab(aba)) != nil }
      end
    end
  end
  return false
end

ip_addresses = File.read(input).split

ip_addresses.each do |line|
  sequences = line.split(/\[|\]/)
  supernets, hypernets = sequences.partition.each_with_index { |el, i| i.even? }

  # Part 1
  supports_tls += 1 if supports_tls(supernets, hypernets)

  # Part 2
  supports_ssl += 1 if supports_ssl(supernets, hypernets)
end

puts "Part 1: #{supports_tls}"
puts "Part 2: #{supports_ssl}"
