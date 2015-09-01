module AwesomeTranslations::ApplicationHelper
  def helper_t(key, args = {})
    AwesomeTranslations::GlobalTranslator.translate(key, caller_number: 1, translation_args: [args])
  end
end
