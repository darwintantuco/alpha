require 'fileutils'
require 'shellwords'

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

def add_testing_gems
  gem_group :development, :test do
    gem 'factory_bot_rails'
    gem 'rspec-rails'
  end

  gem_group :test do
    gem 'capybara'
    gem 'database_cleaner'
    gem 'faker'
    gem 'selenium-webdriver'
  end
end

def setup_package_json
  remove_file 'package.json'
  template 'package.json.erb', 'package.json'
end

def add_yarn_linters
  run 'yarn add --dev \
    stylelint \
    stylelint-rscss \
    stylelint-8-point-grid'
end

def copy_linter_files
  copy_file '.stylelintrc', '.stylelintrc'
end

def initial_commit
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end

def setup_homepage_template
  route 'root to: home#index'
  copy_file 'app/controllers/home_controller.rb', 'app/controllers/home_controller.rb'
  copy_file 'app/views/home/index.html.erb', 'app/views/home/index.html.erb'
end

def setup_asdf
  copy_file '.tool-versions', '.tool-versions'
end

def check_ruby_version; end

check_ruby_version
setup_asdf

add_template_repository_to_source_path
add_testing_gems
setup_homepage_template

setup_package_json
add_yarn_linters
copy_linter_files

after_bundle do
  initial_commit
end
