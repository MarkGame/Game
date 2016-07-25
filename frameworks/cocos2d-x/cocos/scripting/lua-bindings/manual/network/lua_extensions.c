
#include "lua_extensions.h"

#if __cplusplus
extern "C" {
#endif
// socket
#include "luasocket/luasocket.h"
#include "luasocket/luasocket_scripts.h"
#include "luasocket/mime.h"
#include "sproto/lsproto.h"
#include "lpeg/lptree.h"
#include "cjson/lua_cjson.h"
#include "crypt/lua-crypt.h"
static luaL_Reg luax_exts[] = {
    {"socket.core", luaopen_socket_core},
	{ "sproto.core",luaopen_sproto_core },
	{"cjson",luaopen_cjson },
	{"cjson.safe",luaopen_cjson_safe },
	{"lpeg",luaopen_lpeg},
    {"mime.core", luaopen_mime_core},
	{"crypt",luaopen_crypt},
    {NULL, NULL}
};

void luaopen_lua_extensions(lua_State *L)
{
    // load extensions
    luaL_Reg* lib = luax_exts;
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "preload");
    for (; lib->func; lib++)
    {
        lua_pushcfunction(L, lib->func);
        lua_setfield(L, -2, lib->name);
    }
    lua_pop(L, 2);

    luaopen_luasocket_scripts(L);
}

#if __cplusplus
} // extern "C"
#endif
