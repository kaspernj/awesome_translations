class AwesomeTranslations::GlobalTranslator
  RUBY_2 = RUBY_VERSION.starts_with?("2")

  def self.translate(key, args, &blk)
    if key.is_a?(String) && key.start_with?(".")
      caller_number = args[:caller_number] || 0

      call = call_information(caller_number)
      previous_file = call[:path]

      # Remove any Rails root.
      removed_root = false
      AwesomeTranslations::ModelInspector.engines.each do |engine|
        root = engine.root.to_s

        next unless previous_file.starts_with?(root)
        previous_file = previous_file.gsub(/\A#{Regexp.escape(root)}\//, "")
        removed_root = true
        break
      end

      dir = File.dirname(previous_file)
      dir = dir.gsub(/\A#{Regexp.escape(Rails.root.to_s)}\//, "")
      dir = dir.gsub(/\Aspec\/dummy\//, "")

      file = File.basename(previous_file, File.extname(previous_file))

      if dir.starts_with?("app/controllers")
        dir = dir.gsub(/\Aapp\/controllers(\/?)/, "")
        file = file.gsub(/_controller\Z/, "")
        is_controller = true
      elsif dir.starts_with?("app/")
        dir = dir.gsub(/\Aapp\//, "")
      end

      translation_key = dir
      translation_key = translation_key.gsub(/\Aapp\//, "")
      translation_key << "/#{file}"
      translation_key.tr!("/", ".")
      translation_key << ".#{call[:method]}" if is_controller && args[:action_in_key] != false
      translation_key << key

      # Change key to full path.
      key = translation_key
    end

    I18n.t(key, *args[:translation_args], &blk)
  end

  def self.call_information(caller_number)
    if RUBY_2
      # This is much faster than the other solution
      call = caller_locations(caller_number + 2, caller_number + 2).first

      return {
        method: call.label,
        path: call.absolute_path,
        line_no: call.lineno
      }
    else
      call = caller[caller_number + 1]
      file_info = call.match(/\A(.+):(\d+):in `(.+?)'/)

      raise "Could not get previous file name from: #{caller[0]}" unless file_info[1].present?

      return {
        method: file_info[3],
        path: file_info[1],
        line_no: file_info[2]
      }
    end
  end
end
