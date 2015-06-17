[![Build Status](https://api.shippable.com/projects/544232fcb904a4b21567a417/badge?branchName=master)](https://app.shippable.com/projects/544232fcb904a4b21567a417/builds/latest)
[![Code Climate](https://codeclimate.com/github/kaspernj/awesome_translations/badges/gpa.svg)](https://codeclimate.com/github/kaspernj/awesome_translations)
[![Test Coverage](https://codeclimate.com/github/kaspernj/awesome_translations/badges/coverage.svg)](https://codeclimate.com/github/kaspernj/awesome_translations)

# AwesomeTranslations

## Install

```ruby
gem 'awesome_translations', group: :development
```

Then run the following:
```
bundle exec rake awesome_translations:install
```

Insert this into your "routes.rb" file:
```ruby
mount AwesomeTranslations::Engine => "/awesome_translations" if Rails.env.development?
```

## Translations under controllers and models

If you want to do translations from your models or controllers, you will need to add this to a new initializer file under "config/initializers/awesome_translations.rb"

```ruby
AwesomeTranslations.load_object_extensions
```

If you don't like monkey patching the Object-class, you can also load it like this by creating 'config/initializers/awesome_translations' and insert something like this to allow t-method-calls from inside models:
```ruby
ActiveRecord::Base.include AwesomeTranslations::TranslateFunctionality
```

You will also need to modify the line in your Gemfile a bit:
```ruby
gem 'awesome_translations'
```

## Helper translations

The t-method translates like from inside a view in Rails. To get around this, you can call 'helper_t' instead. Start by including that method in your helpers by adding this to ApplicationHelper:
```ruby
module ApplicationHelper
  include AwesomeTranslations::ApplicationHelper
end
```

This is an example of how it works and what the difference is:
```ruby
module ApplicationHelper
  include AwesomeTranslations::ApplicationHelper

  # Sample method with translation
  def hello_world
    t('.hello_world') #=> translates with key '#{controller_name}.#{action_name}.hello_world'
    return helper_t('.hello_world') #=> translates with key 'helpers.application_helper.hello_world'
  end
end
```

## Translating your application

Start a Rails server for your project and go to the namespace called something like "http://localhost:3000/awesome_translations". Start translating your app through the webinterface.


# License

This project rocks and uses MIT-LICENSE.
