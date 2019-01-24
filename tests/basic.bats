#!/usr/bin/env bats

load '../node_modules/bats-support/load'
load '../node_modules/bats-assert/load'

WORKSPACE=$(mktemp -d)

setup() {
  cd $WORKSPACE

  run rails new appname \
    -m https://raw.githubusercontent.com/dcrtantuco/alpha/master/template.rb
}

teardown() {
  if [ $BATS_TEST_COMPLETED ]; then
    echo "Deleting $WORKSPACE"
    rm -rf $WORKSPACE
  fi
}

@test 'Returns exit 0' {
  assert_success
}

@test 'No webpacker setup' {
  refute [ -e "$WORKSPACE/appname/javascript/packs/application.js" ]
}

@test 'No essential yarn packages' {
  run cat $WORKSPACE/appname/package.json | grep sanitize
  assert_failure
}
