module AwesomeTranslations::ObjectExtensions
  def t(key, *args, &blk)
    AwesomeTranslations::GlobalTranslator.translate(key, caller_number: 1, translation_args: args, &blk)
  end
end
