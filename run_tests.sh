#!/bin/sh

# Although it would be possible to just call this directly from the Dockerfile,
# centralizing tests in this file allows both the docker container and the
# CI machine to run the same set of tests for an additional datapoint --
# which gives a better chance of turning up POSIX noncompliance

./node_modules/.bin/bats wait-for.bats
