#!/usr/bin/env bats

load '../node_modules/bats-support/load'
load '../node_modules/bats-assert/load'

WORKSPACE=$(mktemp -d)

setup() {
  cd $WORKSPACE

  run rails new appname \
    --database=postgresql \
    --skip-test \
    --skip-sprockets \
    --skip-turbolinks \
    --skip-coffee \
    --skip-javascript \
    --webpack \
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

@test 'Webpacker setup for --webpack' {
  assert [ -e "$WORKSPACE/appname/javascript/packs/application.js" ]
}

@test 'Yarn scripts' {
  cat $WORKSPACE/appname/package.json | grep scripts
}
