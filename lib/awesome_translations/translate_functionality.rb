# Include this module to get access to the t-method.
module AwesomeTranslations::TranslateFunctionality
  # Implements the method on both class- and instance-level.
  def self.included(base)
    base.__send__(:include, Methods)
    base.extend Methods
  end

  module Methods
    def t(key, args = {}, &blk)
      AwesomeTranslations::GlobalTranslator.translate(key, translation_args: [args], caller_number: 1, &blk)
    end
  end
end
