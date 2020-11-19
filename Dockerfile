FROM node:14-alpine

RUN apk add --no-cache bash

RUN mkdir -p /app
WORKDIR /app

COPY . /app
RUN npm install

CMD ./node_modules/.bin/bats wait-for.bats
