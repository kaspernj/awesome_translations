class AwesomeTranslations::Handlers::ErbHandler < AwesomeTranslations::Handlers::BaseHandler
  METHOD_NAMES = ["_", "t"]
  VALID_BEGINNING = '(^|\s+|\(|\{|<%=\s*)'

  def files(dirs = nil, root_path = nil, &blk)
    if dirs == nil
      dirs = AwesomeTranslations.config.paths_to_translate
      is_root = true
    elsif dirs.is_a?(String)
      dirs = [dirs]
    end

    dirs.each do |path|
      root_path = path if root_path == nil && is_root

      Dir.foreach(path) do |file|
        next if file == "." || file == ".."

        file_path = "#{path}/#{file}"

        if File.directory?(file_path)
          files(file_path, root_path, &blk)
        elsif file.include?(".erb") || file.include?(".haml")
          blk.call(file_path, root_path)
        end
      end
    end
  end

  def translations
    translations = []

    files do |file_path, root_path|
      parse_file_path(root_path, file_path, translations)
    end

    translations.sort! { |translation1, translation2| translation1.key <=> translation2.key }

    return translations
  end

  def groups
    ArrayEnumerator.new do |yielder|
      AwesomeTranslations.config.paths_to_translate.each do |path|
        views_path = "app/views"
        scan_folder_for_groups(path, views_path, yielder)
      end
    end
  end

  def translations_for_group(group)
    ArrayEnumerator.new do |yielder|
      translations = []

      # Parse controller file for translations.
      if name_match = group.data[:name].match(/\Aviews\/(.+)\Z/)
        resources_name = name_match[1]
        controller_file = "#{group.data[:root_path]}/app/controllers/#{resources_name}_controller.rb"

        parse_file_path(group.data[:root_path], controller_file, translations) if File.exists?(controller_file)
      end

      # Parse views for translations.
      files(group.data[:full_path]) do |file_path|
        parse_file_path(group.data[:root_path], file_path, translations)
      end

      # Sort translations and yield them back.
      translations.sort! { |translation1, translation2| translation1.key <=> translation2.key }
      translations.each do |translation|
        yielder << translation
      end
    end
  end

private

  def scan_folder_for_groups(root_path, folder_path, yielder)
    Dir.foreach("#{root_path}/#{folder_path}") do |file|
      next if file == "." || file == ".."

      full_path = "#{folder_path}/#{file}"
      real_full_path = "#{root_path}/#{full_path}"

      if File.directory?(real_full_path)
        if folder_contain_view_files?(real_full_path)
          name = full_path.gsub(/\Aapp\//, "")

          group = AwesomeTranslations::Group.new(
            id: Base64.urlsafe_encode64(real_full_path),
            handler: self,
            data: {
              name: name,
              root_path: root_path,
              full_path: real_full_path
            }
          )
          yielder << group
        end

        scan_folder_for_groups(root_path, full_path, yielder)
      end
    end
  end

  def folder_contain_view_files?(folder_path)
    Dir.foreach(folder_path) do |file|
      next if file == "." || file == ".."

      ext = File.extname(file)
      return true if ext == ".erb" || ext == ".haml"
    end

    return false
  end

  # Opens a file, reads the content while keeping track of line-numbers and saves found translations.
  def parse_file_path(root_path, file_path, translations)
    File.open(file_path, "r") do |fp|
      line_no = 0
      fp.each_line do |line|
        line_no += 1
        next if should_skip_line(file_path, line_no, line)
        parse_content(root_path, file_path, translations, line_no, line)
      end
    end
  end

  # Scans content for translations and saves them.
  def parse_content(root_path, file_path, translations, line_no, content)
    METHOD_NAMES.each do |method_name|
      # Scan for the various valid formats.
      content.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*\("(.+?)"/) do |match|
        add_translation(root_path, file_path, translations, line_no, match[1], match[2])
      end

      content.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*"(.+?)"/) do |match|
        add_translation(root_path, file_path, translations, line_no, match[1], match[2])
      end

      content.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*\('(.+?)'/) do |match|
        add_translation(root_path, file_path, translations, line_no, match[1], match[2])
      end

      content.scan(/#{VALID_BEGINNING}(#{Regexp.escape(method_name)})\s*'(.+?)'/) do |match|
        add_translation(root_path, file_path, translations, line_no, match[1], match[2])
      end
    end
  end

  def should_skip_line(file_path, line_no, line)
    # Skip the line if it is a comment in Haml.
    return true if File.extname(file_path) == ".haml" && line.match(/^(\s*)-(\s*)#/)
    return false
  end

  def add_translation(root_path, file_path, translations, line_no, method_name, translation)
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
        file_path: file_path,
        line_no: line_no
      )

      translations << translation
    end
  end

  def translation_with_key_exists?(translations, translation_key)
    translations.select { |t| t.key == translation_key }.any?
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
