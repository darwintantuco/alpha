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

- Initial folder structure if `--webpack` is enabled
- Working rspec examples
- Essential gems

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

- Essential packages
  - sanitize.css
- Linters
  - Rubocop
  - Eslint
  - Prettier
  - Stylelint

## TODO

- One source for specifying versions (ruby/nodejs/etc) (use `.tool-versions`?)
- Finish post setup of essential gems
- Use `.haml`
- Improve homepage style
- Initial react setup
- Add sample js tests
- Docker setup and instructions
- Circleci config and instructions

## License

MIT
