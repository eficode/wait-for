#!/usr/bin/env bats

@test "google should be immediately found, no output other than our own" {
  run ./wait-for -q google.com:80 -- echo 'success'

  [ "$output" = "success" ]
}

@test "nonexistent server should not start command" {
  run ./wait-for -t 1 noserver:9999 -- echo 'success'

  [ "$status" -ne 0 ]
  [ "$output" != "success" ]
}

@test "nonexistent server should start command if loose option is specified" {
  run ./wait-for -q -t 1 -l noserver:9999 -- echo 'passable' 2>&1

  [ "$status" -eq 0 ]

  [ "$output" = "passable" ]
}

@test "preserve existing environment variables" {
  TIMEOUT=mytimeout
  QUIET=myquiet
  HOST=myhost
  PORT=myport
  LOOSE=myloose

  run ./wait-for google.com:80 -- echo 'success'

  [ "$(echo $TIMEOUT)" = 'mytimeout' ]
  [ "$(echo $QUIET)" = 'myquiet' ]
  [ "$(echo $HOST)" = 'myhost' ]
  [ "$(echo $PORT)" = 'myport' ]
  [ "$(echo $LOOSE)" = 'myloose' ]
}
