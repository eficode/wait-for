#!/usr/bin/env bats

@test "google should be immediately found" {
  run ./wait-for google.com:80 -- echo 'success'

  [ "$output" = "success" ]
}

@test "nonexistent server should not start command" {
  run ./wait-for -t 1 noserver:9999 -- echo 'success'

  [ "$status" -ne 0 ]
  [ "$output" != "success" ]
}

@test "preserve existing environment variable" {
  HOST=myweb.com
  PORT=8080
  run ./wait-for google.com:80 -- echo 'success'

  [ "$(echo $HOST)" = 'myweb.com' ]
  [ "$(echo $PORT)" = '8080' ]
}
