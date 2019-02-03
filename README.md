# alpha

[![Build Status](https://travis-ci.org/dcrtantuco/alpha.svg?branch=master)](https://travis-ci.org/dcrtantuco/alpha)

Setting up a rails project takes at least one day to configure. This is my attempt to make it as fast as possible.

All files generated by rails are preserved.

Changes are made by injecting code snippets to generated files.

## tl;dr

- Webpacker Setup with React
- Essential yarn packages
- [hamlit](https://github.com/k0kubun/hamlit) as templating language
- Rspec Test Suite
- Preconfigured Linters
- Yarn scripts

## Getting Started

### Requirements

- ruby >= 2.6.0
- rails >= 5.2
- nodejs >= 10.15.1
- yarn

### Optional

- asdf

### Basic Usage

```
rails new appname \
  -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb
```

### Recommended Usage

```
rails new appname \
  --database=postgresql \
  --skip-test \
  --skip-turbolinks \
  --skip-coffee \
  --asdf \
  --webpack \
  -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb
```

#### Custom Flags

|  Flag  |        Description         |
| :----: | :------------------------: |
| --asdf | generates `.tool_versions` |

### Webpacker Setup

#### Folder Structure

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
│   ├── packs
│   │   └── application.js
│   └── react
│       ├── application.js
│       └── Greeter.js
├── jobs
└── mailers
```

### React

Added packages:

- react
- react-dom
- babel-preset-react
- remount

Working greeter component using remount

### Essential packages

- [sanitize.css](https://github.com/csstools/sanitize.css) as css resets

### Rspec Test Suite

- Preconfigured with rspec and other gems useful in testing.
- Working rspec examples with js

|           Gem            |             Description             |
| :----------------------: | :---------------------------------: |
|       rspec-rails        |       rspec wrapper for rails       |
|    factory_bot_rails     |              fixtures               |
| rails-controller-testing | helper for rspec controller testing |
|         capybara         |     testing users' interaction      |
|    selenium-webdriver    | default driver for javascript tests |
|   chromedriver-helper    |          use chromedriver           |
|     database_cleaner     |  ensure a clean state for testing   |
|          faker           |         generate fake data          |
|      rubocop-rspec       |       rspec-specific analysis       |

### Preconfigured Linters

Comes with initial config, can be updated to your preference!

#### Rubocop

Added gems:

- rubocop
- rubocop-rspec

Initial `rubocop_todo.yml` is generated.

```
# .rubocop.yml
inherit_from: .rubocop_todo.yml
require: rubocop-rspec

Style/FrozenStringLiteralComment:
  EnforcedStyle: never

Style/StringLiterals:
  EnforcedStyle: double_quotes

Style/HashSyntax:
  EnforcedStyle: ruby19

Layout/IndentationConsistency:
  EnforcedStyle: rails

Layout/CaseIndentation:
  EnforcedStyle: end

Layout/BlockAlignment:
  Enabled: false

Layout/EndAlignment:
  EnforcedStyleAlignWith: start_of_line

AllCops:
  Exclude:
    - 'vendor/**/*'
    - 'node_modules/**/*'
    - 'db/migrate/*'
    - 'db/schema.rb'
    - 'db/seeds.rb'
    - 'bin/*'
  TargetRubyVersion: 2.6.0
```

#### Eslint

Added packages:

- babel-eslint
- eslint-plugin-flowtype

```
# .eslintrc
{
  "extends": [
    "standard",
    "standard-jsx"
  ],
  "parser": "babel-eslint",
  "plugins": [
    "flowtype"
  ]
}
```

#### Prettier

Added packages:

- prettier-eslint-cli

#### Stylelint

Added packages:

- stylelint
- stylelint-8-point-grid
- stylelint-config-standard
- stylelint-rscss

```
# .stylelintrc
{
  "extends": [
    "stylelint-config-standard",
    "stylelint-rscss/config",
    "stylelint-8-point-grid"
  ],
  rules: {
    "plugin/8-point-grid": {
      "base": 8,
      "whitelist": ["4px", "2px", "1px"]
    }
  }
}
```

### Yarn Scripts

|         Command         |               Description                |
| :---------------------: | :--------------------------------------: |
|   yarn run lint:ruby    |                 rubocop                  |
|    yarn run lint:js     |                  eslint                  |
|    yarn run lint:css    |                stylelint                 |
| yarn run prettier:check |             prettier-eslint              |
|  yarn run prettier:fix  |             prettier-eslint              |
|    yarn run lint:ci     | rubocop eslint stylelint prettier-eslint |

## Post Install Guide

### Convert existing erb files to haml

1. Install html2haml

   ```
   $ gem install html2haml
   ```

1. Convert erb files to haml (keeps original file)

   ```
   $ find . -name \*.erb -print | sed 'p;s/.erb$/.haml/' | xargs -n2 html2haml
   ```

1. Delete existing erb files

   ```
   $ find . -name \*.erb | xargs git rm
   ```

1. Commit the changes.
1. Uninstall

   ```
   $ gem uninstall html2haml
   ```

## License

MIT
