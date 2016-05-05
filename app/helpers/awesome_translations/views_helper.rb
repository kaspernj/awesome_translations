module AwesomeTranslations::ViewsHelper
  def helper_t(key, args = {})
    AwesomeTranslations::GlobalTranslator.translate(key, helper: true, caller_number: 1, translation_args: [args])
  end
end
