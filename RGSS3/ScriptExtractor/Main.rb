require "zlib" # script data compressed with zlib

ScriptFile    = "Scripts.rvdata2" # script file
ExtractFolder = "Scripts"         # extract folder

# read script data
data = File.open(ScriptFile, "r") { |file| Marshal.load(file) }

# process data for each record
for record in data

  # get record
  code, name, contents = record

  # skip process for invalid names
  next if name.empty?
  next if name.start_with?("▼")
  next if name.start_with?("(")

  # decompress contents via Zlib
  contents = Zlib::Inflate.inflate(contents)
  
  # substitute CRLF into LF
  contents.gsub!("\r\n", "\n")

  # create folder if not exist
  Dir.mkdir(ExtractFolder) unless Dir.exist?(ExtractFolder)

  # write script into file
  File.open("#{ExtractFolder}/#{name}.rb", 'w') { |file| file.write(contents) }

end
