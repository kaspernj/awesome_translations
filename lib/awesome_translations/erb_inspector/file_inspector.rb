class AwesomeTranslations::ErbInspector::FileInspector
  METHOD_NAMES = ["t"]
  VALID_BEGINNING = '(^|\s+|\(|\{|<%=\s*)'

  attr_reader :root_path, :file_path

  def initialize(args)
    @args = args
    @root_path, @file_path = args[:root_path], args[:file_path]
  end

  def translations
    Enumerator.new do |yielder|
      translations_found = {}

      File.open(full_path, "r") do |fp|
        line_no = 0
        fp.each_line do |line|
          line_no += 1
          parse_content(line_no, line, translations_found, yielder)
        end
      end
    end
  end

  def full_path
    "#{@root_path}/#{@file_path}"
  end

  def basename
    File.basename(@file_path).match(/\A(.+?)\./)[1]
  end

private

  def parse_content(line_no, line, translations_found, yielder)
    METHOD_NAMES.each do |method_name|
      # Scan for the various valid formats.
      line.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*\("(.+?)"/) do |match|
        add_translation(line_no, match[1], match[2], translations_found, yielder)
      end

      line.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*"(.+?)"/) do |match|
        add_translation(line_no, match[1], match[2], translations_found, yielder)
      end

      line.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*\('(.+?)'/) do |match|
        add_translation(line_no, match[1], match[2], translations_found, yielder)
      end

      line.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*'(.+?)'/) do |match|
        add_translation(line_no, match[1], match[2], translations_found, yielder)
      end
    end
  end

  def add_translation(line_no, method, key, translations_found, yielder)
    translation_inspector = AwesomeTranslations::ErbInspector::TranslationInspector.new(
      root_path: @root_path,
      file_path: @file_path,
      line_no: line_no,
      method: method,
      key: key
    )

    unless translation_with_key_exists?(translations_found, translation_inspector.key)
      yielder << translation_inspector
    end
  end

  def translation_with_key_exists?(translations_found, translation_key)
    translations_found.select { |t| t.key == translation_key }.any?
  end

  def translation_key_from_dir_file_and_key(dir, file, key)
    return key unless key.starts_with?(".")

    file = file.gsub(/\A_/, "") # Remove partial indicator.

    translation_key = dir
    translation_key = translation_key.gsub(/\Aapp\//, "")
    translation_key << "/#{file}"
    translation_key.gsub!("/", ".")
    translation_key << key

    return translation_key
  end
end
