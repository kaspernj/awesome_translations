module AwesomeTranslations::ViewsHelper
  def helper_t(key, *args, **opts)
    AwesomeTranslations::GlobalTranslator.translate(key, helper: true, caller_number: 1, translation_args: args, translation_opts: opts)
  end
end
