# --- Day 4: Security Through Obscurity ---
#
# Finally, you come across an information kiosk with a list of rooms. Of course, the list is encrypted and full of decoy
# data, but the instructions to decode the list are barely hidden nearby. Better remove the decoy data first.
#
# Each room consists of an encrypted name (lowercase letters separated by dashes) followed by a dash, a sector ID, and
# a checksum in square brackets.
#
# A room is real (not a decoy) if the checksum is the five most common letters in the encrypted name, in order, with
# ties broken by alphabetization. For example:
#
# aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically.
# a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically.
# not-a-real-room-404[oarel] is a real room.
# totally-real-room-200[decoy] is not.
# Of the real rooms from the list above, the sum of their sector IDs is 1514.
#
# What is the sum of the sector IDs of the real rooms?
#
#
# --- Part Two ---
#
# With all the decoy data out of the way, it's time to decrypt this list and get moving.
#
# The room names are encrypted by a state-of-the-art shift cipher, which is nearly unbreakable without the right software.
# However, the information kiosk designers at Easter Bunny HQ were not expecting to deal with a master cryptographer like
# yourself.
#
# To decrypt a room name, rotate each letter forward through the alphabet a number of times equal to the room's sector ID.
# A becomes B, B becomes C, Z becomes A, and so on. Dashes become spaces.
#
# For example, the real name for qzmt-zixmtkozy-ivhz-343 is very encrypted name.
#
# What is the sector ID of the room where North Pole objects are stored?
input = 'day04_input.txt'
sector_sum = 0
north_pole_sector_id = 0

def get_sector(room)
  room.scan(/\d+/)[0].to_i
end

def count_chars(data)
  chars = Hash.new(0)
  data.each_char { |c| chars[c] += 1 }
  chars
end

def calculate_checksum(data)
  chars = count_chars(data)

  # We want to sort by value in descending order, then key in ascending order, hence -v, k
  Hash[chars.sort_by { |k, v| [-v, k] }].keys[0..4].join
end

def decrypt_char(c, shift)
  return ' ' if c == '-'

  shift.times do
    c.tr!('a-z', 'b-za')
  end
  c
end

def decrypt(room)
  sector = get_sector(room)
  name = room[0..room.rindex('-')]
  decrypted_room = ''
  name.each_char { |c| decrypted_room += decrypt_char(c, sector) }
  decrypted_room
end

File.foreach(input) do |line|
  sector = get_sector(line)
  checksum = line[line.index('[')+1..line.index(']')-1]
  data = line[0..line.rindex('-')].delete('-')

  if checksum == calculate_checksum(data)
    sector_sum += sector
    north_pole_sector_id = sector if north_pole_sector_id == 0 && decrypt(line).scan(/north/).length > 0
  end
end

puts "Part 1: #{sector_sum}"
puts "Part 2: #{north_pole_sector_id}"
