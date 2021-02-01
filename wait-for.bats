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
