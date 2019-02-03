require 'fileutils'
require 'shellwords'
require 'pry'

MINIMUM_RUBY_VERSION = '2.6.0'
MINIMUM_RAILS_VERSION = '5.2.0'
MINIMUM_NODE_VERSION = '10.15.1'

def version(version)
  Gem::Version.create(version)
end

def minimum_version_met?(current, expected)
  (version(current) <=> version(expected)) >= 0
end

def node_version
  node = run 'node -v', capture: true
  abort ("Aborted! node > v#{MINIMUM_NODE_VERSION} is required.") unless node
  node.chomp[1..-1]
end

def check_version_requirements
  unless minimum_version_met? RUBY_VERSION, MINIMUM_RUBY_VERSION
    abort("Aborted! Required ruby version >=#{MINIMUM_RUBY_VERSION}.")
  end

  unless minimum_version_met? Rails.version, MINIMUM_RAILS_VERSION
    abort("Aborted! Required rails version >=#{MINIMUM_RAILS_VERSION}.")
  end

  unless minimum_version_met? node_version, MINIMUM_NODE_VERSION
    abort("Aborted! Required node version >=#{MINIMUM_NODE_VERSION}.")
  end
end

# Copied from https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require 'tmpdir'
    source_paths.unshift(tempdir = Dir.mktmpdir('alpha-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      '--quiet',
      'https://github.com/dcrtantuco/alpha.git',
      tempdir
    ].map(&:shellescape).join(' ')

    if (branch = __FILE__[%r{alpha/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def copy_tool_versions
  copy_file '.tool-versions', '.tool-versions'
end

def add_essential_gems
  gem 'hamlit-rails'

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
end

def setup_homepage_template
  # routes
  route "root to: 'home#index'"

  # controllers
  copy_file 'app/controllers/home_controller.rb', 'app/controllers/home_controller.rb'

  # views
  copy_file 'app/views/home/index.html.erb', 'app/views/home/index.html.erb'
end

def generate_tool_versions
  create_file ".tool_versions" do
    <<~EOS
    ruby #{RUBY_VERSION}
    nodejs #{node_version}
    EOS
  end
end

def insert_yarn_scripts
  inject_into_file 'package.json', after: '  "private": true,' do
    <<~EOS.chomp
    \n  "scripts": {
        "lint:ruby": "rubocop --require rubocop-rspec",
        "lint:js": "eslint \\"./app/**/*.{js,jsx}\\"",
        "lint:css": "stylelint \\"./app/**/*.scss\\"",
        "prettier:check": "prettier-eslint --list-different \\"./app/**/*.scss\\" \\"./app/**/*.{js,jsx}\\"",
        "prettier:fix": "prettier-eslint --write \\"./app/**/*.scss\\" \\"./app/**/*.{js,jsx}\\"",
        "lint:ci": "run-s lint:ruby lint:js lint:css prettier:check"
      },
    EOS
  end
end

def add_essential_packages
  run 'yarn add sanitize.css'
end

def setup_react
  run 'yarn add \
    babel-preset-react \
    remount \
    react \
    react-dom'

  inject_into_file '.babelrc',
    after: '"presets": [' do
    <<~EOS.chomp
    \n    "react",
    EOS
  end

  git add: '.'
  git commit: "-a -m 'Add react packages'"
end

def add_linter_packages
  run 'yarn add --dev \
    stylelint \
    stylelint-config-standard \
    stylelint-rscss \
    stylelint-8-point-grid \
    prettier-eslint-cli \
    standard \
    babel-eslint \
    eslint-plugin-flowtype \
    npm-run-all'

  insert_yarn_scripts

  git add: '.'
  git commit: "-a -m 'Add linter packages'"
end

def copy_linter_files
  copy_file '.rubocop.yml', '.rubocop.yml'
  copy_file '.eslintrc', '.eslintrc'
  copy_file '.stylelintrc', '.stylelintrc'
end

def initial_webpack_assets
  # css
  copy_file 'app/javascript/css/application.scss', 'app/javascript/css/application.scss'
  copy_file 'app/javascript/css/vendor.scss', 'app/javascript/css/vendor.scss'
  copy_file 'app/javascript/css/components/home-page.scss', 'app/javascript/css/components/home-page.scss'

  # images
  copy_file 'app/javascript/images/application.js', 'app/javascript/images/application.js'
  copy_file 'app/javascript/images/rails-logo.svg', 'app/javascript/images/rails-logo.svg'

  # js
  copy_file 'app/javascript/js/application.js', 'app/javascript/js/application.js'

  # react
  copy_file 'app/javascript/react/application.js', 'app/javascript/react/application.js'
  copy_file 'app/javascript/react/Greeter.js', 'app/javascript/react/Greeter.js'

  # packs
  inject_into_file 'app/javascript/packs/application.js',
    after: "// layout file, like app/views/layouts/application.html.erb" do
    <<~EOS.chomp
    \nimport "../images/application";

    import "../css/vendor";
    import "../css/application";

    import "../js/application";
    import "../react/application";
    EOS
  end

  # add pack tags in application layout
  inject_into_file 'app/views/layouts/application.html.erb',
    after: "<%= stylesheet_link_tag    'application', media: 'all' %>" do
    <<~EOS.chomp
    \n    <%= javascript_pack_tag 'application' %>
        <%= stylesheet_pack_tag 'application' %>
    EOS
  end

  # render sample icon
  inject_into_file 'app/views/home/index.html.erb', after: '<div class="home-page">' do
    <<~EOS.chomp
    \n  <%= image_tag asset_pack_path('images/rails-logo.svg'), class: 'logo' %>
    EOS
  end

  # render greeter component
  inject_into_file 'app/views/home/index.html.erb', after: '</div>' do
    <<~EOS.chomp
    \n<x-greeter props-json='{"name":"Lodi"}'></x-greeter>
    EOS
  end

  git add: '.'
  git commit: "-a -m 'Initial webpack assets'"
end

def add_rspec_examples
  # models
  copy_file 'spec/models/.keep', 'spec/models/.keep'

  # controllers
  copy_file 'spec/controllers/home_controller_spec.rb', 'spec/controllers/home_controller_spec.rb'

  # features
  copy_file 'spec/features/visitor_sees_homepage_spec.rb', 'spec/features/visitor_sees_homepage_spec.rb'
end

def config_headless_chrome
  inject_into_file 'spec/rails_helper', after: '# config.filter_gems_from_backtrace("gem name")' do
    <<~EOS.chomp
    \nCapybara.register_driver :selenium do |app|
        Capybara::Selenium::Driver.new(app, browser: :chrome)
      end

      Capybara.javascript_driver = :selenium_chrome_headless
    EOS
  end
end

def initial_commit
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end

def rspec_test_suite
  # fixes intermittent failures in rspec generator
  run 'bundle exec spring stop'
  run 'bundle exec spring binstub --all'
  run 'bundle exec rails generate rspec:install'

  add_rspec_examples
  config_headless_chrome

  git add: '.'
  git commit: "-a -m 'Setup rspec test suite'"
end

def generate_rubocop_todo
  run 'rubocop --auto-gen-config'
  git add: '.'
  git commit: "-a -m 'Generate .rubocop_todo.yml'"
end

def initial_lint_fixes
  # disable eslint for this file, it requires js through rails magic
  file = 'app/assets/javascripts/cable.js'
  if File.file?(file)
    inject_into_file file, after: "//= require_tree ./channels\n" do
      "\n/* eslint-disable */\n"
    end
  end
  run 'yarn run prettier:fix'

  git add: '.'
  git commit: "-a -m 'Initial lint fixes'"
end

check_version_requirements
add_template_repository_to_source_path

add_essential_gems
setup_homepage_template
initial_commit

generate_tool_versions if args.include? '--asdf'

add_essential_packages if options['webpack']
add_linter_packages
copy_linter_files

after_bundle do
  run 'bundle exec rails db:create'
  run 'bundle exec rails db:migrate'

  if options['webpack']
    run 'bundle exec rails webpacker:install'

    git add: '.'
    git commit: "-a -m 'Execute rails webpacker:install'"

    initial_webpack_assets
    setup_react
  end

  rspec_test_suite
  generate_rubocop_todo
  initial_lint_fixes
end
