class AwesomeTranslations::Handlers::WillPaginateHandler < AwesomeTranslations::Handlers::BaseHandler
  def enabled?
    ::Object.const_defined?(:WillPaginate)
  end

  def groups
    ArrayEnumerator.new do |yielder|
      groups = ["will_paginate"]

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
      __send__(:"translations_for_#{group.id}", dir, group, yielder)
    end
  end

private

  def translations_for_will_paginate(dir, group, yielder)
    add_translations_for_hash(
      dir,
      group,
      yielder,
      translations: {
        will_paginate: {
          previous_label: "&#8592; Previous",
          next_label: "Next &#8594;",
          page_gap: "&hellip;",
          page_entries_info: {
            single_page: {
              zero: "No %{model} found",
              one: "Displaying 1 %{model}",
              other: "Displaying all %{count} %{model}"
            },
            single_page_html: {
              zero: "No %{model} found",
              one: "Displaying <b>1</b> %{model}",
              other: "Displaying <b>all&nbsp;%{count}</b> %{model}"
            },
            multi_page: "Displaying %{model} %{from} - %{to} of %{count} in total",
            multi_page_html: "Displaying %{model} <b>%{from}&nbsp;-&nbsp;%{to}</b> of <b>%{count}</b> in total"
          }
        }
      }
    )
  end
end
