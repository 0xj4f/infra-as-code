# Dockerfiles

## Reminders

**RUN vs CMD vs ENTRYPOINT**
- **RUN** : executes command in a new layer, creating a new image. commonly used for installing software packages
- **CMD** : sets default command or paramaters that can be overridden when launching a docker container
- **ENTRYPOINT** : configures a container to run as an executable

## GCR Distroless Images

- gcr.io/distroless/static-debian11
- gcr.io/distroless/base-debian11
- gcr.io/distroless/java11-debian11
- gcr.io/distroless/java17-debian11
- gcr.io/distroless/cc-debian11
- gcr.io/distroless/nodejs14-debian11
- gcr.io/distroless/nodejs16-debian11
- gcr.io/distroless/nodejs18-debian11
- gcr.io/distroless/python3

### Building using Docker Multi Stage

Example for go lang build

```
# Start by building the application.
FROM golang:1.18 as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN CGO_ENABLED=0 go build -o /go/bin/app

# Now copy it into our base image.
FROM gcr.io/distroless/static-debian11
COPY --from=build /go/bin/app /
CMD ["/app"]
```

Example for Java Applications
```
FROM openjdk:11-jdk-slim-bullseye AS build-env
COPY . /app/examples
WORKDIR /app
RUN javac examples/*.java
RUN jar cfe main.jar examples.HelloJava examples/*.class 

FROM gcr.io/distroless/java11-debian11
COPY --from=build-env /app /app
WORKDIR /app
CMD ["main.jar"]
```

Example for Python3 Applications
```
FROM python:3-slim AS build-env
COPY . /app
WORKDIR /app

FROM gcr.io/distroless/python3
COPY --from=build-env /app /app
WORKDIR /app
CMD ["hello.py", "/etc"]
```

## REFERENCES
- https://github.com/GoogleContainerTools/distroless/tree/main
