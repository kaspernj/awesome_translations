class AwesomeTranslations::Handlers::ErbHandler < AwesomeTranslations::Handlers::BaseHandler
  METHOD_NAMES = ["_", "t"]
  VALID_BEGINNING = '(^|\s+|\(|\{|<%=\s*)'

  def files(dir = Rails.root, &blk)
    Dir.foreach(dir) do |file|
      next if file == "." || file == ".."

      file_path = "#{dir}/#{file}"

      if File.directory?(file_path)
        files(file_path, &blk)
      elsif file.include?(".erb") || file.include?(".haml")
        blk.call(file_path)
      end
    end
  end

  def translations
    translations = []

    files do |file_path|
      parse_file_path(file_path, translations)
    end

    return translations
  end

private

  # Opens a file, reads the content while keeping track of line-numbers and saves found translations.
  def parse_file_path(file_path, translations)
    File.open(file_path, "r") do |fp|
      line_no = 0
      fp.each_line do |line|
        line_no += 1
        next if should_skip_line(file_path, line_no, line)
        parse_content(file_path, translations, line_no, line)
      end
    end
  end

  # Scans content for translations and saves them.
  def parse_content(file_path, translations, line_no, content)
    METHOD_NAMES.each do |method_name|
      # Scan for the various valid formats.
      content.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*\("(.+?)"/) do |match|
        add_translation(file_path, translations, line_no, match[1], match[2])
      end

      content.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*"(.+?)"/) do |match|
        add_translation(file_path, translations, line_no, match[1], match[2])
      end

      content.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*\('(.+?)'/) do |match|
        add_translation(file_path, translations, line_no, match[1], match[2])
      end

      content.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*'(.+?)'/) do |match|
        add_translation(file_path, translations, line_no, match[1], match[2])
      end
    end
  end

  def should_skip_line(file_path, line_no, line)
    # Skip the line if it is a comment in Haml.
    return true if File.extname(file_path) == ".haml" && line.match(/^(\s*)-(\s*)#/)
    return false
  end

  def add_translation(file_path, translations, line_no, method_name, translation)
    key = key_from_method(translation, method_name)

    sane_path = file_path.gsub("#{Rails.root}/", "")

    translation_key = key

    dir = File.dirname(sane_path)
    file = File.basename(sane_path)

    if match = file.match(/(.+?)\./)
      file = match[1]
    end

    translation_dir = dir
    translation_dir = translation_dir.gsub(/\Aapp\//, "")

    translation_key = translation_key_from_dir_file_and_key(dir, file, key)

    unless translation_with_key_exists?(translations, translation_key)
      translation = AwesomeTranslations::Translation.new(
        key: translation_key,
        dir: translation_dir
      )

      translations << translation
    end
  end

  def translation_with_key_exists?(translations, translation_key)
    translations.select { |t| t.key == translation_key }.length > 0
  end

  def translation_key_from_dir_file_and_key(dir, file, key)
    return key unless key.starts_with?(".")

    translation_key = dir
    translation_key = translation_key.gsub(/\Aapp\//, "")
    translation_key << "/#{file}"
    translation_key.gsub!("/", ".")
    translation_key << key

    return translation_key
  end

  def key_from_method(translation, method_name)
    if method_name == "t"
      return translation
    elsif method_name == "_"
      key = translation
        .underscore
        .gsub(/%{(.+?)}/, "")
        .gsub(/\s+/, "_")
        .gsub(/[^a-z\d_]/, "")
        .gsub(/[_]+\Z/, "")

      return ".#{key}"
    else
      raise "Unknown method-name: '#{method_name}'."
    end
  end
end
