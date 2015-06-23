class AwesomeTranslations::ErbInspector::TranslationInspector
  attr_reader :dir, :file_path, :last_method, :line_no, :method, :key, :full_key, :full_path, :root_path

  def initialize(args)
    @dir, @file_path, @full_path, @line_no = args[:dir], args[:file_path], args[:full_path], args[:line_no]
    @method, @key, @root_path, @last_method = args[:method], args[:key], args[:root_path], args[:last_method]

    @full_path = "#{@root_path}/#{@file_path}"

    generate_dir
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

  def global?
    !key.start_with?(".")
  end

private

  def generate_full_key
    if (@method == 't' || @method == 'helper_t') && @key.start_with?('.')
      @full_key = "#{File.dirname(@file_path)}"

      if @full_key.starts_with?("app/mailers")
        @full_key.gsub!(/\Aapp\/mailers(\/|)/, "")
        is_mailer = true
      elsif @full_key.start_with?("app/views/")
        # Remove "app/views" from view-translations since that doesn't get used in keys.
        @full_key.gsub!(/\Aapp\/views\//, "")
      elsif @full_key.start_with?('app/controllers')
        # Remove "app/controllers" from controller-translations since that doesn't get used in keys.
        @full_key.gsub!(/\Aapp\/controllers(\/?)/, '')
        is_controller = true
      elsif @full_key.start_with?('app/cells')
        @full_key.gsub!(/\Aapp\/cells\//, '')
      elsif @full_key.start_with?("app/")
        # Remove "app" from controller- and helper-translations since that doesn't get used.
        @full_key.gsub!(/\Aapp\//, "")
      end

      @full_key.gsub!("/", ".")
      @full_key << "." unless @full_key.empty?
      @full_key << file_key(@file_path)
      @full_key << ".#{@last_method}" if (is_mailer || is_controller) && @last_method
      @full_key << "."
      @full_key << @key.gsub(/\A\./, "")
    elsif @method == 't' || @method == 'helper_t'
      @full_key = @key
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

    # Remove '_controller' from controllers
    key = key.gsub(/_controller\Z/, '')

    return key
  end

  def generate_dir
    if @key.start_with?(".")
      file_base_name = File.basename(@file_path).match(/\A(.+?)\./)[1]

      @dir = Rails.root.join('config', 'locales', 'awesome_translations', File.dirname(@file_path), file_base_name).to_s
    else
      @dir = Rails.root.join('config', 'locales', 'awesome_translations').to_s
    end
  end
end
