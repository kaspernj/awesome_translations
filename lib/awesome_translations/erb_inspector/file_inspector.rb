class AwesomeTranslations::ErbInspector::FileInspector
  METHOD_NAMES = ['t', 'controller_t', 'helper_t']
  VALID_BEGINNING = '(^|\s+|\(|\{|\[|<%=\s*)'

  attr_reader :root_path, :file_path

  def initialize(args)
    @args = args
    @root_path, @file_path = args[:root_path], args[:file_path]
    @method_names ||= ['t']
  end

  def translations
    Enumerator.new do |yielder|
      File.open(full_path, "r") do |fp|
        translations_found = []
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
      if match = line.match(/def\s+(.+?)(\(|\n|\r\n)/)
        @last_method = match[1]
      end

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
      last_method: @last_method,
      root_path: @root_path,
      file_path: @file_path,
      line_no: line_no,
      method: method,
      key: key
    )

    unless translation_with_key_exists?(translations_found, translation_inspector.full_key)
      yielder << translation_inspector
      translations_found << translation_inspector
    end
  end

  def translation_with_key_exists?(translations_found, translation_full_key)
    translations_found.select { |t| t.full_key == translation_full_key }.any?
  end
end
