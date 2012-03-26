require "pathname"
require "fileutils"

def string_match(extname, extnames)
	extnames.each {|v| 
		if extname.eql?(v)
			return true
		end
	}
	return false
end
#puts string_match(".mp3", ['.txt', '.lrc', '.mp3'])

def walk_dir(path_str, process_dir=false, extnames=[]) 
  path = Pathname.new(path_str) 
  path.children.each do |entry|  
  	
    if entry.directory?
    	if process_dir
    		#puts "#{process_dir}: #{entry}"
    		yield entry	
    	end
    	walk_dir(entry, process_dir, extnames) {|x| yield(x)}
    else	
    	#puts "extnames.empty: #{extnames.empty?} string_match:#{string_match(entry.extname, extnames)}:#{entry}" 
    	if extnames.empty? || string_match(entry.extname, extnames)
    		yield entry
    	end
    end 
  end 
end 
#walk_dir('olddir', false, ['.lrc']){|f| puts f}


def cp_dir(src, target)

	old_path = Pathname.new(src)

	if Dir.exist?(target)
		FileUtils.remove_dir(target)
	end

	Dir.mkdir(target)

	walk_dir(src, true){|f| 

		new_path = Pathname.new("#{target}/#{f.relative_path_from(old_path)}")
		if f.directory?
			#puts "mkdir: #{new_path}"
			Dir.mkdir(new_path)
		else
			FileUtils.cp(f, new_path)
		end
	}
end 
#cp_dir("../olddir", "../newdir")
