require 'subtitle2utf8/version'
require 'rchardet'

module Subtitle2utf8
  def self.convert(val, type, recursion = false)
    val = File.expand_path val

    case type
    when :file
      if !File.exist? val
        puts "#{val} does not exist!"
        exit
      end

      convert_file val
    when :dir
      if !Dir.exist? val
        puts "#{val} does not exist!"
        exit
      end

      if recursion
        convert_dirs val
      else
        convert_dir val
      end
    end
  end

  def convert_file(origin)
    valid = '.srt'

    if (ext = File.extname(origin)) != valid
      puts "#{origin} is not valid file!"
      exit
    end

    name = File.basename(origin, ext)
    # Ignore converted file.
    return if name =~ /^*.utf-8/

    dir = File.dirname origin
    new_file = "#{dir}/#{name}.utf-8#{ext}"
    encoding = CharDet.detect(File.new(origin).read(64))['encoding']
    # GB18030 is a superset of Chinese encoding GB2312.
    encoding = encoding == 'GB2312' ? 'GB18030' : encoding

    begin
      file_content =
        # For UTF-16 encodings(UTF-16LE(UNIX platform) and UTF-16BE(WIndows platform))
        # the file open mode must be binary.
        if encoding == 'UTF-16LE' || 'UTF-16BE'
          IO.read(origin_file, mode: 'rb', encoding: encoding).dup.force_encoding(encoding).encode('utf-8')
        else
          File.read(origin, encoding: encoding).force_encoding(encoding).encode('utf-8')
        end
    rescue Exception => e
      puts "#{origin} cannot be converted to utf-8..."
      return
    end

    File.open(new_file, 'w') {|f| f.write file_content}
  end

  def convert_dir(present)
    Dir.chdir(present) do
      Dir['*.srt'].each { |name| convert_file name }
    end
  end

  def convert_dirs(present)
    Dir.chdir(present) do
      Dir['**/*.srt'].each { |name| convert_file name }
    end
  end
end
