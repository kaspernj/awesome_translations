class AwesomeTranslations::Handlers::BaseHandler
  def add_translations_for_hash(dir, group, yielder, hash)
    translations_for_hash_recursive(dir, hash[:translations], yielder, [])
  end

  def translations_for_hash_recursive(dir, hash, yielder, current_keys)
    hash.each do |key, value|
      current_keys << key

      if value.is_a?(Hash)
        translations_for_hash_recursive(dir, value, yielder, current_keys)
      elsif value.is_a?(Array)
        value.each_index do |index|
          yielder << AwesomeTranslations::Translation.new(
            dir: dir,
            key: "#{current_keys.join('.')}[#{index}]",
            key_show: "#{current_keys.join('.')}[#{index}]"
          )
        end
      else
        yielder << AwesomeTranslations::Translation.new(
          dir: dir,
          key: current_keys.join('.'),
          key_show: current_keys.join('.'),
          default: value
        )
      end

      current_keys.pop
    end
  end

  def enabled?
    true
  end
end
