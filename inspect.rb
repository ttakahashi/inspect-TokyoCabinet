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
  while read_time >= strict_time + 60 * 5
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
  value = h.dup
  comp_list.store(key, value)
}

# count start with comp_list
strict_time = Time.mktime(2012, 9, 28, 19, 00, 00)
fp = File.open(ARGV[0], "r")
fp.each{ |line|
  date, pair = trim(line)
  pair.chomp!
  read_time =  Time.parse(date)

  while read_time >= strict_time + 60 * 5
    strict_time = strict_time + 60 * 5
  end
  if read_time <= strict_time + 60 * 5
    comp_list[strict_time][pair]  += 1
  end
}
fp.close

fp = File.open("result", "w")
comp_list.each{ |key2, value2|
  value2.each{ |key3, value3|
    fp.write(key3)
    fp.write(",")
  }
  fp.write("\n")
  break
}

fp.close
fp = File.open("result", "a")
comp_list.each{ |key1, value1|
  fp.write(key1)
  fp.write(", ")
  value1.each{ |key2, value2|
    fp.write(value2)
    fp.write(",")
  }
  fp.write("\n")
}


