FROM node:16-alpine@sha256:a9b9cb880fa429b0bea899cd3b1bc081ab7277cc97e6d2dcd84bd9753b2027e1 as test-env

# Install bash
RUN apk add --no-cache bash && mkdir -p /app
WORKDIR /app

# Install all Node dependencies
COPY package.json /app/
COPY package-lock.json /app/
RUN npm ci

# Copy source code
COPY . /app/

# Perform tests
RUN npm run test
CMD npm test

FROM alpine:edge
RUN apk add --no-cache netcat-openbsd wget
ENTRYPOINT ["/wait-for"]
CMD ["--help"]
COPY --from=test-env /app/wait-for /wait-for
