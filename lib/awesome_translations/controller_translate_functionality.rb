# Include this module to get access to the t-method.
module AwesomeTranslations::ControllerTranslateFunctionality
  # Implements the method on both class- and instance-level.
  def self.included(base)
    base.__send__(:include, Methods)
    base.extend Methods
  end

  module Methods
    def controller_t(key, *args, **opts, &blk)
      AwesomeTranslations::GlobalTranslator.translate(key, action_in_key: false, caller_number: 1, translation_args: args, translation_opts: opts, &blk)
    end
  end
end
