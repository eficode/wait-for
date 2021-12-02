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

@test "wget timeout does not double" {
  timeout=10
  cat >delay <<-EOF
	#!/usr/bin/env bash
	sleep $((timeout + 1))
	EOF
  chmod +x delay
  nc -lk -p 80 -e $(pwd)/delay & ncpid=$!
  start_time=$(date +%s)
  run ./wait-for -t ${timeout} http://localhost/
  end_time=$(date +%s)
  kill $ncpid
  rm -f delay

  [ "$status" != 0 ]
  [ "$output" = "Operation timed out" ]
  elapsed=$((end_time - start_time))
  [ ${elapsed} -ge ${timeout} ]
  limit=$((timeout * 3 / 2))
  [ ${elapsed} -lt ${limit} ]
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

@test "--version option returns same version as in package.json" {
  expected="$(node -p "require('./package.json').version")"
  output="$(./wait-for --version)"

  [ "$output" = "$expected" ]
}

@test "--version option returns 0 status code" {
   run ./wait-for --version

  [ "$status" -eq 0 ]
}

@test "--version response matches shorthand -v" {
  long_form="$(./wait-for --version)"
  short_form="$(./wait-for -v)"

  [ "$long_form" = "$short_form" ]
}
