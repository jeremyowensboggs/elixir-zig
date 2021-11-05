const e = @cImport({
    @cInclude("erl_nif.h");
});

pub const Error = error{
    /// Translates to Elixir `FunctionClauseError`.
    ///
    /// This is the default mechanism for reporting that a Zigler nif function has
    /// been incorrectly passed a value from the Elixir BEAM runtime.  This is very
    /// important, as Zig is statically typed.
    ///
    /// support for users to be able to throw this value in their own Zig functions
    /// is forthcoming.
    FunctionClauseError,
};

pub const term = e.ERL_NIF_TERM;

pub const env = ?*e.ErlNifEnv;

export fn add_shim(environment: env, arg_c: c_int, argv: [*c]const term) term {
    if (arg_c != 2) {
        return raise_function_clause_error(environment);
    }
    var a: i32 = get_i32(environment, argv[0]) catch return raise_function_clause_error(environment);
    var b: i32 = get_i32(environment, argv[1]) catch return raise_function_clause_error(environment);

    var result = a + b;

    return make_i32(environment, result);
}

/// Takes a BEAM int term and returns an `i32` value.
///
/// Note that this conversion function does not currently do range checking.
///
/// Raises `beam.Error.FunctionClauseError` if the term is not `t:integer/0`
pub fn get_i32(environment: env, src_term: term) !i32 {
    var result: c_int = undefined;
    if (0 != e.enif_get_int(environment, src_term, &result)) {
        return @intCast(i32, result);
    } else {
        return Error.FunctionClauseError;
    }
}

const f_c_e_slice = "function_clause";
/// This function is used to communicate `:function_clause` back to the BEAM as an
/// exception.
///
/// By default Zigler will do argument input checking on value
/// ingress from the dynamic BEAM runtime to the static Zig runtime.
/// You can also use this function to communicate a similar error by returning the
/// resulting term from your NIF.
pub fn raise_function_clause_error(env_: env) term {
    return e.enif_raise_exception(env_, make_atom(env_, f_c_e_slice));
}

/// converts a Zig char slice (`[]u8`) into a BEAM `t:atom/0`.
pub fn make_atom(environment: env, atom_str: []const u8) term {
    return e.enif_make_atom_len(environment, @ptrCast([*c]const u8, &atom_str[0]), atom_str.len);
}

/// converts an `i32` value into a BEAM `t:integer/0`.
pub fn make_i32(environment: env, val: i32) term {
    return e.enif_make_int(environment, @intCast(c_int, val));
}

export var __exported_nifs__ = [_]e.ErlNifFunc{
    e.ErlNifFunc{
        .name = "add",
        .arity = 2,
        .fptr = add_shim,
        .flags = 0,
    },
};

const entry = e.ErlNifEntry{
    .major = 2,
    .minor = 16,
    .name = "Elixir.ZigNif",
    .num_of_funcs = __exported_nifs__.len,
    .funcs = &(__exported_nifs__[0]),
    .load = blank_load,
    .reload = null, // currently unsupported
    .upgrade = null, // currently unsupported
    .unload = null, // currently unsupported
    .vm_variant = "beam.vanilla",
    .options = 1,
    .sizeof_ErlNifResourceTypeInit = @sizeOf(e.ErlNifResourceTypeInit),
    .min_erts = "erts-12.1.2",
};

export fn nif_init() *const e.ErlNifEntry {
    return &entry;
}

///////////////////////////////////////////////////////////////////////////////
// NIF LOADING Boilerplate

pub export fn blank_load(_a: env, _b: [*c]?*c_void, _c: term) c_int {
    return 0;
}

pub export fn blank_upgrade(_a: env, _b: [*c]?*c_void, _c: [*c]?*c_void, _d: term) c_int {
    return 0;
}
