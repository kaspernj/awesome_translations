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

You will also need to modify the line in your Gemfile a bit:
```ruby
gem 'awesome_translations'
```

## Translating your application

Start a Rails server for your project and go to the namespace called something like "http://localhost:3000/awesome_translations". Start translating your app through the webinterface.


# License

This project rocks and uses MIT-LICENSE.
