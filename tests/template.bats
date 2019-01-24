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
  run rails new appname \
    -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb

  assert_success

  # no webpacker setup
  refute [ -e "$WORKSPACE/appname/javascript/packs/application.js" ]

  # no essential yarn packages
  run bash -c "cat $WORKSPACE/appname/package.json | grep sanitize"
  assert_failure
}

@test 'Recommended Usage' {
  run rails new appname \
    --database=postgresql \
    --skip-test \
    --skip-sprockets \
    --skip-turbolinks \
    --skip-coffee \
    --skip-javascript \
    --webpack \
    -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb

  assert_success

  # webpacker setup
  assert [ -e "$WORKSPACE/appname/javascript/packs/application.js" ]

  # essential yarn packages
  run bash -c "cat $WORKSPACE/appname/package.json | grep sanitize"
  assert_success
}
