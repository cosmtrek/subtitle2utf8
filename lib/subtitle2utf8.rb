require 'subtitle2utf8/version'
require 'rchardet'

module Subtitle2utf8
  def self.convert(subtitle, type, recursion = false)
    path = File.expand_path(subtitle)

    case type
    when :file
      if !File.exist?(path)
        abort "#{path} does not exist!"
      end

      convert_file(path)
    when :dir
      if !Dir.exist?(path)
        abort "#{path} does not exist!"
      end

      if recursion
        convert_dirs(path)
      else
        convert_dir(path)
      end
    end
  end

  private

  def convert_file(origin)
    valid = ['.srt', '.ass']

    ext = File.extname(origin)
    if !valid.include?(ext)
      abort "#{origin} is not valid file!"
    end

    name = File.basename(origin, ext)
    # Ignore converted file.
    return if name =~ /^*.utf-8/

    dir = File.dirname(origin)
    new_file = "#{dir}/#{name}.utf-8#{ext}"
    encoding = CharDet.detect(File.new(origin).read(64))['encoding']
    # GB18030 is a superset of Chinese encoding GB2312.
    encoding = begin
      encoding == 'GB2312' ? 'GB18030' : encoding
    end

    begin
      file_content =
        # For UTF-16 encodings(UTF-16LE(UNIX platform) and UTF-16BE(WIndows platform))
        # the file open mode must be binary.
        if encoding == 'UTF-16LE' || encoding == 'UTF-16BE'
          IO.read(origin, mode: 'rb', encoding: encoding).dup.force_encoding(encoding).encode('utf-8')
        else
          File.read(origin, encoding: encoding).dup.force_encoding(encoding).encode('utf-8')
        end
    rescue Exception => e
      abort "#{e}: #{origin} cannot be converted to utf-8..."
    end

    File.open(new_file, 'w') { |f| f.write(file_content) }
  end

  def convert_dir(present)
    Dir.chdir(present) do
      Dir['*.srt'].each { |name| convert_file name }
      Dir['*.ass'].each { |name| convert_file name }
    end
  end

  def convert_dirs(present)
    Dir.chdir(present) do
      Dir['**/*.srt'].each { |name| convert_file name }
      Dir['**/*.ass'].each { |name| convert_file name }
    end
  end
end
