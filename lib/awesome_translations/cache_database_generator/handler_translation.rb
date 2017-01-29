class AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation < BazaModels::Model
  belongs_to :group, foreign_key: "group_id", class_name: "AwesomeTranslations::CacheDatabaseGenerator::Group"
  belongs_to :handler, foreign_key: "handler_id", class_name: "AwesomeTranslations::CacheDatabaseGenerator::Handler"
  belongs_to :translation_key, foreign_key: "translation_key_id", class_name: "AwesomeTranslations::CacheDatabaseGenerator::TranslationKey"

  validates_presence_of :handler, :translation_key

  delegate :key, :last_key, to: :translation_key
  delegate :value, to: :translation, prefix: true
  delegate :array_translation?, :file_line_content, :file_line_content?, :translated_value_for_locale, to: :translation

  def key_show_with_fallback
    key_show.presence || last_key
  end

  def translation
    @translation ||= AwesomeTranslations::Translation.new(
      key: key,
      dir: dir,
      full_path: full_path,
      file_path: file_path,
      line_no: line_no
    )
  end

  def finished?
    @_finished = translation.finished? if @finished.nil?
    @_finished
  end

  def unfinished?
    !finished?
  end

  def array_key
    return unless (match = key.match(/\A(.+)\[(\d+)\]\Z/))
    match[1]
  end

  def array_no
    return unless (match = key.match(/\A(.+)\[(\d+)\]\Z/))
    match[2].to_i
  end
end
