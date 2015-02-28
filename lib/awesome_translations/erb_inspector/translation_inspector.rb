class AwesomeTranslations::ErbInspector::TranslationInspector
  attr_reader :dir, :file_path, :line_no, :method, :key, :full_key

  def initialize(args)
    @dir, @file_path, @full_path, @line_no = args[:dir], args[:file_path], args[:full_path], args[:line_no]
    @method, @key, @translation_dir = args[:method], args[:key], args[:translation_dir]

    generate_full_key
  end

  def model
    AwesomeTranslations::Translation.new(
      key: @full_key,
      dir: @dir,
      full_path: @full_path,
      file_path: @file_path,
      line_no: @line_no
    )
  end

private

  def generate_full_key
    if @method == "t"
      @full_key = @translation_dir

      if @full_key.start_with?("app/views/")
        # Remove "app/views" from view-translations since that doesn't get used in keys.
        @full_key = @full_key.gsub(/\Aapp\/views\//, "")
      elsif @full_key.start_with?("app/")
        # Remove "app" from controller- and helper-translations since that doesn't get used.
        @full_key = @full_key.gsub(/\Aapp\//, "")
      end

      @full_key = @full_key.gsub("/", ".")
      @full_key << "."
      @full_key << file_key(@file_path)
      @full_key << "."
      @full_key << @key.gsub(/\A\./, "")
    else
      raise "Unknown method-name: '#{@method}'."
    end
  end

  def file_key(file_path)
    key = File.basename(file_path)

    # Remove extension
    key = key.match(/\A(.+?)\./)[1]

    # Remove leading "_" from partials
    key = key.gsub(/\A_/, "")

    return key
  end
end
