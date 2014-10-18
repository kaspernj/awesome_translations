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

## Translating your application

Start a Rails server for your project and go to the namespace called something like "http://localhost:3000/awesome_translations". Start translating your app through the webinterface.


# License

This project rocks and uses MIT-LICENSE.
