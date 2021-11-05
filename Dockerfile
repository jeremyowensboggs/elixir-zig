FROM elixir:latest

RUN apt-get update && \
  mix local.hex --force && \
  mix local.rebar --force

RUN curl -o zig-linux-x86_64-0.8.1.tar.xz https://ziglang.org/download/0.8.1/zig-linux-x86_64-0.8.1.tar.xz && \
  tar -xvf zig-linux-x86_64-0.8.1.tar.xz


ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
