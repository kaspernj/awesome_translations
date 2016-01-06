# Used to find translations in the Rails app by inspecting .erb- and .haml-files.
class AwesomeTranslations::ErbInspector
  AutoAutoloader.autoload_sub_classes(self, __FILE__)

  def initialize(args = {})
    @args = args
    @args[:exts] ||= [".erb", ".haml", ".rb", ".rake"]

    if @args[:dirs]
      @dirs = @args[:dirs]
    else
      @dirs = AwesomeTranslations.config.paths_to_translate
    end
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
    Dir.foreach("#{root_path}/#{path}") do |file|
      next if file == "." || file == ".."
      file_path = "#{path}"
      file_path << "/" unless file_path.empty?
      file_path << file

      full_path = "#{root_path}/#{file_path}"
      ext = File.extname(file_path)

      if File.directory?(full_path)
        scan_dir(file_path, root_path, yielder)
      elsif @args[:exts].include?(ext)
        yielder << AwesomeTranslations::ErbInspector::FileInspector.new(
          file_path: file_path,
          root_path: root_path
        )
      end
    end
  end
end
