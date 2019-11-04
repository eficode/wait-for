## Wait for another service to become available

`./wait-for` is a script designed to synchronize services like docker containers. It is [sh](https://en.wikipedia.org/wiki/Bourne_shell) and [alpine](https://alpinelinux.org/) compatible. It was inspired by [vishnubob/wait-for-it](https://github.com/vishnubob/wait-for-it), but the core has been rewritten at [Eficode](http://eficode.com/) by [dsuni](https://github.com/dsuni) and [mrako](https://github.com/mrako).

When using this tool, you only need to pick the `wait-for` file as part of your project.

[![Build Status](https://travis-ci.org/eficode/wait-for.svg?branch=master)](https://travis-ci.org/eficode/wait-for)

## Usage

```
wait-for host:port [-t timeout] [-- command args]
  -q | --quiet                        Do not output any status messages
  -l | --loose                        Execute subcommand even if the test times out
  -t TIMEOUT | --timeout=timeout      Timeout in seconds, zero for no timeout
  -- COMMAND ARGS                     Execute command with args after the test finishes
```

## Examples

To check if [eficode.com](https://eficode.com) is available:

```
$ ./wait-for www.eficode.com:80 -- echo "Eficode site is up"
Eficode site is up
```

The subcommand will be executed regardless if the service is up or not. If you wish to execute the subcommand only if the service is up, add the --strict argument. In this example, we will test port 81 on www.google.com which will fail:

```
$ ./wait-for www.google.com:81 --timeout=1 -- echo "google is up"
Operation timed out
$ ./wait-for www.google.com:81 --timeout=1 --loose -- echo "waited for google"
Operation timed out
waited for google
```

To wait for database container to become available:


```
version: '2'

services:
  db:
    image: postgres:9.4

  backend:
    build: backend
    command: sh -c './wait-for db:5432 -- npm start'
    depends_on:
      - db
```

## Testing

Ironically testing is done using [bats](https://github.com/sstephenson/bats), which on the other hand is depending on [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)).

    docker build -t wait-for .
    docker run -t wait-for
    
## Note

Make sure netcat is installed in your Dockerfile before running the command.
```
RUN apt-get -q update && apt-get -qy install netcat
```
https://stackoverflow.com/questions/44663180/docker-why-does-wait-for-always-time-out

