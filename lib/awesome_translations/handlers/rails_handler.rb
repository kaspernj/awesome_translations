class AwesomeTranslations::Handlers::RailsHandler < AwesomeTranslations::Handlers::BaseHandler
  def groups
    ArrayEnumerator.new do |yielder|
      groups = %w(date_time errors helpers numbers support)

      groups.each do |group|
        yielder << AwesomeTranslations::Group.new(
          id: group,
          handler: self,
          data: {
            name: group.humanize
          }
        )
      end
    end
  end

  def translations_for_group(group)
    ArrayEnumerator.new do |yielder|
      dir = Rails.root.join("config", "locales", "awesome_translations", group.id).to_s
      __send__("translations_for_#{group.id}", dir, group, yielder)
    end
  end

private

  def translations_for_errors(dir, group, yielder)
    add_translations_for_hash(
      dir,
      group,
      yielder,
      translations: {
        errors: {
          format: "%{attribute} %{message}",
          messages: {
            accepted: "must be accepted",
            blank: "can't be blank",
            confirmation: "doesn't match %{attribute}",
            empty: "can't be empty",
            equal_to: "must be equal to %{count}",
            even: "must be even",
            exclusion: "is reserved",
            greater_than: "must be greater than %{count}",
            greater_than_or_equal_to: "must be greater than or equal to %{count}",
            inclusion: "is not included in the list",
            invalid: "is invalid",
            less_than: "must be less than %{count}",
            less_than_or_equal_to: "must be less than or equal to %{count}",
            not_a_number: "is not a number",
            not_an_integer: "must be an integer",
            odd: "must be odd",
            record_invalid: "Validation failed: %{errors}",
            taken: "has already been taken",
            too_long: {
              one: "is too long (maximum is 1 character)",
              other: "is too long (maximum is %{count} characters)"
            },
            too_short: {
              one: "is too short (minimum is 1 character)",
              other: "is too short (minimum is %{count} characters)"
            },
            wrong_length: {
              one: "is the wrong length (should be 1 character)",
              other: "is the wrong length (should be %{count} characters)"
            }
          },
          template: {
            body: "There were problems with the following fields:",
            header: {
              one: "1 error prohibited this %{model} from being saved",
              other: "%{count} errors prohibited this %{model} from being saved"
            }
          }
        }
      }
    )
  end

  def translations_for_date_time(dir, group, yielder)
    add_translations_for_hash(
      dir,
      group,
      yielder,
      translations: {
        date: {
          formats: {
            default: "%Y-%m-%d",
            short: "%b %d",
            long: "%B %d, %Y"
          },
          day_names: [0, 1, 2, 3, 4, 5, 6],
          abbr_day_names: [0, 1, 2, 3, 4, 5, 6],
          month_names: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
          abbr_month_names: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
          order: [0, 1, 2]
        },
        time: {
          formats: {
            default: "%a, %d %b %Y %H:%M:%S %z",
            short: "%d %b %H:%M",
            long: "%B %d, %Y %H:%M"
          },
          am: "am",
          pm: "pm"
        }
      }
    )
  end

  def translations_for_helpers(dir, group, yielder)
    add_translations_for_hash(
      dir,
      group,
      yielder,
      translations: {
        helpers: {
          select: {
            prompt: "Please select"
          },
          submit: {
            create: "Create %{model}",
            submit: "Save %{model}",
            update: "Update %{model}"
          }
        }
      }
    )
  end

  def translations_for_support(dir, group, yielder)
    add_translations_for_hash(
      dir,
      group,
      yielder,
      translations: {
        array: {
          last_word_connector: " and ",
          two_words_connector: " and ",
          word_connector: ", "
        }
      }
    )
  end

  def translations_for_numbers(dir, group, yielder)
    add_translations_for_hash(
      dir,
      group,
      yielder,
      translations: {
        number: {
          currency: {
            format: {
              delimiter: ",",
              format: "%n %u",
              separator: ".",
              unit: "$"
            }
          },
          format: {
            delimiter: ",",
            separator: "."
          },
          human: {
            decimal_units: {
              format: "%n %u",
              units: {
                billion: "Billion",
                million: "Million",
                quadrillion: "Quadrillion",
                thousand: "Thousand",
                trillion: "Trillion",
                unit: ""
              }
            },
            format: {
              delimiter: ""
            },
            storage_units: {
              format: "%n %u",
              units: {
                byte: {
                  one: "Byte",
                  other: "Bytes"
                },
                gb: "GB",
                kb: "KB",
                mb: "MB",
                tb: "TB"
              }
            }
          },
          percentage: {
            format: {
              delimiter: ""
            }
          }
        }
      }
    )
  end
end
