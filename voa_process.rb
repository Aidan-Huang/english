$temp_dir = nil

def init
  $temp_dir = "temp"
  $app_home = nil

  if File.symlink?($0)
    origin = File.readlink $0
    $app_home = File.dirname(origin)
  else
    $app_home = File.dirname( File.expand_path($0) )
  end
  $LOAD_PATH << File.join($app_home, "lib")

  $temp_dir = File.join($app_home, "temp")

  if not File.exist? $temp_dir
    Dir.mkdir $temp_dir
  end

  ## proc arc file
  $arc_file = ARGV[0]
end


################################################################

init()
# pp $app_home, $temp_dir, $LOAD_PATH ; exit


require "dirutils"

def generate_file(file, extname="html")

	path = Pathname.new(file) 

	File.open(file, "r") { |file|  

		new_file = File.new("#{path.expand_path.parent}/#{path.basename(path.extname)}.#{extname}", "w+")

		i = 0
		sentence = ""

		while line = file.gets
			if i > 3  		
				sentence = sentence + " " + line. gsub(/\[\d\d:\d\d.\d\d\]/, '').strip

				if sentence.end_with?(".") #|| "hello".end_with?("\"")
					new_file.write(sentence + "\n")
					sentence = ""
				end
			else
				new_file.write(line)
			end

			i = i + 1
		end	
	}
end
#generate_file("test.lrc")

def generate_all(str)
	walk_dir(str, false, ['.lrc']) {|f| generate_file(f)}
end
generate_all("newdir")


#path = Pathname.new("test.lrc") 
# puts path.expand_path
# puts "#{path.expand_path.parent}/#{path.basename(path.extname)}.html"


#generate_all("newdir")

# puts ".dddtxt".sub(/txt/, "true")

# a = "the quick brown fox"

# puts a.sub(/[aeiou]/, '*') #结果 "th* quick brown fox"

# a = ['.']

# puts a.empty?