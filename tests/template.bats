#!/usr/bin/env bats

load '../node_modules/bats-support/load'
load '../node_modules/bats-assert/load'

WORKSPACE=$(mktemp -d)

setup() {
  cd $WORKSPACE
}

teardown() {
  if [ $BATS_TEST_COMPLETED ]; then
    echo "Deleting $WORKSPACE"
    rm -rf $WORKSPACE
  fi
}

@test 'Basic Usage' {
  rails new appname \
    -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb

  # no webpacker setup
  refute [ -e "$WORKSPACE/appname/app/javascript/packs/application.js" ]

  # no asdf
  refute [ -e "$WORKSPACE/appname/.tool-versions" ]

  # no essential yarn packages
  run bash -c "cat $WORKSPACE/appname/package.json | grep sanitize"
  assert_failure

  # rspec passes
  run rspec
  assert_success
}

@test 'Recommended Usage' {
  rails new appname \
    --database=postgresql \
    --skip-test \
    --skip-turbolinks \
    --skip-coffee \
    --asdf \
    --webpack \
    -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb

  # webpacker setup
  assert [ -e "$WORKSPACE/appname/app/javascript/packs/application.js" ]

  # asdf
  assert [ -e "$WORKSPACE/appname/.tool-versions" ]

  # essential yarn packages
  run bash -c "cat $WORKSPACE/appname/package.json | grep sanitize"
  assert_success

  # rspec passes
  run rspec
  assert_success
}
