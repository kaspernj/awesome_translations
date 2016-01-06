class AwesomeTranslations::Handlers::GlobalHandler < AwesomeTranslations::Handlers::BaseHandler
  def groups
    ArrayEnumerator.new do |yielder|
      yielder << AwesomeTranslations::Group.new(
        id: "global",
        handler: self,
        data: {
          name: "Global translations"
        }
      )
    end
  end

  def translations_for_group(_group)
    ArrayEnumerator.new do |yielder|
      translations_found = {}

      erb_inspector = AwesomeTranslations::ErbInspector.new
      erb_inspector.files.each do |file|
        file.translations.each do |translation|
          next unless translation.global?

          unless translations_found.key?(translation.full_key)
            translations_found[translation.full_key] = true
            yielder << translation.model
          end
        end
      end
    end
  end
end
