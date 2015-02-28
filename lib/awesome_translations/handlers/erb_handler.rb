class AwesomeTranslations::Handlers::ErbHandler < AwesomeTranslations::Handlers::BaseHandler
  METHOD_NAMES = ["_", "t"]
  VALID_BEGINNING = '(^|\s+|\(|\{|<%=\s*)'

  def groups
    ArrayEnumerator.new do |yielder|
      erb_inspector = AwesomeTranslations::ErbInspector.new
      erb_inspector.files.each do |file|
        yielder << AwesomeTranslations::Group.new(
          id: Base64.urlsafe_encode64(file.full_path),
          handler: self,
          data: {
            name: file.file_path,
            root_path: file.root_path,
            full_path: file.full_path
          }
        )
      end
    end
  end

  def translations_for_group(group)
    ArrayEnumerator.new do |yielder|
      translations = []

      # Parse views for translations.
      erb_inspector = AwesomeTranslations::ErbInspector.new
      file = erb_inspector.files.select { |file| file.full_path == group.data[:full_path] }.first

      file.translations.each do |translation|
        yielder << translation.model
      end
    end
  end
end
