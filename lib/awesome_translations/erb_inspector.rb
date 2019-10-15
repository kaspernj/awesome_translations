# Used to find translations in the Rails app by inspecting .erb- and .haml-files.
class AwesomeTranslations::ErbInspector
  AutoAutoloader.autoload_sub_classes(self, __FILE__)

  def initialize(args = {})
    @args = args
    @args[:exts] ||= [".erb", ".haml", ".liquid", ".markerb", ".rb", ".rake", ".slim"] + AwesomeTranslations::ErbInspector::FileInspector::JS_FILE_EXTS

    @dirs = @args[:dirs] || AwesomeTranslations.config.paths_to_translate
    @ignored_folders = @args[:ignored_folders] || AwesomeTranslations.config.ignored_paths
  end

  # Yields all relevant .erb- and .haml-files.
  def files
    Enumerator.new do |yielder|
      @dirs.each do |dir|
        scan_dir("", dir, yielder)
      end
    end
  end

  def file(root_path, file_path)
    AwesomeTranslations::ErbInspector::FileInspector.new(
      file_path: file_path,
      root_path: root_path
    )
  end

private

  def scan_dir(path, root_path, yielder)
    full_path = "#{root_path}/#{path}"
    return if @ignored_folders.include?(full_path)

    Dir.foreach(full_path) do |file|
      next if file == "." || file == ".."

      file_path = path.clone
      file_path << "/" unless file_path.empty?
      file_path << file

      file_path_with_path = "#{path}/#{file_path}"

      full_path = "#{root_path}/#{file_path}"
      ext = File.extname(file_path)

      if File.directory?(full_path)
        scan_dir(file_path, root_path, yielder)
      elsif @args[:exts].include?(ext)
        scanned_file = AwesomeTranslations::CacheDatabaseGenerator::ScannedFile.find_or_initialize_by(file_path: file_path_with_path)
        file_size = File.size(full_path)
        last_changed_at = File.mtime(full_path)

        changed = false
        changed = true unless file_size == scanned_file.file_size
        changed = true unless last_changed_at.to_s == scanned_file.last_changed_at.to_s

        if changed
          scanned_file.assign_attributes(
            file_size: file_size,
            last_changed_at: last_changed_at
          )
          scanned_file.save!
        end

        yielder << AwesomeTranslations::ErbInspector::FileInspector.new(
          file_path: file_path,
          root_path: root_path,
          changed: changed
        )
      end
    end
  end
end
