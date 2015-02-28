class AwesomeTranslations::Handlers::GeneralHandler < AwesomeTranslations::Handlers::BaseHandler
  VALID_BEGINNING = '(^|\s+|\(|\{|<%=\s*)'
  METHOD_NAMES = ["t"]

  def groups
    ArrayEnumerator.new do |yielder|
      AwesomeTranslations.config.paths_to_translate.each do |root_path|
        scan_folder(root_path, "", yielder)
      end
    end
  end

  def translations_for_group(group)
    ArrayEnumerator.new do |yielder|
      translations_double_helper = {}
      parse_file_path(group.data[:root_path], group.data[:full_path], yielder, translations_double_helper)
    end
  end

private

  def scan_folder(root_path, folder, yielder)
    Dir.foreach("#{root_path}/#{folder}") do |file|
      next if file == "." || file == ".."

      full_path = "#{folder}/#{file}".gsub(/^\//, "")
      real_full_path = "#{root_path}/#{full_path}".gsub("//", "/")

      if File.directory?(real_full_path)
        scan_folder(root_path, full_path, yielder)
      else
        extname = File.extname(real_full_path)

        if extname == ".rb"
          translations = []
          translations_double_helper = {}
          parse_file_path(root_path, full_path, translations, translations_double_helper)

          if translations.any?
            yielder << AwesomeTranslations::Group.new(
              id: Base64.urlsafe_encode64(real_full_path),
              handler: self,
              data: {
                name: full_path,
                root_path: root_path,
                full_path: full_path
              }
            )
          end
        end
      end
    end
  end

  def should_skip_line(file_path, line_no, line)
    # Skip the line if it is a comment in Haml.
    return true if File.extname(file_path) == ".rb" && line.match(/^\s*#/)
    return false
  end

  # Opens a file, reads the content while keeping track of line-numbers and saves found translations.
  def parse_file_path(root_path, file_path, yielder, translations)
    File.open("#{root_path}/#{file_path}", "r") do |fp|
      line_no = 0
      fp.each_line do |line|
        line_no += 1
        next if should_skip_line(file_path, line_no, line)
        parse_content(root_path, file_path, yielder, translations, line_no, line)
      end
    end
  end

  # Scans content for translations and saves them.
  def parse_content(root_path, file_path, yielder, translations, line_no, content)
    METHOD_NAMES.each do |method_name|
      # Scan for the various valid formats.
      content.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*\("(.+?)"/) do |match|
        add_translation(root_path, file_path, yielder, translations, line_no, match[1], match[2])
      end

      content.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*"(.+?)"/) do |match|
        add_translation(root_path, file_path, yielder, translations, line_no, match[1], match[2])
      end

      content.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*\('(.+?)'/) do |match|
        add_translation(root_path, file_path, yielder, translations, line_no, match[1], match[2])
      end

      content.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*'(.+?)'/) do |match|
        add_translation(root_path, file_path, yielder, translations, line_no, match[1], match[2])
      end
    end
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

  def add_translation(root_path, file_path, yielder, translations, line_no, method_name, translation)
    key = key_from_method(translation, method_name)

    sane_path = file_path.gsub("#{root_path}/", "")

    translation_key = key

    dir = File.dirname(sane_path)
    file = File.basename(sane_path)

    if match = file.match(/(.+?)\./)
      file = match[1]
    end

    translation_dir = dir
    translation_dir = translation_dir.gsub(/\Aapp\//, "")

    translation_key = translation_key_from_dir_file_and_key(dir, file, key)
    translation_key.gsub!(/\Aviews./, "") if translation_key.start_with?("views.")

    unless translation_with_key_exists?(translations, translation_key)
      translation = AwesomeTranslations::Translation.new(
        key: translation_key,
        dir: "#{root_path}/config/locales/awesome_translations/#{translation_dir}",
        file_path: "#{root_path}/#{file_path}",
        line_no: line_no
      )
      translations[translation_key] = true

      yielder << translation
    end
  end

  def translation_with_key_exists?(translations, translation_key)
    translations.key?(translation_key)
  end
end
