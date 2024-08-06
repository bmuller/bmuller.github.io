---
redirect_to: https://bmuller.wtf/blog/2019-02-22-smaller-elixir-docker-images
layout: post
title: "Smaller Elixir Docker Images"
date: 2019-02-22 21:00
categories: [elixir, docker]
---
When running [Elixir](https://elixir-lang.org) in production, I was surprised how large the [Docker](https://www.docker.com/) images were and how long they took to build.  In an effort to keep those images smaller, and reduce the build time for those images, I spent a while testing different options.  The solution I came up with seems obvious in retrospect - but took a long while to test all the different options.  I've made liberal use of [multi-stage](https://docs.docker.com/develop/develop-images/multistage-build/) builds, which allow you to pull artifacts from intermediary images into later stages.  The final image can then be significantly smaller.  These steps assume you're using [Distillery](https://hexdocs.pm/distillery/introduction/installation.html) for packaging your Elixir application for deployment using [OTP releases](http://erlang.org/doc/design_principles/release_structure.html).

I'll go through all of the three stages in order below, each `Dockerfile` snippet is a part of a single file that I put together in the last section.

## Dependency Stage
The first stage (which I name `base`) just consists of adding the mix file and lock, fetching dependencies, and building them.  This will happen irrespective of your application files, meaning your app files can be updated and this stage will remain the same.  Changing your dependencies list in `mix.exs` will result in this whole stage being rebuilt, but hopefully that's not something that happens frequently.  In my experience, building the dependencies was the primary cause for how long it took to build new images, so I wanted this time penalty to be rare.

Here's the first part that just builds the deps into a `base` intermediate image:

```dockerfile
# First, download and compile all dependencies in an intermediate base image
FROM elixir:1.8.1-alpine as base
# Your dependencies for the OS may differ
RUN apk update && apk --no-cache add --virtual builds-deps build-base libressl libressl-dev
WORKDIR /app
ADD mix.exs .
ADD mix.lock .
ENV MIX_ENV prod
RUN mix local.rebar --force
RUN mix local.hex --if-missing --force
RUN mix deps.get --only prod
RUN mix deps.compile
```

## Release Build
The next stage builds the actual release using [Distillery](https://hexdocs.pm/distillery/introduction/installation.html).  It compiles your application code, creates a release, and then ungzip's the release package into a folder to be picked up by the subsequent stage.  For the smallest image, you should include the [Erlang Runtime System](https://github.com/bitwalker/distillery/blob/master/docs/introduction/terminology.md) via Distillery (instead of using a docker image that includes the Erlang VM).  Based on testing, this option can help reduce the size of the final image significantly.  Just make sure your `rel/config.exs` has the following options:

```elixir
environment :prod do
  set include_erts: true
  set include_src: false
  ...
end
```

Here's the next section in the `Dockerfile` to build the release and ungzip it into a folder for pickup in the next stage:

```dockerfile
# Now build a release from our app files
FROM elixir:1.8.1-alpine as intermediate
COPY --from=base /app /app
ENV MIX_ENV prod
RUN mix local.hex --if-missing --force
WORKDIR /app
ADD . .
RUN mix compile
RUN mix release
WORKDIR /release
# replace 'my_app' below with your application name, and possibly your app version
RUN tar -zxf /app/_build/prod/rel/my_app/releases/0.1.0/my_app.tar.gz -C /release
```

## Release Artifact
The last step just copies the release to a base alpine image to run, and then runs the result in the foreground.

```dockerfile
# now run the release.  Make sure the alpine version below matches the alpine version
# included by erlang included by elixir:1.8-alpine
FROM alpine:3.9
RUN apk update && apk add --no-cache bash openssl
ENV MIX_ENV prod
ENV LANG C.UTF-8
COPY --from=intermediate /release /app
EXPOSE 4001
CMD ["/app/bin/my_app", "foreground"]
```

## Putting It All Together
And here's the final `Dockerfile` with all of the parts in order.  My final release is ~50M, which is significantly smaller than the ~200MB when not using intermediate stages.

```dockerfile
# First, download and compile all dependencies in an intermediate base image
FROM elixir:1.8.1-alpine as base
# Your dependencies for the OS may differ
RUN apk update && apk --no-cache add --virtual builds-deps build-base libressl libressl-dev
WORKDIR /app
ADD mix.exs .
ADD mix.lock .
ENV MIX_ENV prod
RUN mix local.rebar --force
RUN mix local.hex --if-missing --force
RUN mix deps.get --only prod
RUN mix deps.compile

# Now build a release from our app files
FROM elixir:1.8.1-alpine as intermediate
COPY --from=base /app /app
ENV MIX_ENV prod
RUN mix local.hex --if-missing --force
WORKDIR /app
ADD . .
RUN mix compile
RUN mix release
WORKDIR /release
# replace 'my_app' below with your application name, and possibly your app version
RUN tar -zxf /app/_build/prod/rel/my_app/releases/0.1.0/my_app.tar.gz -C /release

# now run the release.  Make sure the alpine version below matches the alpine version
# included by erlang included by elixir:1.8-alpine
FROM alpine:3.9
RUN apk update && apk add --no-cache bash openssl
ENV MIX_ENV prod
ENV LANG C.UTF-8
COPY --from=intermediate /release /app
EXPOSE 4001
CMD ["/app/bin/my_app", "foreground"]
```
