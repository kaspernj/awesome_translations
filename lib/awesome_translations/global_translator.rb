class AwesomeTranslations::GlobalTranslator
  RUBY_2 = RUBY_VERSION.starts_with?("2")

  def self.call_information(caller_number)
    if RUBY_2
      # This is much faster than the other solution
      call = caller_locations(caller_number + 2, caller_number + 2).first

      {
        method: call.label,
        path: call.absolute_path,
        line_no: call.lineno
      }
    else
      call = caller[caller_number + 1]
      file_info = call.match(/\A(.+):(\d+):in `(.+?)'/)

      raise "Could not get previous file name from: #{caller[0]}" if file_info[1].blank?

      {
        method: file_info[3],
        path: file_info[1],
        line_no: file_info[2]
      }
    end
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

    I18n.t(@key, *args[:translation_args], &blk)
  end

private

  def dir
    if @_dir.nil?
      @_dir = File.dirname(previous_file)
      @_dir = @_dir.gsub(/\A#{Regexp.escape(Rails.root.to_s)}\//, "")
      @_dir = @_dir.gsub(/\Aspec\/dummy\//, "")

      if @_dir.starts_with?("app/controllers")
        @_dir = @_dir.gsub(/\Aapp\/controllers(\/?)/, "")
        @_is_controller = true
      elsif @_dir.starts_with?("app/views")
        @_dir = @_dir.gsub(/\Aapp\/views(\/?)/, "")
      elsif @_dir.starts_with?("app/")
        @_dir = @_dir.gsub(/\Aapp\//, "")
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
    translation_key = translation_key.gsub(/\Aapp\//, "")
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
