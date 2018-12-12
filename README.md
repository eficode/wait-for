## Wait for another service to become available

`./wait-for` is a script designed to synchronize services like docker containers. It is [sh](https://en.wikipedia.org/wiki/Bourne_shell) and [alpine](https://alpinelinux.org/) compatible. It was inspired by [vishnubob/wait-for-it](https://github.com/vishnubob/wait-for-it), but the core has been rewritten at [Eficode](http://eficode.com/) by [dsuni](https://github.com/dsuni) and [mrako](https://github.com/mrako).

When using this tool, you only need to pick the `wait-for` file as part of your project.

[![Build Status](https://travis-ci.org/eficode/wait-for.svg?branch=master)](https://travis-ci.org/eficode/wait-for)

## Usage

```
./wait-for host:port [host:port...] [-t timeout] [-- command args]
  -q | --quiet                        Do not output any status messages
  -t TIMEOUT | --timeout=timeout      Timeout in seconds, zero for no timeout
  -- COMMAND ARGS                     Execute command with args after the test finishes
```

## Examples

To check if [eficode.com](https://eficode.com) is available:

```
$ ./wait-for www.eficode.com:80 -- echo "Eficode site is up"

Connection to www.eficode.com port 80 [tcp/http] succeeded!
Eficode site is up
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

To wait for several containers to become available:

```
version: '2'

services:
  db:
    image: postgres:9.4

  elk:
    image: sebp/elk

  backend:
    build: backend
    command: sh -c './wait-for db:5432 elk:9563 -- npm start'
    depends_on:
      - db
      - elk
```

## Testing

Ironically testing is done using [bats](https://github.com/sstephenson/bats), which on the other hand is depending on [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)).

    docker build -t wait-for .
    docker run -t wait-for
