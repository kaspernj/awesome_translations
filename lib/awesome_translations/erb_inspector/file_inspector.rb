class AwesomeTranslations::ErbInspector::FileInspector
  JS_FILE_EXTS = [".coffee", ".coffee.erb", ".es6", ".es6.erb", ".js", ".js.erb"]
  METHOD_NAMES = %w(t controller_t helper_t).freeze
  VALID_BEGINNING = '(^|\s+|\(|\{|\[|<%=\s*)'.freeze

  attr_reader :root_path, :file_path

  def initialize(args)
    @args = args
    @root_path = args[:root_path]
    @file_path = args[:file_path]
    @method_names ||= ["t"]
  end

  def translations
    Enumerator.new do |yielder|
      File.open(full_path, "r") do |fp|
        extname = File.extname(full_path)
        translations_found = []
        line_no = 0

        fp.each_line do |line|
          line_no += 1

          if extname == ".liquid"
            parse_content_liquid(line_no, line, translations_found, yielder)
          elsif JS_FILE_EXTS.include?(extname)
            parse_content_js(line_no, line, translations_found, yielder)
          else
            parse_content(line_no, line, translations_found, yielder)
          end
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

  def changed?
    @args.fetch(:changed)
  end

private

  def parse_content_liquid(line_no, line, translations_found, yielder)
    line.scan(/\"([^\"]+?)\"\s+\|\s+t\s*(\%}|\}\}|\|)/) do |match|
      add_translation(line_no, "t", match[0], translations_found, yielder)
    end

    line.scan(/\'([^\']+?)\'\s+\|\s+t\s*(\%}|\}\}|\|)/) do |match|
      add_translation(line_no, "t", match[0], translations_found, yielder)
    end

    line.scan(/\"([^\"]+?)\"\s+\|\s+val:\s*\"([^\"]+?)\"\s*,\s*(.+?)\s*\|\s+t\s*/) do |match|
      add_translation(line_no, "t", match[0], translations_found, yielder)
    end

    line.scan(/'([^\"]+?)'\s+\|\s+val:\s*'([^\"]+?)'\s*,\s*(.+?)\s*\|\s+t\s*/) do |match|
      add_translation(line_no, "t", match[0], translations_found, yielder)
    end
  end

  def parse_content_js(line_no, line, translations_found, yielder)
    line.scan(/\I18n\.t\('(.+?)'\)/) do |match|
      add_translation(line_no, "I18n.t", match[0], translations_found, yielder)
    end

    line.scan(/\I18n\.t\("(.+?)"\)/) do |match|
      add_translation(line_no, "I18n-js.t", match[0], translations_found, yielder)
    end
  end

  def parse_content(line_no, line, translations_found, yielder)
    METHOD_NAMES.each do |method_name|
      if (last_method_match = line.match(/def\s+(.+?)(\(|\n|\r\n)/))
        @last_method = last_method_match[1]
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

    return if translation_inspector.contains_interpolations?
    return if translation_with_key_exists?(translations_found, translation_inspector.full_key)

    yielder << translation_inspector
    translations_found << translation_inspector
  end

  def translation_with_key_exists?(translations_found, translation_full_key)
    translations_found.select { |t| t.full_key == translation_full_key }.any?
  end
end
