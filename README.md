# alpha

Setting up a rails project takes at least one day to configure.

This is my attempt to make it as fast as possible.

## Getting Started

### Requirements

- ruby 2.6.0
- nodejs 10.4.0
- rails 5.2
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
- Essential packages
  - sanitize.css
- Linters
  - Rubocop
  - Eslint
  - Prettier
  - Stylelint

## TODO

- Finish rspec gems setup
  - factory_bot_rails
  - database_cleaner
  - faker
  - selenium-webdriver
- Use `.haml`
- Improve homepage style
- Initial react setup
- Add sample js tests
- Docker setup
- Circleci config and instructions
- One source for specifying versions (ruby/nodejs/etc)

## License

MIT
