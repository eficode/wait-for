#!/usr/bin/env bats

@test "google should be immediately found" {
  run ./wait-for google.com:80 -- echo 'success'

  [ "$output" = "success" ]
}

@test "https://duckduckgo.com should be immediately found" {
  run ./wait-for https://duckduckgo.com -- echo 'success'

  [ "$output" = "success" ]
}

@test "nonexistent server should not start command" {
  run ./wait-for -t 1 noserver:9999 -- echo 'success'

  [ "$status" -ne 0 ]
  [ "$output" != "success" ]
}

@test "connection error in HTTP test should not start command" {
  run ./wait-for -t 1 http://google.com:8080 -- echo 'success'

  [ "$status" -ne 0 ]
  [ "$output" != "success" ]
}

@test "not found HTTP status should not start command" {
  run ./wait-for -t 1 http://google.com/ping -- echo 'success'

  [ "$status" -ne 0 ]
  [ "$output" != "success" ]
}
