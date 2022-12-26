#################
#  Base layer   #
#################
FROM alpine:edge as runtime-base

# Install all dependencies
RUN apk add --no-cache bash nmap-ncat wget

WORKDIR /app

#################
#  Test image   #
#################
FROM runtime-base as test-env

# Install Node.js
RUN apk add --no-cache nodejs npm

# Install all Node dependencies
COPY package.json /app/
COPY package-lock.json /app/
RUN npm ci

# Copy source code
COPY . /app/

# Perform tests when running this test-env container
CMD npm test

#################
# Runtime image #
#################
FROM runtime-base as runtime

COPY ./wait-for .

ENTRYPOINT ["./wait-for"]
CMD ["--help"]
