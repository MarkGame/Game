#ifndef _SDP_LUA_H_
#define _SDP_LUA_H_

extern "C" {
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
}
#include "cocos2d.h"
#include <iostream>
#include <stdlib.h>
#include "Sdp.h"
using namespace std;
using namespace mfw;

enum SdpTypeId
{
	SdpType_Void, // 0
	SdpType_Bool, // 1
	SdpType_Char, // 2
	SdpType_Int8, // 3
	SdpType_UInt8, // 4
	SdpType_Int16, // 5
	SdpType_UInt16, // 6
	SdpType_Int32, // 7
	SdpType_UInt32, // 8
	SdpType_Int64, // 9
	SdpType_UInt64, // 10
	SdpType_Float, // 11
	SdpType_Double, // 12
	SdpType_String, // 13
	SdpType_Vector, // 14
	SdpType_Map, // 15
	SdpType_Enum, // 16
	SdpType_Struct, // 17
};

struct LuaStackPoper
{
	lua_State *L;
	int iPopNum;

	explicit LuaStackPoper(lua_State *LL, int num = 0) : L(LL), iPopNum(num) {}
	~LuaStackPoper() { if (iPopNum > 0) lua_pop(L, iPopNum); }

	void push(int num) { iPopNum += num; }
	void pop(int num) { lua_pop(L, num); iPopNum -= num; }
};

class LuaSdpValue
{
public:
	LuaSdpValue(lua_State *LL, int iValStack, int iTypeStack);

protected:
	lua_State *L;
	int m_iValStack;
	int m_iTypeStack;
	uint32_t m_iType;
};

class LuaSdpValueWriter : public LuaSdpValue
{
public:
	LuaSdpValueWriter(lua_State *LL, int iValStack, int iTypeStack, int iDefaultStack = 0);

	template <typename Writer>
	void visit(Writer &writer, uint32_t tag, bool require, const char *name) const;

private:
	int m_iDefaultStack;
};

class LuaSdpValueReader : public LuaSdpValue
{
public:
	LuaSdpValueReader(lua_State *LL, int iValStack, int iTypeStack);

	template <typename Reader>
	void visit(Reader &reader, uint32_t tag, bool require, const char *name);

	bool hasNewValue() const { return m_bHasNewValue; }

private:
	bool m_bHasNewValue;
};

class LuaSdpStruct
{
public:
	LuaSdpStruct() : L(NULL), m_iStructStack(0), m_iStructTypeStack(0) {}
	LuaSdpStruct(lua_State *LL, int iStructStack, int iStructTypeStack);

	template <typename T, bool IsWrite>
	void visit(T &t, bool bOpt) const;

protected:
	lua_State *L;
	int		m_iStructStack;
	int		m_iStructTypeStack;
};

class LuaSdpStructWriter : public LuaSdpStruct
{
public:
	LuaSdpStructWriter() {}
	LuaSdpStructWriter(lua_State *LL, int iStructStack, int iStructTypeStack);

	template <typename Writer>
	void visit(Writer &t, bool bOpt) const;
};

class LuaSdpStructReader : public LuaSdpStruct
{
public:
	LuaSdpStructReader() {}
	LuaSdpStructReader(lua_State *LL, int iStructStack, int iStructTypeStack);

	template <typename Reader>
	void visit(Reader &t, bool bOpt) const;
};

class LuaSdpVector
{
public:
	LuaSdpVector() : L(NULL), m_iVectorStack(0), m_iInnerTypeStack(0) {}
	LuaSdpVector(lua_State *LL, int iVectorStack, int iInnerTypeStack);

protected:
	lua_State *L;
	int m_iVectorStack;
	int m_iInnerTypeStack;
};

class LuaSdpVectorWriter : public LuaSdpVector
{
public:
	LuaSdpVectorWriter() : m_iVectorSize(0), m_iCurIndex(0) {}
	LuaSdpVectorWriter(lua_State *LL, int iVectorStack, int iInnerTypeStack);

	uint32_t size() const { return m_iVectorSize; }
	bool next() const;

	template <typename Writer>
	void visit(Writer &t, uint32_t tag, bool require, const char *name) const;

private:
	uint32_t m_iVectorSize;
	mutable uint32_t m_iCurIndex;
};

class LuaSdpVectorReader : public LuaSdpVector
{
public:
	LuaSdpVectorReader() : m_iCurIndex(0) {}
	LuaSdpVectorReader(lua_State *LL, int iVectorStack, int iInnerTypeStack);

	template <typename Reader>
	void visit(Reader &t, uint32_t tag, bool require, const char *name) const;

private:
	mutable uint32_t m_iCurIndex;
};

class LuaSdpMap
{
public:
	LuaSdpMap() : L(NULL), m_iMapStack(0), m_iMapKeyTypeStack(0), m_iMapValTypeStack(0) {}
	LuaSdpMap(lua_State *LL, int iMapStack, int iMapKeyTypeStack, int iMapValTypeStack);

protected:
	lua_State *L;
	int m_iMapStack;
	int m_iMapKeyTypeStack;
	int m_iMapValTypeStack;
};

class LuaSdpMapWriter : public LuaSdpMap
{
public:
	LuaSdpMapWriter() : m_iMapSize(0), m_iSortStack(0), m_iMapKeyStack(0), m_iMapValStack(0), m_iCurIndex(0) {}
	LuaSdpMapWriter(lua_State *LL, int iMapStack, int iMapKeyTypeStack, int iMapValTypeStack);

	uint32_t size() const { return m_iMapSize; }
	bool next() const;

	template <typename Writer>
	void visitKey(Writer &t, uint32_t tag, bool require, const char *name) const;

	template <typename Writer>
	void visitVal(Writer &t, uint32_t tag, bool require, const char *name) const;

private:
	uint32_t m_iMapSize;
	mutable int m_iSortStack;
	mutable int m_iMapKeyStack;
	mutable int m_iMapValStack;
	mutable uint32_t m_iCurIndex;
};

class LuaSdpMapReader : public LuaSdpMap
{
public:
	LuaSdpMapReader() : m_iCurIndex(0) {}
	LuaSdpMapReader(lua_State *LL, int iMapStack, int iMapKeyTypeStack, int iMapValTypeStack);

	template <typename Reader>
	void visit(Reader &t, uint32_t tag, bool require, const char *name);

private:
	mutable uint32_t m_iCurIndex;
};

extern "C" int luaopen_sdplua(lua_State *L);

#endif
