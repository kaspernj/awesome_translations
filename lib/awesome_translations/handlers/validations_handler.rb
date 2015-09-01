class AwesomeTranslations::Handlers::ValidationsHandler < AwesomeTranslations::Handlers::BaseHandler
  def groups
    ArrayEnumerator.new do |yielder|
      AwesomeTranslations::ModelInspector.model_classes.each do |model_inspector|
        yielder << AwesomeTranslations::Group.new(
          id: model_inspector.clazz.name,
          handler: self
        )
      end
    end
  end

  def translations_for_group(group)
    ArrayEnumerator.new do |yielder|
      model_inspector = AwesomeTranslations::ModelInspector.model_classes.select { |model_inspector| model_inspector.clazz.name == group.name }.first
      raise "No inspector by that name: #{model_inspector.clazz.name}" unless model_inspector

      model_inspector.clazz._validators.each do |attribute_name, validators|
        validators.each do |validator|
          if validator.is_a?(ActiveModel::Validations::LengthValidator)
            translations_for_length_validator(validator, model_inspector, attribute_name, yielder)
          elsif validator.is_a?(ActiveModel::Validations::FormatValidator)
            translations_for_format_validator(validator, model_inspector, attribute_name, yielder)
          elsif validator.is_a?(ActiveRecord::Validations::UniquenessValidator)
            translations_for_uniqueness_validator(validator, model_inspector, attribute_name, yielder)
          elsif validator.class.name == "ActiveRecord::Validations::PresenceValidator"
            translations_for_presence_validator(validator, model_inspector, attribute_name, yielder)
          elsif validator.class.name == "EmailValidator"
            translations_for_email_validator(validator, model_inspector, attribute_name, yielder)
          elsif validator.class.name == "ActiveModel::Validations::ConfirmationValidator"
            translations_for_confirmation_validator(validator, model_inspector, attribute_name, yielder)
          end
        end
      end
    end
  end

private

  def translations_for_length_validator(validator, model_inspector, attribute_name, yielder)
    if validator.options[:minimum].present?
      add_translation("too_short", model_inspector, attribute_name, yielder) # "is too short. The minimum is %{count}"
    end

    if validator.options[:maximum].present?
      add_translation("too_long", model_inspector, attribute_name, yielder) # "is too long. The maximum is %{count}"
    end

    if validator.options[:is].present?
      add_translation("wrong_length", model_inspector, attribute_name, yielder) # "is not the correct length: %{count}"
    end
  end

  def translations_for_format_validator(validator, model_inspector, attribute_name, yielder)
    add_translation("invalid", model_inspector, attribute_name, yielder) # "is invalid"
  end

  def translations_for_uniqueness_validator(validator, model_inspector, attribute_name, yielder)
    add_translation("taken", model_inspector, attribute_name, yielder) # "has already been taken"
  end

  def translations_for_presence_validator(validator, model_inspector, attribute_name, yielder)
    add_translation("blank", model_inspector, attribute_name, yielder) # "cannot be blank"
  end

  def translations_for_email_validator(validator, model_inspector, attribute_name, yielder)
    add_translation("invalid", model_inspector, attribute_name, yielder) # "is invalid"
  end

  def translations_for_confirmation_validator(validator, model_inspector, attribute_name, yielder)
    snake_clazz_name = StringCases.camel_to_snake(model_inspector.clazz.name)

    yielder << AwesomeTranslations::Translation.new(
      key: "activerecord.attributes.#{snake_clazz_name}.#{attribute_name}_confirmation",
      dir: "#{Rails.root}/config/locales/awesome_translations/models/#{snake_clazz_name}"
    )
  end

  def add_translation(key, model_inspector, attribute_name, yielder)
    snake_clazz_name = StringCases.camel_to_snake(model_inspector.clazz.name)

    yielder << AwesomeTranslations::Translation.new(
      key: "activerecord.errors.models.#{snake_clazz_name}.attributes.#{attribute_name}.#{key}",
      dir: "#{Rails.root}/config/locales/awesome_translations/models/#{snake_clazz_name}"
    )
  end
end
