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
            full_path: file.full_path,
            file_path: file.file_path
          }
        )
      end
    end
  end

  def translations_for_group(group)
    ArrayEnumerator.new do |yielder|
      translations = []

      # Parse views for translations.
      file = AwesomeTranslations::ErbInspector.new.file(group.data[:root_path], group.data[:file_path])
      file.translations.each do |translation|
        next if translation.global?
        yielder << translation.model
      end
    end
  end
end
