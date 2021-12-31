module AwesomeTranslations::ObjectExtensions
  def t(key, *args, **opts, &blk)
    AwesomeTranslations::GlobalTranslator.translate(key, caller_number: 1, translation_args: args, translation_opts: opts, &blk)
  end
end
