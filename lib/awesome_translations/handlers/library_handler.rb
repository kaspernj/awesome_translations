class AwesomeTranslations::Handlers::LibraryHandler < AwesomeTranslations::Handlers::BaseHandler
  def groups
    ArrayEnumerator.new do |yielder|
      erb_inspector.files.each do |file|
        id = file.file_path.gsub(/[^A-z0-9]/, "_")

        group = AwesomeTranslations::Group.new(
          id: id,
          handler: self,
          data: {
            name: file.file_path,
            root_path: file.root_path,
            full_path: file.full_path,
            file_path: file.file_path
          }
        )

        yielder << group if translations_for_group(group).any?
      end
    end
  end

  def translations_for_group(group)
    ArrayEnumerator.new do |yielder|
      file = erb_inspector.file(group.data[:root_path], group.data[:file_path])

      file.translations.each do |translation|
        next if translation.global?
        yielder << translation.model
      end
    end
  end

private

  def erb_inspector
    @erb_inspector ||= AwesomeTranslations::ErbInspector.new(
      exts: ['.rb', '.rake']
    )
  end
end
