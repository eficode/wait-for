FROM node:alpine as test-env

RUN apk add --no-cache bash

RUN mkdir -p /app
WORKDIR /app
COPY . /app

RUN npm install
RUN npm run test


FROM alpine:edge
RUN apk add --no-cache curl
COPY --from=test-env /app/wait-for /wait-for
ENTRYPOINT ["/wait-for"]
CMD ["--help"]
