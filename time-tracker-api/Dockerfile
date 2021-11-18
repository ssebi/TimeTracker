FROM golang:alpine AS build
RUN apk update && \
  apk add curl \
  git \
  bash \
  make \
  ca-certificates && \
  rm -rf /var/cache/apk/*
WORKDIR /app
COPY go.* ./
RUN go mod download
RUN go mod verify
COPY . .
RUN make build

FROM alpine:latest as production
RUN apk --no-cache add ca-certificates bash
RUN mkdir -p /var/log/app
WORKDIR /app/
COPY --from=build /app/server .
COPY .env.production .env
ENV GIN_MODE=release
ENV ENV=production
RUN ls -la
EXPOSE 3000
ENTRYPOINT ["./time-tracker"]
