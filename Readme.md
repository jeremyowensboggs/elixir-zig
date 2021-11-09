# Elixir Zig Example for macos/linux in Docker

This repo demonstrates a working zig NIF.  Currently, the nif only works on Linux.  This project
demonstrates that by using a Docker container.  When run through the docker container, the nifs load
and work, but when they are run in **macos**, they do not.

The expectation is that this project is on a macos, with Docker, elixir and zig already installed.

## The nifs
There are 2 nifs in this example project. A nif written in C I used to help make sure I understood how a nif should work,
and a zig nif to show how a zig nif will work.  The C nif is at `./src/lib/c_src` and the zig nif is at `./src/lib/zig_src`.

The nifs are compiled when elixir is compiled using the `elixir_make` package, and the Makefile at `./src/Makefile`.  The `elixir_make` package provides the needed environment variables to locate the erlang headers.  The nifs will be compiled when the elixir source is compiled.

When run through docker, both the C and zig nifs compile and work, but when run in macos, the zig nif refuses to load with an error
## Docker instructions
```
$> docker-compose build 
....
<docker build output>
...
$> docker-compose run --rm elixir-linux mix deps.get
$> docker-compose run --rm elixir-linux mix test
..

Finished in 0.08 seconds (0.00s async, 0.08s sync)
2 tests, 0 failures
```

The tests are in the `./src/tests/ directory, and demonstrate that the nifs load and perform as expected.

## macosx instructions
To run on macos, just cd to the `./src` directory, and
```
$> mix deps.get
$> mix test
...
08:23:11.239 [warn]  The on_load function for module Elixir.ZigNif returned:
{:error,
 {:load_failed,
  'Failed to load NIF library: \'dlopen(./priv/libElixir.ZigNif.so, 2): Symbol not found: __tlv_bootstrap\n  Referenced from: ./priv/libElixir.ZigNif.so (which was built for Mac OS X 11.6)\n  Expected in: ./priv/libElixir.ZigNif.so\n in ./priv/libElixir.ZigNif.so\''}}



  1) test add works (ZigNifTest)
     test/zig_nif_test.exs:4
     ** (UndefinedFunctionError) function ZigNif.add/2 is undefined (module ZigNif is not available)
     code: assert ZigNif.add(1, 2) == 3
     stacktrace:
       (zig_nif 0.1.0) ZigNif.add(1, 2)
       test/zig_nif_test.exs:5: (test)

.

Finished in 0.02 seconds (0.00s async, 0.02s sync)
2 tests, 1 failure
```
The test demonstrates that the c nif runs, but the zig nif doesn't load.
