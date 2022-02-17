CFLAGS = -g -Wall  -shared
SOURCE_FILES = lib/c_src/fast_compare.c

OBJECT_FILES = $(SOURCE_FILES:.c=.o)

ZIG_SOURCE_FILES = lib/zig_src/add_9.zig
LIBS = -lc
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
	ZIG = /zig-linux-x86_64-0.9.1/zig
	OS = linux
	MV = mv ./libElixir.ZigNif.so ./priv/libElixir.ZigNif.so
	CFLAGS += -Wno-unused-function
endif
ifeq ($(UNAME_S),Darwin)
	ZIG = zig
	OS = macos
	MV = mv ./libElixir.ZigNif.dylib ./priv/libElixir.ZigNif.so
	C_LD_FLAGS = -dynamiclib -undefined dynamic_lookup 
endif

compile:
	@echo Building for $(UNAME_S)
	$(CC) $(CFLAGS) -I $(ERTS_INCLUDE_DIR) $(SOURCE_FILES) -o $@ $(C_LD_FLAGS) -o ./priv/fast_compare.so 
	$(ZIG) build-lib $(ZIG_SOURCE_FILES) -I $(ERTS_INCLUDE_DIR) -L$(ERL_INTERFACE_LIB_DIR) $(LIBS) -dynamic -fallow-shlib-undefined --name Elixir.ZigNif
	$(MV)
