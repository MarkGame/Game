#include "sdplua.h"
#include <algorithm>

//#define DEBUG(x) do { cout << __LINE__ << "\t" << x << endl; } while(0)
#define DEBUG(x) do { } while (0)

#define PSTACK do { cout << __LINE__ << "\tstack top: " << lua_gettop(L) << endl; } while (0)
#define CHECK_STACK(L, n) do { if (lua_gettop(L) != n) throw std::runtime_error("stack inconsistent"); } while (0)

static int formalStackIndex(lua_State *L, int iStackIndex)
{
	return iStackIndex >= 0 ? iStackIndex : (lua_gettop(L) + 1 + iStackIndex);
}

static string readLuaString(lua_State *L, int iStackIndex)
{
	string s;
	size_t len = 0;
	const char *p = lua_tolstring(L, iStackIndex, &len);
	if (p != NULL && len != 0)
	{
		s.assign(p, len);
	}
	return s;
}

static bool isTableEmpty(lua_State *L, int iStackIndex)
{
	lua_pushnil(L);
	if (lua_next(L, iStackIndex) != 0)
	{
		lua_pop(L, 2);
		return false;
	}
	return true;
}

#ifndef __USE_BSD
#include <limits.h>
#include <errno.h>
/*
 * Convert a string to an unsigned long long.
 *
 * Ignores `locale' stuff.  Assumes that the upper and lower case
 * alphabets and digits are each contiguous.
 */
unsigned long long
strtoull(const char *nptr, char **endptr, int base)
{
	const char *s;
	unsigned long long acc, cutoff;
	int c;
	int neg, any, cutlim;

	/*
	 * See strtoq for comments as to the logic used.
	 */
	s = nptr;
	do {
		c = (unsigned char) *s++;
	} while (isspace(c));
	if (c == '-') {
		neg = 1;
		c = *s++;
	} else {
		neg = 0;
		if (c == '+')
			c = *s++;
	}
	if ((base == 0 || base == 16) &&
	    c == '0' && (*s == 'x' || *s == 'X')) {
		c = s[1];
		s += 2;
		base = 16;
	}
	if (base == 0)
		base = c == '0' ? 8 : 10;

	cutoff = ULLONG_MAX / (unsigned long long)base;
	cutlim = ULLONG_MAX % (unsigned long long)base;
	for (acc = 0, any = 0;; c = (unsigned char) *s++) {
		if (isdigit(c))
			c -= '0';
		else if (isalpha(c))
			c -= isupper(c) ? 'A' - 10 : 'a' - 10;
		else
			break;
		if (c >= base)
			break;
		if (any < 0)
			continue;
		if (acc > cutoff || (acc == cutoff && c > cutlim)) {
			any = -1;
			acc = ULLONG_MAX;
			errno = ERANGE;
		} else {
			any = 1;
			acc *= (unsigned long long)base;
			acc += c;
		}
	}
	if (neg && any > 0)
		acc = -acc;
	if (endptr != 0)
		*endptr = (char *) (any ? s - 1 : nptr);
	return (acc);
}
#endif

static uint64_t parseNumber64(const char *s)
{
	return strtoull(s, NULL, 0);
}

static uint64_t parseNumber64(const string &s)
{
	return parseNumber64(s.c_str());
}

static char *printNumber64(char *buf, int size, int64_t val)
{
	snprintf(buf, size, "%lld", (long long)val);
	return buf;
}

static char *printNumber64(char *buf, int size, uint64_t val)
{
	snprintf(buf, size, "%llu", (unsigned long long)val);
	return buf;
}

template <typename T>
static void sortNumber64(lua_State *L, int iStackIndex)
{
	int n = lua_objlen(L, iStackIndex);
	vector<T> v;
	v.reserve(n);

	for (int i = 1; i <= n; ++i)
	{
		lua_rawgeti(L, iStackIndex, i);
		string sVal = readLuaString(L, -1);
		lua_pop(L, 1);

		v.push_back((T)(parseNumber64(sVal)));
	}
	sort(v.begin(), v.end());

	for (unsigned i = 0; i < v.size(); ++i)
	{
		char buf[64];
		lua_pushstring(L, printNumber64(buf, sizeof(buf), v[i]));
		lua_rawseti(L, iStackIndex, i + 1);
	}
}

LuaSdpValue::LuaSdpValue(lua_State *LL, int iValStack, int iTypeStack)
	: L(LL),
	  m_iValStack(formalStackIndex(L, iValStack)),
	  m_iTypeStack(formalStackIndex(L, iTypeStack)),
	  m_iType(0)
{
	if (lua_isnumber(L, m_iTypeStack))
	{
		m_iType = lua_tonumber(L, m_iTypeStack);
	}
	else
	{
		lua_getfield(L, m_iTypeStack, "TypeId");
		m_iType = lua_tonumber(L, -1);
		lua_pop(L, 1);
	}
}

LuaSdpValueWriter::LuaSdpValueWriter(lua_State *LL, int iValStack, int iTypeStack, int iDefaultStack)
	: LuaSdpValue(LL, iValStack, iTypeStack),
	  m_iDefaultStack(formalStackIndex(L, iDefaultStack))
{
}

template <typename Writer>
void LuaSdpValueWriter::visit(Writer &writer, uint32_t tag, bool require, const char *name) const
{
	DEBUG("write type: " << m_iType);

	switch (m_iType)
	{
	case SdpType_Bool:
		{
			bool bVal = lua_toboolean(L, m_iValStack);
			if (m_iDefaultStack != 0)
			{
				bool bDefVal = lua_toboolean(L, m_iDefaultStack);
				if (bVal == bDefVal)
				{
					break;
				}
			}
			writer.visit(tag, require, name, bVal);
		}
		break;
	case SdpType_Char:
	case SdpType_Int8:
	case SdpType_UInt8:
	case SdpType_Int16:
	case SdpType_UInt16:
	case SdpType_Int32:
	case SdpType_UInt32:
	case SdpType_Enum:
		{
			int64_t iVal = (int64_t)lua_tonumber(L, m_iValStack);
			if (m_iDefaultStack != 0)
			{
				int64_t iDefVal = (int64_t)lua_tonumber(L, m_iDefaultStack);
				if (iVal == iDefVal)
				{
					break;
				}
			}

			if (m_iType == SdpType_Char) writer.visit(tag, require, name, (char)iVal);
			else if (m_iType == SdpType_Int8) writer.visit(tag, require, name, (int8_t)iVal);
			else if (m_iType == SdpType_UInt8) writer.visit(tag, require, name, (uint8_t)iVal);
			else if (m_iType == SdpType_Int16) writer.visit(tag, require, name, (int16_t)iVal);
			else if (m_iType == SdpType_UInt16) writer.visit(tag, require, name, (uint16_t)iVal);
			else if (m_iType == SdpType_Int32) writer.visit(tag, require, name, (int32_t)iVal);
			else if (m_iType == SdpType_UInt32) writer.visit(tag, require, name, (uint32_t)iVal);
			else if (m_iType == SdpType_Enum) writer.visit(tag, require, name, (int32_t)iVal);
		}
		break;
	case SdpType_Float:
	case SdpType_Double:
		{
			double fVal = lua_tonumber(L, m_iValStack);
			if (m_iDefaultStack != 0)
			{
				double fDefVal = lua_tonumber(L, m_iDefaultStack);
				if (fVal == fDefVal)
				{
					break;
				}
			}

			if (m_iType == SdpType_Float) writer.visit(tag, require, name, (float)fVal);
			else if (m_iType == SdpType_Double) writer.visit(tag, require, name, (double)fVal);
		}
		break;
	case SdpType_Int64:
	case SdpType_UInt64:
	case SdpType_String:
		{
			string sVal = readLuaString(L, m_iValStack);
			if (m_iDefaultStack != 0)
			{
				string sDefVal = readLuaString(L, m_iDefaultStack);
				if (sVal == sDefVal)
				{
					break;
				}
			}

			if (m_iType == SdpType_Int64) writer.visit(tag, require, name, (int64_t)parseNumber64(sVal));
			else if (m_iType == SdpType_UInt64) writer.visit(tag, require, name, (uint64_t)parseNumber64(sVal));
			else if (m_iType == SdpType_String) writer.visit(tag, require, name, sVal);
		}
		break;
	case SdpType_Vector:
		{
			if (m_iDefaultStack != 0)
			{
				int iSize = lua_objlen(L, m_iValStack);
				if (iSize <= 0)
				{
					break;
				}
			}

			LuaStackPoper poper(L);
			lua_getfield(L, m_iTypeStack, "InnerType");
			int iVecInnerTypeStack = formalStackIndex(L, -1);
			poper.push(1);

			SdpVectorProxy<LuaSdpVectorWriter> proxy;
			proxy.under = LuaSdpVectorWriter(L, m_iValStack, iVecInnerTypeStack);
			writer.visit(tag, require, name, proxy);
		}
		break;
	case SdpType_Map:
		{
			if (m_iDefaultStack != 0)
			{
				if (isTableEmpty(L, m_iValStack))
				{
					break;
				}
			}

			LuaStackPoper poper(L);
			lua_getfield(L, m_iTypeStack, "KeyType");
			lua_getfield(L, m_iTypeStack, "ValType");
			int iMapKeyTypeStack = formalStackIndex(L, -2);
			int iMapValTypeStack = formalStackIndex(L, -1);
			poper.push(2);

			SdpMapProxy<LuaSdpMapWriter> proxy;
			proxy.under = LuaSdpMapWriter(L, m_iValStack, iMapKeyTypeStack, iMapValTypeStack);
			writer.visit(tag, require, name, proxy);
		}
		break;
	case SdpType_Struct:
		{
			SdpStructProxy<LuaSdpStructWriter> proxy;
			proxy.under = LuaSdpStructWriter(L, m_iValStack, m_iTypeStack);
			writer.visit(tag, require, name, proxy);
		}
		break;
	case SdpType_Void:
		break;
	}
}

LuaSdpValueReader::LuaSdpValueReader(lua_State *LL, int iValStack, int iTypeStack)
	: LuaSdpValue(LL, iValStack, iTypeStack),
	  m_bHasNewValue(false)
{
}

template <typename Reader>
void LuaSdpValueReader::visit(Reader &reader, uint32_t tag, bool require, const char *name)
{
	DEBUG("read type: " << m_iType);

	bool bIsNilValue = (m_iValStack == 0 || lua_isnil(L, m_iValStack)) ? true : false;
	switch (m_iType)
	{
	case SdpType_Bool:
		{
			bool oldval = bIsNilValue ? false : lua_toboolean(L, m_iValStack);
			bool newval = oldval;
			reader.visit(tag, require, name, newval);
			if (bIsNilValue || newval != oldval)
			{
				lua_pushboolean(L, newval);
				m_bHasNewValue = true;
			}
		}
		break;
	case SdpType_Char:
	case SdpType_Int8:
	case SdpType_UInt8:
	case SdpType_Int16:
	case SdpType_UInt16:
	case SdpType_Int32:
	case SdpType_UInt32:
		{
			int64_t oldval = bIsNilValue ? 0 : (int64_t)lua_tonumber(L, m_iValStack);
			int64_t newval = oldval;
			reader.visit(tag, require, name, newval);
			if (bIsNilValue || newval != oldval)
			{
				lua_pushnumber(L, newval);
				m_bHasNewValue = true;
			}
		}
		break;
	case SdpType_Int64:
		{
			int64_t oldval = bIsNilValue ? 0 : (int64_t)parseNumber64(readLuaString(L, m_iValStack));
			int64_t newval = oldval;
			reader.visit(tag, require, name, newval);
			if (bIsNilValue || newval != oldval)
			{
				char buf[64];
				lua_pushstring(L, printNumber64(buf, sizeof(buf), newval));
				m_bHasNewValue = true;
			}
		}
		break;
	case SdpType_UInt64:
		{
			uint64_t oldval = bIsNilValue ? 0 : (uint64_t)parseNumber64(readLuaString(L, m_iValStack));
			uint64_t newval = oldval;
			reader.visit(tag, require, name, newval);
			if (bIsNilValue || newval != oldval)
			{
				char buf[64];
				lua_pushstring(L, printNumber64(buf, sizeof(buf), newval));
				m_bHasNewValue = true;
			}
		}
		break;
	case SdpType_Float:
		{
			float oldval = bIsNilValue ? 0 : lua_tonumber(L, m_iValStack);
			float newval = oldval;
			reader.visit(tag, require, name, newval);
			if (bIsNilValue || newval != oldval)
			{
				lua_pushnumber(L, newval);
				m_bHasNewValue = true;
			}
		}
		break;
	case SdpType_Double:
		{
			double oldval = bIsNilValue ? 0 : lua_tonumber(L, m_iValStack);
			double newval = oldval;
			reader.visit(tag, require, name, newval);
			if (bIsNilValue || newval != oldval)
			{
				lua_pushnumber(L, newval);
				m_bHasNewValue = true;
			}
		}
		break;
	case SdpType_String:
		{
			string oldval = bIsNilValue ? "" : readLuaString(L, m_iValStack);
			string newval = oldval;
			reader.visit(tag, require, name, newval);
			if (bIsNilValue || newval != oldval)
			{
				lua_pushlstring(L, newval.c_str(), newval.size());
				m_bHasNewValue = true;
			}
		}
		break;
	case SdpType_Vector:
		{
			if (bIsNilValue)
			{
				luaL_callmeta(L, m_iTypeStack, "__call");
				m_iValStack = formalStackIndex(L, -1);
				m_bHasNewValue = true;
			}

			LuaStackPoper poper(L);
			lua_getfield(L, m_iTypeStack, "InnerType");
			int iVecInnerTypeStack = formalStackIndex(L, -1);
			poper.push(1);

			SdpVectorProxy<LuaSdpVectorReader> proxy;
			proxy.under = LuaSdpVectorReader(L, m_iValStack, iVecInnerTypeStack);
			reader.visit(tag, require, name, proxy);
		}
		break;
	case SdpType_Map:
		{
			if (bIsNilValue)
			{
				luaL_callmeta(L, m_iTypeStack, "__call");
				m_iValStack = formalStackIndex(L, -1);
				m_bHasNewValue = true;
			}

			LuaStackPoper poper(L);
			lua_getfield(L, m_iTypeStack, "KeyType");
			lua_getfield(L, m_iTypeStack, "ValType");
			int iMapKeyTypeStack = formalStackIndex(L, -2);
			int iMapValTypeStack = formalStackIndex(L, -1);
			poper.push(2);

			SdpMapProxy<LuaSdpMapReader> proxy;
			proxy.under = LuaSdpMapReader(L, m_iValStack, iMapKeyTypeStack, iMapValTypeStack);
			reader.visit(tag, require, name, proxy);
		}
		break;
	case SdpType_Struct:
		{
			if (bIsNilValue)
			{
				luaL_callmeta(L, m_iTypeStack, "__call");
				m_iValStack = formalStackIndex(L, -1);
				m_bHasNewValue = true;
			}

			SdpStructProxy<LuaSdpStructReader> proxy;
			proxy.under = LuaSdpStructReader(L, m_iValStack, m_iTypeStack);
			reader.visit(tag, require, name, proxy);
		}
		break;
	}
}

LuaSdpStruct::LuaSdpStruct(lua_State *LL, int iStructStack, int iStructTypeStack)
	: L(LL),
	  m_iStructStack(formalStackIndex(L, iStructStack)),
	  m_iStructTypeStack(formalStackIndex(L, iStructTypeStack))
{
}

template <bool IsWriteOperation, bool IsWriteCodeBlock>
struct ReaderWriterSelector
{
	struct Dummy
	{
		template <typename T>
		void visit(T &, ...) const {}
	};

	template <typename T> Dummy operator()(T &) { return Dummy(); }
};

template <>
struct ReaderWriterSelector <true, true>
{
	template <typename T> T &operator()(T &t) { return t; }
};

template <>
struct ReaderWriterSelector <false, false>
{
	template <typename T> T &operator()(T &t) { return t; }
};

template <typename T, bool IsWrite>
void LuaSdpStruct::visit(T &t, bool bOpt) const
{
	DEBUG((IsWrite ? "write" : "read") << " struct");

	LuaStackPoper poper(L);
	lua_getfield(L, m_iStructTypeStack, "Definition");
	int iStructDefinitionStack = formalStackIndex(L, -1);
	poper.push(1);

	int iFieldNum = lua_objlen(L, iStructDefinitionStack);
	for (int i = 1; i <= iFieldNum; ++i)
	{
		LuaStackPoper poper(L);

		// name
		lua_rawgeti(L, iStructDefinitionStack, i);
		string sName = lua_tostring(L, -1);
		lua_pop(L, 1);

		// define
		lua_getfield(L, iStructDefinitionStack, sName.c_str());
		int iFieldDefineStack = formalStackIndex(L, -1);
		poper.push(1);

		// tag
		lua_rawgeti(L, iFieldDefineStack, 1);
		uint32_t iTag = lua_tointeger(L, -1);
		lua_pop(L, 1);

		// required
		lua_rawgeti(L, iFieldDefineStack, 2);
		bool bRequired = lua_tointeger(L, -1) == 0 ? false : true;
		lua_pop(L, 1);

		// type
		lua_rawgeti(L, iFieldDefineStack, 3);
		int iFieldTypeStack = formalStackIndex(L, -1);
		poper.push(1);

		// cur
		lua_getfield(L, m_iStructStack, sName.c_str());
		int iFieldCurValueStack = formalStackIndex(L, -1);
		poper.push(1);

		DEBUG((IsWrite ? "write" : "read") << " struct field, tag: " << iTag << ", required: " << (bRequired ? "true" : "false") << ", name: " << sName);

		if (IsWrite)
		{
			// default
			lua_rawgeti(L, iFieldDefineStack, 4);
			int iFieldDefValueStack = formalStackIndex(L, -1);
			poper.push(1);

			int iDefaultStack = 0;
			if (!(bOpt || bRequired))
			{
				iDefaultStack = iFieldDefValueStack;
			}

			LuaSdpValueWriter writer(L, iFieldCurValueStack, iFieldTypeStack, iDefaultStack);
			ReaderWriterSelector<IsWrite, true>()(writer).visit(t, iTag, bRequired, sName.c_str());
		}
		else
		{
			LuaSdpValueReader reader(L, iFieldCurValueStack, iFieldTypeStack);
			ReaderWriterSelector<IsWrite, false>()(reader).visit(t, iTag, bRequired, sName.c_str());
			if (reader.hasNewValue())
			{
				lua_setfield(L, m_iStructStack, sName.c_str());
			}
		}
	}
}

LuaSdpStructWriter::LuaSdpStructWriter(lua_State *LL, int iStructStack, int iStructTypeStack)
	: LuaSdpStruct(LL, iStructStack, iStructTypeStack)
{
}

template <typename Writer>
void LuaSdpStructWriter::visit(Writer &t, bool bOpt) const
{
	LuaSdpStruct::visit<Writer, true>(t, bOpt);
}

LuaSdpStructReader::LuaSdpStructReader(lua_State *LL, int iStructStack, int iStructTypeStack)
	: LuaSdpStruct(LL, iStructStack, iStructTypeStack)
{
}

template <typename Reader>
void LuaSdpStructReader::visit(Reader &t, bool bOpt) const
{
	LuaSdpStruct::visit<Reader, false>(t, bOpt);
}

LuaSdpVector::LuaSdpVector(lua_State *LL, int iVectorStack, int iInnerTypeStack)
	: L(LL),
	  m_iVectorStack(formalStackIndex(L, iVectorStack)),
	  m_iInnerTypeStack(formalStackIndex(L, iInnerTypeStack))
{

}

LuaSdpVectorWriter::LuaSdpVectorWriter(lua_State *LL, int iVectorStack, int iInnerTypeStack)
	: LuaSdpVector(LL, iVectorStack, iInnerTypeStack),
	  m_iVectorSize(0), m_iCurIndex(0)
{
	m_iVectorSize = lua_objlen(L, m_iVectorStack);
}

bool LuaSdpVectorWriter::next() const
{
	if (m_iCurIndex >= m_iVectorSize)
	{
		return false;
	}
	++m_iCurIndex;
	return true;
}

template <typename Writer>
void LuaSdpVectorWriter::visit(Writer &t, uint32_t tag, bool require, const char *name) const
{
	DEBUG("write vector, index: " << m_iCurIndex);

	LuaStackPoper poper(L);
	lua_rawgeti(L, m_iVectorStack, m_iCurIndex);
	int iElementValueStack = formalStackIndex(L, -1);
	poper.push(1);

	LuaSdpValueWriter writer(L, iElementValueStack, m_iInnerTypeStack);
	writer.visit(t, tag, require, name);
}

LuaSdpVectorReader::LuaSdpVectorReader(lua_State *LL, int iVectorStack, int iInnerTypeStack)
	: LuaSdpVector(LL, iVectorStack, iInnerTypeStack),
	  m_iCurIndex(0)
{
}

template <typename Reader>
void LuaSdpVectorReader::visit(Reader &t, uint32_t tag, bool require, const char *name) const
{
	++m_iCurIndex;
	DEBUG("read vector, index: " << m_iCurIndex);

	LuaSdpValueReader reader(L, 0, m_iInnerTypeStack);
	reader.visit(t, tag, require, name);
	lua_rawseti(L, m_iVectorStack, m_iCurIndex);
}

LuaSdpMap::LuaSdpMap(lua_State *LL, int iMapStack, int iMapKeyTypeStack, int iMapValTypeStack)
	: L(LL), m_iMapStack(iMapStack), m_iMapKeyTypeStack(iMapKeyTypeStack), m_iMapValTypeStack(iMapValTypeStack)
{
}

LuaSdpMapWriter::LuaSdpMapWriter(lua_State *LL, int iMapStack, int iMapKeyTypeStack, int iMapValTypeStack)
	: LuaSdpMap(LL, iMapStack, iMapKeyTypeStack, iMapValTypeStack),
	  m_iMapSize(0), m_iSortStack(0), m_iMapKeyStack(0), m_iMapValStack(0), m_iCurIndex(0)
{
	lua_createtable(L, 0, 0);
	m_iSortStack = formalStackIndex(L, -1);

	lua_pushnil(L);
	while (lua_next(L, m_iMapStack) != 0)
	{
		++m_iMapSize;
		lua_pop(L, 1);

		lua_pushvalue(L, -1);
		lua_rawseti(L, m_iSortStack, m_iMapSize);
	}

	if (m_iMapSize == 0)
	{
		lua_remove(L, m_iSortStack);
		m_iSortStack = 0;
	}
	else if (m_iMapSize > 1)
	{
		bool bSorted = false;
		if (lua_isnumber(L, iMapKeyTypeStack))
		{
			uint32_t iType = lua_tointeger(L, iMapKeyTypeStack);
			if (iType == SdpType_Int64)
			{
				sortNumber64<int64_t>(L, m_iSortStack);
				bSorted = true;
			}
			else if (iType == SdpType_UInt64)
			{
				sortNumber64<uint64_t>(L, m_iSortStack);
				bSorted = true;
			}
		}

		if (!bSorted)
		{
			lua_getglobal(L, "table");
			lua_getfield(L, -1, "sort");
			lua_remove(L, -2);

			lua_pushvalue(L, m_iSortStack);
			lua_call(L, 1, 0);
		}
	}
}

bool LuaSdpMapWriter::next() const
{
	if (m_iMapSize == 0 || m_iCurIndex > m_iMapSize)
	{
		return false;
	}
	++m_iCurIndex;
	if (m_iCurIndex != 1)
	{
		lua_pop(L, 2);
	}
	if (m_iCurIndex > m_iMapSize)
	{
		lua_remove(L, m_iSortStack);
		m_iSortStack = 0;
		return false;
	}

	lua_rawgeti(L, m_iSortStack, m_iCurIndex);
	lua_pushvalue(L, -1);
	lua_gettable(L, m_iMapStack);

	m_iMapKeyStack = formalStackIndex(L, -2);
	m_iMapValStack = formalStackIndex(L, -1);
	return true;
}

template <typename Writer>
void LuaSdpMapWriter::visitKey(Writer &t, uint32_t tag, bool require, const char *name) const
{
	DEBUG("write map key, index: " << m_iCurIndex);

	LuaSdpValueWriter writer(L, m_iMapKeyStack, m_iMapKeyTypeStack);
	writer.visit(t, tag, require, name);
}

template <typename Writer>
void LuaSdpMapWriter::visitVal(Writer &t, uint32_t tag, bool require, const char *name) const
{
	DEBUG("write map value, index: " << m_iCurIndex);

	LuaSdpValueWriter writer(L, m_iMapValStack, m_iMapValTypeStack);
	writer.visit(t, tag, require, name);
}

LuaSdpMapReader::LuaSdpMapReader(lua_State *LL, int iMapStack, int iMapKeyTypeStack, int iMapValTypeStack)
	: LuaSdpMap(LL, iMapStack, iMapKeyTypeStack, iMapValTypeStack),
	  m_iCurIndex(0)
{
}

template <typename Reader>
void LuaSdpMapReader::visit(Reader &t, uint32_t tag, bool require, const char *name)
{
	++m_iCurIndex;
	DEBUG("read map, index: " << m_iCurIndex);

	LuaSdpValueReader reader1(L, 0, m_iMapKeyTypeStack);
	reader1.visit(t, tag, require, name);

	LuaSdpValueReader reader2(L, 0, m_iMapValTypeStack);
	reader2.visit(t, tag, require, name);

	lua_rawset(L, m_iMapStack);
}

static int display(lua_State *L)
{
	try
	{
		SdpStructProxy<LuaSdpStructWriter> proxy;
		proxy.under = LuaSdpStructWriter(L, -2, -1);
		string s = printSdp(proxy);
		lua_pushlstring(L, s.c_str(), s.size());

		CHECK_STACK(L, 3);
		return 1;
	}
	catch (std::exception &e)
	{
		lua_pushnil(L);
		lua_pushstring(L, e.what());
		return 2;
	}
}

static int pack(lua_State *L)
{
	try
	{
		SdpStructProxy<LuaSdpStructWriter> proxy;
		proxy.under = LuaSdpStructWriter(L, -2, -1);
		string s = sdpToString(proxy);
		lua_pushlstring(L, s.c_str(), s.size());

		CHECK_STACK(L, 3);
		return 1;
	}
	catch (std::exception &e)
	{
		lua_pushnil(L);
		lua_pushstring(L, e.what());
		return 2;
	}
}

static int unpack(lua_State *L)
{
	try
	{
		string sData;
		size_t len = 0;
		const char *p = lua_tolstring(L, -3, &len);
		if (p != NULL && len != 0)
		{
			sData.assign(p, len);
		}

		SdpStructProxy<LuaSdpStructReader> proxy;
		proxy.under = LuaSdpStructReader(L, -2, -1);
		stringToSdp(sData, proxy);
		lua_pushvalue(L, -2);

		CHECK_STACK(L, 4);
		return 1;
	}
	catch (std::exception &e)
	{
		lua_pushnil(L);
		lua_pushstring(L, e.what());
		return 2;
	}
}

static const luaL_Reg _sdplua[] = {
	{"display", display},
	{"pack", pack},
	{"unpack", unpack},
	{NULL, NULL}
};

extern "C" int luaopen_sdplua(lua_State *L)
{
	luaL_register(L, "sdplua", _sdplua);
	return 1;
}
