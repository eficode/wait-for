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

@test "support version option" {
  run ./wait-for -v

  [ "$output" = "2.1.3" ]
}

@test "support condensed option style" {
  run ./wait-for -qt1 google.com:80 -- echo 'success'

  [ "$output" = "success" ]
}

@test "timeout cannot be negative" {
  run ./wait-for -t -1 google.com:80 -- echo 'success'

  [ "$status" -ne 0 ]
  [ "$output" != "success" ]
}

@test "timeout cannot be empty" {
  run ./wait-for -t -- google.com:80 -- echo 'success'

  [ "$status" -ne 0 ]
  [ "$output" != "success" ]
}

@test "environment variable HOST should be restored for command invocation" {
  HOST=success run ./wait-for -t 1 google.com:80 -- sh -c 'echo "$HOST"'

  [ "$output" = "success" ]
}

@test "unset environment variable HOST should be restored as unset for command invocation" {
  run ./wait-for -t 1 google.com:80 -- sh -uc 'echo "$HOST"'

  [ "$status" -ne 0 ]
  [ "$output" != "google.com" ]
}

@test "environment variable PROTOCOL should be restored for command invocation" {
  PROTOCOL=success run ./wait-for -t 1 google.com:80 -- sh -c 'echo "$PROTOCOL"'

  [ "$output" = "success" ]
}

@test "unset environment variables PROTOCOL should be restored as unset for command invocation" {
  run ./wait-for -t 1 google.com:80 -- sh -uc 'echo "$PROTOCOL"'

  [ "$status" -ne 0 ]
  [ "$output" != "google.com" ]
}

@test "http://duckduckgo.com should be immediately found" {
  run ./wait-for http://duckduckgo.com -- echo 'success'

  [ "$output" = "success" ]
}

@test "https://duckduckgo.com should be immediately found" {
  run ./wait-for https://duckduckgo.com -- echo 'success'

  [ "$output" = "success" ]
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
