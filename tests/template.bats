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
  # exit 0
  rails new appname \
    --database=postgresql \
    -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb

  # no webpacker setup
  refute [ -e "$WORKSPACE/appname/app/javascript/packs/application.js" ]

  # no asdf
  refute [ -e "$WORKSPACE/appname/.tool-versions" ]

  # no essential yarn packages
  run bash -c "cat $WORKSPACE/appname/package.json | grep sanitize"
  assert_failure

  cd appname

  # rspec passes
  run rspec
  assert_success
}

@test 'Recommended Usage' {
  # exit 0
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

  cd appname

  # rspec passes
  run rspec
  assert_success

  # linter works
  run yarn run lint:ci
  assert_success

  # jest works
  run yarn run test
  assert_success

  # output rails app has no uncommitted changes
  run git status
  assert_output --partial 'nothing to commit'
}
