-- Use this file to set Lua-specific config/debug options.
-- You can change the path where this file is searched for by using
-- [QUICK] configFileName="path/to/myConfigFile.lua" in your app.icf

config =
{
    debug =
    {
        general = true,       -- Turn on general debugging - dbg.xxx functions are trimmed out if this is false
                              -- If general = false, the three features below are disabled...
        assertDialogs = true, -- Display dialog boxes when asserting - if false, asserts are console messages
        typeChecking = true,  -- Turn on dbg.xxx functions that Quick uses internally to check types in some engine functions
        traceGC = false,      -- Trace info on object garbage collection

        makePrecompiledLua = false, -- Turn on precompilation of lua files
        usePrecompiledLua = false,  -- Turn on use of precompiled lua files
        useConcatenatedLua = false, -- Turn on use of concatenated precompiled lua files
    }
}
