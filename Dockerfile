FROM node:alpine

RUN apk add --no-cache bash

RUN mkdir -p /app
WORKDIR /app

COPY . /app
RUN npm install

# On launch, run the test suite via npm
CMD npm test
