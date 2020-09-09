class AwesomeTranslations::ErbInspector::TranslationInspector
  attr_reader :dir, :file_path, :last_method, :line_no, :method, :key, :full_key, :full_path, :root_path

  def initialize(args)
    @file_path = args[:file_path]
    @full_path = args[:full_path]
    @line_no = args[:line_no]
    @method = args[:method]
    @key = args[:key]
    @root_path = args[:root_path]
    @last_method = args[:last_method]

    @full_path = "#{@root_path}/#{@file_path}"

    generate_full_key
    generate_dir
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
    !relative? && key.exclude?(".")
  end

  def relative?
    key.start_with?(".")
  end

  def contains_interpolations?
    key =~ /#\{(.+?)\}/
  end

private

  def generate_full_key
    if (@method == "t" || @method == "helper_t" || @method == "controller_t" || @method == "I18n-js.t") && @key.start_with?(".")
      @full_key = File.dirname(@file_path).to_s

      if @full_key.starts_with?("app/mailers")
        @full_key.gsub!(/\Aapp\/mailers(\/|)/, "")
        is_mailer = true
      elsif @full_key.start_with?("app/views/")
        # Remove "app/views" from view-translations since that doesn't get used in keys.
        @full_key.delete_prefix!("app/views/")
      elsif @full_key.start_with?("app/controllers")
        # Remove "app/controllers" from controller-translations since that doesn't get used in keys.
        @full_key.gsub!(/\Aapp\/controllers(\/?)/, "")
        is_controller = true
      elsif @full_key.start_with?("app/cells")
        @full_key.delete_prefix!("app/cells/")
      elsif @full_key.start_with?("app/")
        # Remove "app" from controller- and helper-translations since that doesn't get used.
        @full_key.delete_prefix!("app/")
      end

      @full_key.tr!("/", ".")
      @full_key << "." unless @full_key.empty?
      @full_key << file_key(@file_path)
      @full_key << ".#{@last_method}" if (is_mailer || is_controller) && @last_method && @method != "controller_t"
      @full_key << "."
      @full_key << @key.delete_prefix(".")
    elsif @method == "I18n-js.t" || @method == "t" || @method == "helper_t" || @method == "controller_t"
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
    key.delete_prefix!("_")

    # Remove '_controller' from controllers
    key.delete_suffix!("_controller")

    key
  end

  def generate_dir
    parts = %w[config locales awesome_translations]

    key_parts = @full_key.split(".").reject(&:blank?)
    key_parts.pop

    @dir = Rails.root.join(*(parts + key_parts)).to_s
  end
end
