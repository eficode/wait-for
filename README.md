<br />
<h1 align="center">wait-for</h3>

<p align="center">

  <p align="center">
     Wait for another service to become available
  <br/>
  
  <a href="https://github.com/Eficode/wait-for/graphs/contributors">
  <img src="https://img.shields.io/github/contributors/Eficode/wait-for.svg?style=flat-square">
  </a>
  <a href="https://github.com/Eficode/wait-for/network/members">
  <img src="https://img.shields.io/github/forks/Eficode/wait-for.svg?style=flat-square">
  </a>
  <a href="https://github.com/Eficode/wait-for/stargazers">
  <img src="https://img.shields.io/github/stars/Eficode/wait-for.svg?style=flat-square">
  </a>
  <a href="https://github.com/Eficode/wait-for/blob/master/LICENSE.txt">
  <img src="https://img.shields.io/github/license/Eficode/wait-for.svg?style=flat-square">
  </a> 
  <a href="https://github.com/Eficode/wait-for/actions">
  <img src="https://img.shields.io/github/workflow/status/Eficode/wait-for/Test?style=flat-square&logo=github%20actions">
  </a> 
  <a href="https://github.com/Eficode/wait-for/releases">
  <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/Eficode/wait-for?style=flat-square">
  </a>
  <br/>
  <a href="https://github.com/eficode/wait-for#examples"><strong>Example usage</strong></a>
  ·
  <a href="https://github.com/Eficode/wait-for/pulls">Submit a PR</a>
  </p>
</p>

`./wait-for` is a script designed to synchronize services like docker containers. It is [sh](https://en.wikipedia.org/wiki/Bourne_shell) and [alpine](https://alpinelinux.org/) compatible. It was inspired by [vishnubob/wait-for-it](https://github.com/vishnubob/wait-for-it), but the core has been rewritten at [Eficode](http://eficode.com/) by [dsuni](https://github.com/dsuni) and [mrako](https://github.com/mrako).

When using this tool, you only need to pick the `wait-for` file as part of your project.

## Usage

Download the `wait-for` file, either the latest from [`master`](https://raw.githubusercontent.com/eficode/wait-for/master/wait-for) or for a specific version check out the [Releases](https://github.com/eficode/wait-for/releases)-page.

With the file locally on your file system, you can directly invoke it.

```
./wait-for host:port|url [-t timeout] [-- command args]
  -q | --quiet                        Do not output any status messages
  -t TIMEOUT | --timeout=timeout      Timeout in seconds, zero for no timeout
  -- COMMAND ARGS                     Execute command with args after the test finishes
```

Alternatively, you could download the script and pipe it into `sh`:

```sh
$ wget -qO- https://raw.githubusercontent.com/eficode/wait-for/v2.1.0/wait-for | sh -s -- google.com:80 -- echo success
```

_Note: When using the latter option, make sure to pin the version. Future releases could introduce non-backwards compatible changes._

## Examples

To check if [www.eficode.com](https://www.eficode.com) is available:

```
$ ./wait-for www.eficode.com:80 -- echo "Eficode site is up"
Eficode site is up
```

To wait for database container to become available:


```yml
version: '3'

services:
  db:
    image: postgres:9.4

  backend:
    build: backend
    command: sh -c './wait-for db:5432 -- npm start'
    depends_on:
      - db
```

To check if [https://www.eficode.com](https://www.eficode.com) is available over HTTPS:
```
$ ./wait-for https://www.eficode.com -- echo "Eficode is accessible over HTTPS"
Eficode is accessible over HTTPS
```

To wait for your API service to become available:


```yml
version: '3'

services:
  api:
    image: nginx

  tests:
    build: .
    command: sh -c './wait-for http://api -- echo "The api is up! Let's use it"'
    depends_on:
      - api

```

## Testing

Ironically testing is done using [bats](https://github.com/sstephenson/bats), which on the other hand is depending on [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)).

    docker build -t wait-for .
    docker run --rm -t wait-for
    
## Contributing

When creating PRs, please style your commit messages according to [conventional commit](https://www.conventionalcommits.org/en/v1.0.0/), you can use a tool like [commitizen](https://github.com/commitizen/cz-cli) to guide you. We will automatically infer the changelog from your commits. Alternatively, we can squash all commits when merging and update the commit message.

This project strongly prefers maintaining backwards compatibility, therefore some obvious "fixes" might not be accepted.

Also, please include or update the test cases whenever possible by extending `wait-for.bats`. 
    
## Note

Make sure netcat is installed in your Dockerfile before running the command if you test over plain TCP.
```
RUN apt-get -q update && apt-get -qy install netcat
```
https://stackoverflow.com/questions/44663180/docker-why-does-wait-for-always-time-out

If you are connecting over HTTP, then you will need to have wget available.
 