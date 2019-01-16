# alpha

Setting up a rails project takes at least one day to configure.

This is my attempt to make it as fast as possible.

## Getting Started

### Requirements

- ruby 2.6.0
- rails 5.2
- nodejs 10.4.0
- yarn

I recommend using `asdf` to manage ruby and nodejs versions.

### Basic Usage

```
rails new appname \
  -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb
```

### Recommended Usage

```
rails new appname --database=postgresql --skip-test \
  --skip-sprockets --skip-turbolinks --skip-coffee \
  --skip-javascript --webpack \
  -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb
```

## Features

- Folder Structure for `--webpack`
- Essential npm packages for `--webpack`
- Use [slim](https://github.com/slim-template/slim) as templating language
- Rspec test suite
- Preconfigured linters
- Scripts

### Folder Structure

```
├── app
├── channels
├── assets
├── channels
├── javascript
│   ├── css
│   │   ├── components
│   │   │   └── home-page.scss
│   │   ├── application.scss
│   │   └── vendor.scss
│   ├── images
│   │   ├── application.js
│   │   └── rails-logo.svg
│   ├── js
│   │   └── application.js
│   └── packs
│       └── application.js
├── jobs
└── mailers
```

### Essential packages

- sanitize.css

### Rspec test suite

Includes rspec and other gems useful in testing.

```ruby
gem_group :development, :test do
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem "rubocop", require: false
  gem 'rubocop-rspec'
end

gem_group :test do
  gem 'capybara'
  gem 'chromedriver-helper'
  gem 'database_cleaner'
  gem 'faker'
  gem 'selenium-webdriver'
end
```

### Preconfigured linters

- Rubocop
- Eslint
- Prettier
- Stylelint

### Scripts

|         Command         |               Description                |
| :---------------------: | :--------------------------------------: |
|   yarn run lint:ruby    |                 rubocop                  |
|    yarn run lint:js     |                  eslint                  |
|    yarn run lint:css    |                stylelint                 |
| yarn run prettier:check |             prettier-eslint              |
|  yarn run prettier:fix  |             prettier-eslint              |
|    yarn run lint:ci     | rubocop eslint stylelint prettier-eslint |

## Post Install Guide

### Convert existing erb files to slim

1. `gem install html2slim`
1. Run `erb2slim -d app/views` on project directory
1. `gem uninstall html2slim`

## TODO

- One source for specifying versions (ruby/nodejs/etc) (use `.tool-versions`?)
- Finish post setup of essential gems
- Improve homepage style
- Initial react setup
- Add sample js tests
- Docker setup and instructions
- Circleci config and instructions

## License

MIT
