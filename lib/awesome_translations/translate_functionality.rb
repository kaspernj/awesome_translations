# Include this class to get access to the t-method.
module AwesomeTranslations::TranslateFunctionality
  def t(key, args = {}, &blk)
    AwesomeTranslations::GlobalTranslator.translate(key, translation_args: args, caller_number: 1, &blk)
  end
end
