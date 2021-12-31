class AwesomeTranslations::GlobalTranslator
  def self.call_information(caller_number)
    # This is much faster than the other solution
    call = caller_locations(caller_number + 2, caller_number + 2).first

    {
      method: call.label,
      path: call.absolute_path,
      line_no: call.lineno
    }
  end

  def self.translate(key, args, &blk)
    caller_number = args[:caller_number] || 0

    if args[:call]
      call = args.fetch(:call)
    else
      call = call_information(caller_number)
    end

    new(key: key, args: args, blk: blk, call: call).translation
  end

  attr_reader :key, :args, :blk, :call

  def initialize(init_args)
    @key = init_args.fetch(:key)
    @args = init_args.fetch(:args)
    @blk = init_args.fetch(:blk)
    @call = init_args.fetch(:call)
  end

  def translation
    if @key.is_a?(String) && @key.start_with?(".")
      # Change key to full path.
      @key = translation_key
    end

    I18n.t(@key, *args[:translation_args], **args[:translation_opts], &blk)
  end

private

  def dir
    if @_dir.nil?
      @_dir = File.dirname(previous_file)
      @_dir.delete_prefix!("#{Rails.root}/") # rubocop:disable Rails/FilePath
      @_dir.delete_prefix!("spec/dummy/")

      if @_dir.starts_with?("app/controllers")
        @_dir = @_dir.gsub(/\Aapp\/controllers(\/?)/, "")
        @_is_controller = true
      elsif @_dir.starts_with?("app/views")
        @_dir = @_dir.gsub(/\Aapp\/views(\/?)/, "")
      elsif @_dir.starts_with?("app/")
        @_dir.delete_prefix!("app/")
      end
    end

    @_dir
  end

  def file
    if @_file.nil?
      @_file = File.basename(previous_file, File.extname(previous_file))
      @_file = @_file.gsub(/_controller\Z/, "") if controller?
    end

    @_file
  end

  def controller?
    dir
    @_is_controller
  end

  def previous_file
    if @_previous_file.nil?
      @_previous_file = call[:path]

      # Remove any Rails root.
      AwesomeTranslations::ModelInspector.engines.each do |engine|
        root = engine.root.to_s

        next unless @_previous_file.starts_with?(root)

        @_previous_file = @_previous_file.gsub(/\A#{Regexp.escape(root)}\//, "")
        break
      end
    end

    @_previous_file
  end

  def translation_key
    translation_key = dir
    translation_key = translation_key.delete_prefix("app/")
    translation_key << "/#{file}"

    key_parts = translation_key.split("/")
    last_key_part = key_parts.pop
    last_key_part = last_key_part[1, last_key_part.length] if last_key_part.start_with?("_")

    key_parts << last_key_part
    key_parts << call[:method] if controller? && args[:action_in_key] != false

    full_key = key_parts.join(".")
    full_key << key
    full_key
  end
end
