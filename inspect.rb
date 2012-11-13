require 'pp'
require 'time'

def trim(line)
  trimmed = line.match(%r(^([^ ]*) ([^ ]*) ([^ ]*) ([^c]*) ([^ ]*) ([^ ]*)  ([^ ]*) ([^ ]*)))
  date =  trimmed[2] + ' +0000]'
  channel = trimmed[6]
  sitecode = trimmed[8]
  pair = trimmed[6] + '_' + trimmed[8]
  return date, pair
end

# make table first
# create time row
strict_time = Time.mktime(2012, 9, 28, 19, 00, 00)
list = Hash.new()
pair = Hash.new()
list.store(strict_time,  pair)

fp = File.open(ARGV[0], "r")
fp.each{ |line|
  date, pair = trim(line)


  read_time =  Time.parse(date)
  if read_time >= strict_time + 60 * 5
    strict_time = strict_time + 60 * 5
    list.store(strict_time, Hash.new())
  end
}
fp.close

# create pair row
fp = File.open(ARGV[0], "r")
h = Hash.new()
fp.each{ |line|
  date, pair = trim(line) # pair is channel and sitecode
pair.chomp!
  if h[:pair] == nil
    h.store(pair, 0)
  end
}
fp.close

# connect pair to list
comp_list = Hash.new()
list.each{ |key, value|
  value = h
comp_list.store(key, value)
}

# count start with comp_list
fp = File.open(ARGV[0], "r")
fp.each{ |line|
  date, pair = trim(line)
pair.chomp!
  comp_list[:date][:pair]  += 1
}

pp comp_list
