require 'pp'
fp = File.open("dummy.log", "r")
fp.each{ |line|
	trimmed = line.match(%r(^([^ ]*) ([^ ]*) ([^ ]*) ([^c]*) ([^ ]*) ([^ ]*)  ([^ ]*) ([^ ]*)))
		date =  trimmed[2] + ' GMT +0000]'
		channel = trimmed[6]
		sitecode = trimmed[8]
		pair = trimmed[6] + '_' + trimmed[8]
		
}
