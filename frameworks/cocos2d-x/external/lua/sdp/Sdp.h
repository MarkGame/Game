#ifndef _MFW_SDP_H_
#define _MFW_SDP_H_

#include <stdint.h>
#include <cstring>
#include <cstdio>
#include <string>
#include <vector>
#include <map>
#include <sstream>
#include <stdexcept>
using namespace std;

namespace mfw
{

enum SdpPackDataType
{
	SdpPackDataType_Integer_Positive = 0,
	SdpPackDataType_Integer_Negative = 1,
	SdpPackDataType_Float = 2,
	SdpPackDataType_Double = 3,
	SdpPackDataType_String = 4,
	SdpPackDataType_Vector = 5,
	SdpPackDataType_Map = 6,
	SdpPackDataType_StructBegin = 7,
	SdpPackDataType_StructEnd = 8,
};

template <typename Under>
struct SdpStructProxy
{
	Under under;
};

template <typename Under>
struct SdpVectorProxy
{
	Under under;
};

template <typename Under>
struct SdpMapProxy
{
	Under under;
};

class SdpPacker
{
public:
	void swap(string &data) { std::swap(m_data, data); }
	string &getData() { return m_data; }
	const string &getData() const { return m_data; }

	// redirection
	template <typename T>
	void visit(uint32_t tag, bool require, const char * /*name*/, const T &val)
	{
		pack(tag, require, val);
	}

	// packing interface
	template <typename T>
	void pack(const T &val)
	{
		pack(0, true, val);
	}
	template <typename T>
	void pack(uint32_t tag,const T &val)
	{
		pack(tag, true, val);
	}

	void pack(uint32_t tag, bool /*require*/, bool val)
	{
		pack(tag, (uint32_t)val ? 1 : 0);
	}
	void pack(uint32_t tag, bool /*require*/, char val)
	{
		pack(tag, (uint32_t)val);
	}
	void pack(uint32_t tag, bool /*require*/, int8_t val)
	{
		pack(tag, (int32_t)val);
	}
	void pack(uint32_t tag, bool /*require*/, uint8_t val)
	{
		pack(tag, (uint32_t)val);
	}
	void pack(uint32_t tag, bool /*require*/, int16_t val)
	{
		pack(tag, (int32_t)val);
	}
	void pack(uint32_t tag, bool /*require*/, uint16_t val)
	{
		pack(tag, (uint32_t)val);
	}
	void pack(uint32_t tag, bool /*require*/, int32_t val)
	{
		pack(tag, val);
	}
	void pack(uint32_t tag, bool /*require*/, uint32_t val)
	{
		pack(tag, val);
	}
	void pack(uint32_t tag, bool /*require*/, int64_t val)
	{
		pack(tag, val);
	}
	void pack(uint32_t tag, bool /*require*/, uint64_t val)
	{
		pack(tag, val);
	}
	void pack(uint32_t tag, int32_t val)
	{
		if (val < 0)
		{
			packHeader(tag, SdpPackDataType_Integer_Negative);
			packNumber((uint32_t)-val);
		}
		else
		{
			pack(tag, (uint32_t)val);
		}
	}
	void pack(uint32_t tag, uint32_t val)
	{
		packHeader(tag, SdpPackDataType_Integer_Positive);
		packNumber(val);
	}
	void pack(uint32_t tag, int64_t val)
	{
		if (val < 0)
		{
			packHeader(tag, SdpPackDataType_Integer_Negative);
			packNumber((uint64_t)-val);
		}
		else
		{
			pack(tag, (uint64_t)val);
		}
	}
	void pack(uint32_t tag, uint64_t val)
	{
		packHeader(tag, SdpPackDataType_Integer_Positive);
		packNumber(val);
	}
	void pack(uint32_t tag, bool /*require*/, float val)
	{
		packHeader(tag, SdpPackDataType_Float);
		union { float f; uint32_t i; };
		f = val;
		packNumber(i);
	}
	void pack(uint32_t tag, bool /*require*/, double val)
	{
		packHeader(tag, SdpPackDataType_Double);
		union { double d; uint64_t i; };
		d = val;
		packNumber(i);
	}

	void pack(uint32_t tag, bool /*require*/, const string &val)
	{
		packHeader(tag, SdpPackDataType_String);
		packNumber((unsigned int)val.size());
		packData(val.c_str(), val.size());
	}
	template <typename Alloc>
	void pack(uint32_t tag, bool /*require*/, const vector<char, Alloc> &val)
	{
		packHeader(tag, SdpPackDataType_String);
		packNumber(val.size());
		packData(&val[0], val.size());
	}

	template <typename T, typename Alloc>
	void pack(uint32_t tag, bool /*require*/, const vector<T, Alloc> &val)
	{
		packHeader(tag, SdpPackDataType_Vector);
		packNumber(val.size());
		for (unsigned i = 0; i < val.size(); ++i)
		{
			pack(val[i]);
		}
	}

	template <typename T>
	void pack(uint32_t tag, bool /*require*/, const SdpVectorProxy<T> &val)
	{
		packHeader(tag, SdpPackDataType_Vector);
		packNumber(val.under.size());
		while (val.under.next())
		{
			val.under.visit(*this, 0, true, NULL);
		}
	}

	template <typename Key, typename Value, typename Compare, typename Alloc>
	void pack(uint32_t tag, bool /*require*/, const map<Key, Value, Compare, Alloc> &val)
	{
		packHeader(tag, SdpPackDataType_Map);
		packNumber(val.size());
		for (typename map<Key, Value, Compare, Alloc>::const_iterator first = val.begin(), last = val.end(); first != last; ++first)
		{
			pack(first->first);
			pack(first->second);
		}
	}

	template <typename T>
	void pack(uint32_t tag, bool /*require*/, const SdpMapProxy<T> &val)
	{
		packHeader(tag, SdpPackDataType_Map);
		packNumber(val.under.size());
		while (val.under.next())
		{
			val.under.visitKey(*this, 0, true, NULL);
			val.under.visitVal(*this, 0, true, NULL);
		}
	}

	template <typename T>
	void pack(uint32_t tag, bool require, const T &val)
	{
		if (require)
		{
			packHeader(tag, SdpPackDataType_StructBegin);
			val.visit(*this, false); // without optional field with default value
			packHeader(0, SdpPackDataType_StructEnd);
		}
		else
		{
			string::size_type size1 = m_data.size();

			packHeader(tag, SdpPackDataType_StructBegin);
			string::size_type size2 = m_data.size();

			val.visit(*this, false); // without optional field with default value
			if (size2 == m_data.size())
			{
				m_data.resize(size1);
			}
			else
			{
				packHeader(0, SdpPackDataType_StructEnd);
			}
		}
	}

	template <typename T>
	void pack(uint32_t tag, bool require, const SdpStructProxy<T> &val)
	{
		if (require)
		{
			packHeader(tag, SdpPackDataType_StructBegin);
			val.under.visit(*this, false);
			packHeader(0, SdpPackDataType_StructEnd);
		}
		else
		{
			string::size_type size1 = m_data.size();

			packHeader(tag, SdpPackDataType_StructBegin);
			string::size_type size2 = m_data.size();

			val.under.visit(*this, false);
			if (size2 == m_data.size())
			{
				m_data.resize(size1);
			}
			else
			{
				packHeader(0, SdpPackDataType_StructEnd);
			}
		}
	}

	// data operation
	void packData(const void *p, uint32_t size)
	{
		m_data.append((const char *)p, size);
	}
	void packHeader(uint32_t tag, SdpPackDataType type)
	{
		uint8_t header = type << 4;
		if (tag < 15)
		{
			header |= tag;
			packData(&header, 1);
		}
		else
		{
			header |= 0xf;
			packData(&header, 1);
			packNumber(tag);
		}
	}
	void packNumber(uint32_t val)
	{
		uint8_t bytes[5];
		uint32_t n = 0;
		while (val > 0x7f)
		{
			bytes[n++] = ((uint8_t)(val) & 0x7f) | 0x80;
			val >>= 7;
		}
		bytes[n++] = (uint8_t)val;
		packData(bytes, n);
	}
	void packNumber(uint64_t val)
	{
		uint8_t bytes[10];
		uint32_t n = 0;
		while (val > 0x7f)
		{
			bytes[n++] = ((uint8_t)(val) & 0x7f) | 0x80;
			val >>= 7;
		}
		bytes[n++] = (uint8_t)val;
		packData(bytes, n);
	}

private:
	string m_data;
};

struct SdpException : public std::exception
{
	explicit SdpException(const string &msg) : sWhat(msg) {}
	virtual ~SdpException() throw() {}
	void trace(uint32_t tag, const char *name)
	{
		if (name)
		{
			if (!sWhat.empty())
			{
				sWhat.append(" <- ");
			}

			char buf[20];
			snprintf(buf, sizeof(buf), "%u", tag);
			sWhat.append(buf);
			sWhat.append(":");
			sWhat.append(name);
		}
	}

	const char *what() const throw() { return sWhat.c_str(); }

	string sWhat;
};

#define _SDPUNPACKER_EXCEPT_TRY_ 			try {
#define _SDPUNPACKER_EXCEPT_CATCH_THROW_	} catch (SdpException &e) { e.trace(tag, name); throw; }

class SdpUnpacker
{
public:
	SdpUnpacker() { reset(NULL, 0); }
	explicit SdpUnpacker(const string &data) : m_data(NULL), m_size(0), m_pos(0) { reset(data.c_str(), data.size()); }
	explicit SdpUnpacker(const vector<char> &vData) : m_data(NULL), m_size(0), m_pos(0) { reset(&vData[0], vData.size()); }
	SdpUnpacker(const void *data, uint32_t size)  { reset(data, size); }
	void reset() { reset(NULL, 0); }
	void reset(const string &data) { reset(data.c_str(), data.size()); }
	void reset(const void *data, uint32_t size)
	{
		m_data = static_cast<const uint8_t*>(data);
		m_size = size;
		m_pos = 0;
	}

	// redirection
	template <typename T>
	void visit(uint32_t tag, bool require, const char *name, T &val)
	{
		unpack(tag, require, name, val);
	}

	// unpacking interface
	template <typename T>
	void unpack(T &val)
	{
		unpack(0, true, NULL, val);
	}

	void unpack(uint32_t tag, bool require, const char *name, bool &val)
	{
		uint32_t v = val ? 1 : 0;
		unpack(tag, require, name, v);
		val = v ? true : false;
	}
	void unpack(uint32_t tag, bool require, const char *name, char &val)
	{
		uint32_t v = static_cast<uint8_t>(val);
		unpack(tag, require, name, v);
		val = static_cast<char>(v);
	}
	void unpack(uint32_t tag, bool require, const char *name, int8_t &val)
	{
		int32_t v = val;
		unpack(tag, require, name, v);
		val = static_cast<int8_t>(v);
	}
	void unpack(uint32_t tag, bool require, const char *name, uint8_t &val)
	{
		uint32_t v = val;
		unpack(tag, require, name, v);
		val = static_cast<uint8_t>(v);
	}
	void unpack(uint32_t tag, bool require, const char *name, int16_t &val)
	{
		int32_t v = val;
		unpack(tag, require, name, v);
		val = static_cast<int16_t>(v);
	}
	void unpack(uint32_t tag, bool require, const char *name, uint16_t &val)
	{
		uint32_t v = val;
		unpack(tag, require, name, v);
		val = static_cast<uint16_t>(v);
	}
	void unpack(uint32_t tag, bool require, const char *name, int32_t &val)
	{
		uint32_t v = static_cast<uint32_t>(val);
		unpack(tag, require, name, v);
		val = static_cast<int32_t>(v);
	}
	void unpack(uint32_t tag, bool require, const char *name, uint32_t &val)
	{
		_SDPUNPACKER_EXCEPT_TRY_
		if (skipToTag(tag, require))
		{
			SdpPackDataType type;
			unpackHeader(tag, type);
			if (type == SdpPackDataType_Integer_Negative)
			{
				uint32_t v = val;
				unpackNumber(v);
				val = static_cast<uint32_t>(-v);
			}
			else if (type == SdpPackDataType_Integer_Positive)
			{
				unpackNumber(val);
			}
			else
			{
				throwIncompatiableType(type);
			}
		}
		_SDPUNPACKER_EXCEPT_CATCH_THROW_
	}
	void unpack(uint32_t tag, bool require, const char *name, int64_t &val)
	{
		uint64_t v = static_cast<uint64_t>(val);
		unpack(tag, require, name,  v);
		val = static_cast<int64_t>(v);
	}
	void unpack(uint32_t tag, bool require, const char *name, uint64_t &val)
	{
		_SDPUNPACKER_EXCEPT_TRY_
		if (skipToTag(tag, require))
		{
			SdpPackDataType type;
			unpackHeader(tag, type);
			if (type == SdpPackDataType_Integer_Negative)
			{
				uint64_t v = val;
				unpackNumber(v);
				val = static_cast<uint64_t>(-v);
			}
			else if (type == SdpPackDataType_Integer_Positive)
			{
				unpackNumber(val);
			}
			else
			{
				throwIncompatiableType(type);
			}
		}
		_SDPUNPACKER_EXCEPT_CATCH_THROW_
	}
	void unpack(uint32_t tag, bool require, const char *name, float &val)
	{
		_SDPUNPACKER_EXCEPT_TRY_
		if (skipToTag(tag, require))
		{
			SdpPackDataType type;
			unpackHeader(tag, type);
			if (type == SdpPackDataType_Float)
			{
				union { float f; uint32_t v; };
				f = val;
				unpackNumber(v);
				val = f;
			}
			else if (type == SdpPackDataType_Double)
			{
				union { double d; uint64_t v; };
				d = val;
				unpackNumber(v);
				val = static_cast<float>(d);
			}
			else
			{
				throwIncompatiableType(type);
			}
		}
		_SDPUNPACKER_EXCEPT_CATCH_THROW_
	}
	void unpack(uint32_t tag, bool require, const char *name, double &val)
	{
		_SDPUNPACKER_EXCEPT_TRY_
		if (skipToTag(tag, require))
		{
			SdpPackDataType type;
			unpackHeader(tag, type);
			if (type == SdpPackDataType_Float)
			{
				union { float f; uint32_t v; };
				f = static_cast<float>(val);
				unpackNumber(v);
				val = f;
			}
			else if (type == SdpPackDataType_Double)
			{
				union { double d; uint64_t v; };
				d = val;
				unpackNumber(v);
				val = d;
			}
			else
			{
				throwIncompatiableType(type);
			}
		}
		_SDPUNPACKER_EXCEPT_CATCH_THROW_
	}
	void unpack(uint32_t tag, bool require, const char *name, string &val)
	{
		_SDPUNPACKER_EXCEPT_TRY_
		if (skipToTag(tag, require))
		{
			SdpPackDataType type;
			unpackHeader(tag, type);
			if (type == SdpPackDataType_String)
			{
				uint32_t size;
				unpackNumber(size);
				val.resize(size);
				unpackData(&val[0], size);
			}
			else
			{
				throwIncompatiableType(type);
			}
		}
		_SDPUNPACKER_EXCEPT_CATCH_THROW_
	}
	template <typename Alloc>
	void unpack(uint32_t tag, bool require, const char *name, vector<char, Alloc> &val)
	{
		_SDPUNPACKER_EXCEPT_TRY_
		if (skipToTag(tag, require))
		{
			SdpPackDataType type;
			unpackHeader(tag, type);
			if (type == SdpPackDataType_String)
			{
				uint32_t size;
				unpackNumber(size);
				val.resize(size);
				unpackData(&val[0], size);
			}
			else
			{
				throwIncompatiableType(type);
			}
		}
		_SDPUNPACKER_EXCEPT_CATCH_THROW_
	}

	template <typename T, typename Alloc>
	void unpack(uint32_t tag, bool require, const char *name, vector<T, Alloc> &val)
	{
		_SDPUNPACKER_EXCEPT_TRY_
		if (skipToTag(tag, require))
		{
			SdpPackDataType type;
			unpackHeader(tag, type);
			if (type == SdpPackDataType_Vector)
			{
				uint32_t size;
				unpackNumber(size);
				val.resize(size);
				for (uint32_t i = 0; i < size; ++i)
				{
					unpack(val[i]);
				}
			}
			else
			{
				throwIncompatiableType(type);
			}
		}
		_SDPUNPACKER_EXCEPT_CATCH_THROW_
	}

	template <typename T>
	void unpack(uint32_t tag, bool require, const char *name, SdpVectorProxy<T> &val)
	{
		_SDPUNPACKER_EXCEPT_TRY_
		if (skipToTag(tag, require))
		{
			SdpPackDataType type;
			unpackHeader(tag, type);
			if (type == SdpPackDataType_Vector)
			{
				uint32_t size;
				unpackNumber(size);
				for (uint32_t i = 0; i < size; ++i)
				{
					val.under.visit(*this, 0, true, NULL);
				}
			}
			else
			{
				throwIncompatiableType(type);
			}
		}
		_SDPUNPACKER_EXCEPT_CATCH_THROW_
	}

	template <typename Key, typename Value, typename Compare, typename Alloc>
	void unpack(uint32_t tag, bool require, const char *name, map<Key, Value, Compare, Alloc> &val)
	{
		_SDPUNPACKER_EXCEPT_TRY_
		if (skipToTag(tag, require))
		{
			SdpPackDataType type;
			unpackHeader(tag, type);
			if (type == SdpPackDataType_Map)
			{
				uint32_t size;
				unpackNumber(size);
				for (uint32_t i = 0; i < size; ++i)
				{
					Key key;
					unpack(key);
					Value &value = val[key];
					unpack(value);
				}
			}
			else
			{
				throwIncompatiableType(type);
			}
		}
		_SDPUNPACKER_EXCEPT_CATCH_THROW_
	}

	template <typename T>
	void unpack(uint32_t tag, bool require, const char *name, SdpMapProxy<T> &val)
	{
		_SDPUNPACKER_EXCEPT_TRY_
		if (skipToTag(tag, require))
		{
			SdpPackDataType type;
			unpackHeader(tag, type);
			if (type == SdpPackDataType_Map)
			{
				uint32_t size;
				unpackNumber(size);
				for (uint32_t i = 0; i < size; ++i)
				{
					val.under.visit(*this, 0, true, NULL);
				}
			}
			else
			{
				throwIncompatiableType(type);
			}
		}
		_SDPUNPACKER_EXCEPT_CATCH_THROW_
	}

	template <typename T>
	void unpack(uint32_t tag, bool require, const char *name, T &val)
	{
		_SDPUNPACKER_EXCEPT_TRY_
		if (skipToTag(tag, require))
		{
			SdpPackDataType type;
			unpackHeader(tag, type);
			if (type == SdpPackDataType_StructBegin)
			{
				val.visit(*this, true); // with all optional field
				skipToStructEnd();
			}
			else
			{
				throwIncompatiableType(type);
			}
		}
		_SDPUNPACKER_EXCEPT_CATCH_THROW_
	}

	template <typename T>
	void unpack(uint32_t tag, bool require, const char *name, SdpStructProxy<T> &val)
	{
		_SDPUNPACKER_EXCEPT_TRY_
		if (skipToTag(tag, require))
		{
			SdpPackDataType type;
			unpackHeader(tag, type);
			if (type == SdpPackDataType_StructBegin)
			{
				val.under.visit(*this, true);
				skipToStructEnd();
			}
			else
			{
				throwIncompatiableType(type);
			}
		}
		_SDPUNPACKER_EXCEPT_CATCH_THROW_
	}

	// data operation
	void checksize(uint32_t size)
	{
		if (m_size - m_pos < size)
		{
			throwNoEnoughData();
		}
	}
	void skip(uint32_t size)
	{
		checksize(size);
		m_pos += size;
	}
	void unpackData(void *p, uint32_t size)
	{
		checksize(size);
		memcpy(p, m_data + m_pos, size);
		m_pos += size;
	}
	uint32_t peekHeader(uint32_t &tag, SdpPackDataType &type)
	{
		uint32_t n = 1;
		checksize(1);
		type = static_cast<SdpPackDataType>(m_data[m_pos] >> 4);
		tag = m_data[m_pos] & 0xf;
		if (tag == 0xf)
		{
			m_pos += 1;
			n += peekNumber(tag);
			m_pos -= 1;
		}
		return n;
	}
	void unpackHeader(uint32_t &tag, SdpPackDataType &type)
	{
		checksize(1);
		type = static_cast<SdpPackDataType>(m_data[m_pos] >> 4);
		tag = m_data[m_pos] & 0xf;
		m_pos += 1;
		if (tag == 0xf)
		{
			unpackNumber(tag);
		}
	}
	uint32_t peekNumber(uint32_t &val)
	{
		uint32_t n = 1;
		checksize(1);
		val = m_data[m_pos] & 0x7f;
		while (m_data[m_pos + n - 1] > 0x7f)
		{
			checksize(1);
			uint32_t hi = (m_data[m_pos + n] & 0x7f);
			val |= hi << (7 * n);
			++n;
		}
		return n;
	}
	void unpackNumber(uint32_t &val)
	{
		uint32_t n = peekNumber(val);
		skip(n);
	}
	uint32_t peekNumber(uint64_t &val)
	{
		uint32_t n = 1;
		checksize(1);
		val = m_data[m_pos] & 0x7f;
		while (m_data[m_pos + n - 1] > 0x7f)
		{
			checksize(1);
			uint64_t hi = (m_data[m_pos + n] & 0x7f);
			val |= hi << (7 * n);
			++n;
		}
		return n;
	}
	void unpackNumber(uint64_t &val)
	{
		uint32_t n = peekNumber(val);
		skip(n);
	}
	bool skipToTag(uint32_t tag, bool require)
	{
		uint32_t curtag;
		SdpPackDataType curtype;
		while (m_pos < m_size)
		{
			uint32_t n = peekHeader(curtag, curtype);
			if (curtype == SdpPackDataType_StructEnd || curtag > tag)
			{
				break;
			}
			if (curtag == tag)
			{
				return true;
			}
			skip(n);
			skipField(curtype);
		}
		if (require)
		{
			throwFieldNotExist();
		}
		return false;
	}
	void skipToStructEnd()
	{
		uint32_t curtag;
		SdpPackDataType curtype;
		while (true)
		{
			unpackHeader(curtag, curtype);
			if (curtype == SdpPackDataType_StructEnd)
			{
				break;
			}
			skipField(curtype);
		}
	}
	void skipField(SdpPackDataType type)
	{
		switch (type)
		{
		case SdpPackDataType_Integer_Positive:
		case SdpPackDataType_Integer_Negative:
		case SdpPackDataType_Float:
		case SdpPackDataType_Double:
			{
				uint64_t val;
				unpackNumber(val);
			}
			break;
		case SdpPackDataType_String:
			{
				uint32_t size;
				unpackNumber(size);
				skip(size);
			}
			break;
		case SdpPackDataType_Vector:
			{
				uint32_t size;
				unpackNumber(size);
				for (uint32_t i = 0; i < size; ++i)
				{
					skipField();
				}
			}
			break;
		case SdpPackDataType_Map:
			{
				uint32_t size;
				unpackNumber(size);
				for (uint32_t i = 0; i < size; ++i)
				{
					skipField();
					skipField();
				}
			}
			break;
		case SdpPackDataType_StructBegin:
			skipToStructEnd();
			break;
		case SdpPackDataType_StructEnd:
			break;
		default:
			throwUnknowDataType(type);
			break;
		}
	}
	void skipField()
	{
		uint32_t curtag;
		SdpPackDataType curtype;
		unpackHeader(curtag, curtype);
		skipField(curtype);
	}
	void throwIncompatiableType(SdpPackDataType type)
	{
		char buf[322];
		snprintf(buf, sizeof(buf), "got wrong type %d", type);
		throw SdpException(buf);
	}
	void throwFieldNotExist()
	{
		throw SdpException("field not exist");
	}
	void throwNoEnoughData()
	{
		throw SdpException("end of data");
	}
	void throwUnknowDataType(SdpPackDataType type)
	{
		char buf[322];
		snprintf(buf, sizeof(buf), "unknown type %d", type);
		throw SdpException(buf);
	}

private:
	const uint8_t 	*m_data;
	uint32_t		m_size;
	uint32_t		m_pos;
};

class SdpDisplayer
{
public:
	explicit SdpDisplayer(ostream &os, bool bWithOpt = true) : m_os(os), m_bWithOpt(bWithOpt), m_tab(0) {}

	// redirection
	template <typename T>
	void visit(uint32_t /*tag*/, bool /*require*/, const char *name, const T &val)
	{
		display(name, val);
	}

	// display interface
	template <typename T>
	void display(const T &val)
	{
		display(NULL, val);
	}

	void display(const char *name, bool val)
	{
		pf(name);
		m_os << (val ? "T" : "F") << endl;
	}
	void display(const char *name, char val)
	{
		pf(name);
		m_os << (uint8_t)val << endl;
	}
	void display(const char *name, int8_t val)
	{
		pf(name);
		m_os << val << endl;
	}
	void display(const char *name, uint8_t val)
	{
		pf(name);
		m_os << val << endl;
	}
	void display(const char *name, int16_t val)
	{
		pf(name);
		m_os << val << endl;
	}
	void display(const char *name, uint16_t val)
	{
		pf(name);
		m_os << val << endl;
	}
	void display(const char *name, int32_t val)
	{
		pf(name);
		m_os << val << endl;
	}
	void display(const char *name, uint32_t val)
	{
		pf(name);
		m_os << val << endl;
	}
	void display(const char *name, int64_t val)
	{
		pf(name);
		m_os << val << endl;
	}
	void display(const char *name, uint64_t val)
	{
		pf(name);
		m_os << val << endl;
	}
	void display(const char *name, float val)
	{
		pf(name);
		m_os << val << endl;
	}
	void display(const char *name, double val)
	{
		pf(name);
		m_os << val << endl;
	}
	void display(const char *name, const string &val)
	{
		pf(name);
		m_os << val << endl;
	}
	template <typename Alloc>
	void display(const char *name, const vector<char, Alloc> &val)
	{
		pf(name);
		m_os.write(&val[0], val.size());
		m_os << endl;
	}

	template <typename T, typename Alloc>
	void display(const char *name, const vector<T, Alloc> &val)
	{
		pf(name);
		m_os << val.size() << ", [";
		if (!val.empty())
		{
			m_os << endl;
			inctab(1);
			for (uint32_t i = 0; i < val.size(); ++i)
			{
				display(val[i]);
			}
			inctab(-1);
			tab();
		}
		m_os << "]" << endl;
	}

	template <typename T>
	void display(const char *name, const SdpVectorProxy<T> &val)
	{
		pf(name);
		m_os << val.under.size() << ", [";
		if (val.under.size() != 0)
		{
			m_os << endl;
			inctab(1);
			while (val.under.next())
			{
				val.under.visit(*this, 0, true, NULL);
			}
			inctab(-1);
			tab();
		}
		m_os << "]" << endl;
	}

	template <typename Key, typename Value, typename Compare, typename Alloc>
	void display(const char *name, const map<Key, Value, Compare, Alloc> &val)
	{
		pf(name);
		m_os << val.size() << ", {";
		if (!val.empty())
		{
			m_os << endl;
			inctab(1);
			for (typename map<Key, Value, Compare, Alloc>::const_iterator first = val.begin(), last = val.end(); first != last; ++first)
			{
				pf(NULL); m_os << "(" << endl;
				inctab(1);
				display(first->first);
				display(first->second);
				inctab(-1);
				pf(NULL); m_os << ")" << endl;
			}
			inctab(-1);
			tab();
		}
		m_os << "}" << endl;
	}

	template <typename T>
	void display(const char *name, const SdpMapProxy<T> &val)
	{
		pf(name);
		m_os << val.under.size() << ", {";
		if (val.under.size() != 0)
		{
			m_os << endl;
			inctab(1);
			while (val.under.next())
			{
				pf(NULL); m_os << "(" << endl;
				inctab(1);
				val.under.visitKey(*this, 0, true, NULL);
				val.under.visitVal(*this, 0, true, NULL);
				inctab(-1);
				pf(NULL); m_os << ")" << endl;
			}
			inctab(-1);
			tab();
		}
		m_os << "}" << endl;
	}

	template <typename T>
	void display(const char *name, const T &val)
	{
		if (m_tab == 0 && name == NULL)
		{
			val.visit(*this, m_bWithOpt);
		}
		else
		{
			pf(name); m_os << "{" << endl;
			inctab(1);
			val.visit(*this, m_bWithOpt);
			inctab(-1);
			pf(NULL); m_os << "}" << endl;
		}
	}

	template <typename T>
	void display(const char *name, const SdpStructProxy<T> &val)
	{
		if (m_tab == 0 && name == NULL)
		{
			val.under.visit(*this, m_bWithOpt);
		}
		else
		{
			pf(name); m_os << "{" << endl;
			inctab(1);
			val.under.visit(*this, m_bWithOpt);
			inctab(-1);
			pf(NULL); m_os << "}" << endl;
		}
	}

	void inctab(int32_t n)
	{
		m_tab += n;
	}

private:
	void tab()
	{
		for (uint32_t i = 0; i < m_tab; ++i)
		{
			m_os << "\t";
		}
	}
	void pf(const char *name)
	{
		tab();
		if (name)
		{
			m_os << name << ": ";
		}
	}

private:
	ostream 	&m_os;
	bool		m_bWithOpt;
	uint32_t	m_tab;
};

template <typename T>
string sdpToString(const T &t)
{
	SdpPacker packer;
	packer.pack(t);
	return packer.getData();
}

template <typename T>
void stringToSdp(const string &s, T &t)
{
	SdpUnpacker unpacker(s);
	unpacker.unpack(t);
}

template <typename T>
string printSdp(const T &t)
{
	ostringstream os;
	SdpDisplayer displayer(os);
	displayer.display(t);
	return os.str();
}

namespace assign
{

template <typename T1, typename T2>
struct sdp_assign_from_imp
{
	sdp_assign_from_imp(T1 &a, const T2 &b)
	{
		a = b;
	}
};

template <typename T1, typename T2>
void sdp_assign_from(T1 &a, const T2 &b)
{
	sdp_assign_from_imp<T1, T2>(a, b);
}

template <typename T1, typename Alloc1, typename T2, typename Alloc2>
struct sdp_assign_from_imp <vector<T1, Alloc1>, vector<T2, Alloc2> >
{
	sdp_assign_from_imp(vector<T1, Alloc1> &a, const vector<T2, Alloc2> &b)
	{
		a.resize(b.size());
		for (unsigned i = 0; i < a.size(); ++i)
		{
			sdp_assign_from(a[i], b[i]);
		}
	}
};

template <typename Key1, typename Value1, typename Compare1, typename Alloc1, typename Key2, typename Value2, typename Compare2, typename Alloc2>
struct sdp_assign_from_imp <map<Key1, Value1, Compare1, Alloc1>, map<Key2, Value2, Compare2, Alloc2> >
{
	sdp_assign_from_imp(map<Key1, Value1, Compare1, Alloc1> &a, const map<Key2, Value2, Compare2, Alloc2> &b)
	{
		a.clear();
		for (typename map<Key2, Value2, Compare2, Alloc2>::const_iterator first = b.begin(), last = b.end(); first != last; ++first)
		{
			std::pair<Key1, Value1> kv;
			sdp_assign_from(kv.first, first->first);
			sdp_assign_from(kv.second, first->second);
			a.insert(kv);
		}
	}
};

template <typename T1, typename T2>
struct sdp_assign_to_imp
{
	sdp_assign_to_imp(T1 &a, const T2 &b)
	{
		a = b;
	}
};

template <typename T1, typename T2>
void sdp_assign_to(T1 &a, const T2 &b)
{
	sdp_assign_to_imp<T1, T2>(a, b);
}


template <typename T1, typename Alloc1, typename T2, typename Alloc2>
struct sdp_assign_to_imp <vector<T1, Alloc1>, vector<T2, Alloc2> >
{
	sdp_assign_to_imp(vector<T1, Alloc1> &a, const vector<T2, Alloc2> &b)
	{
		a.resize(b.size());
		for (unsigned i = 0; i < a.size(); ++i)
		{
			sdp_assign_to(a[i], b[i]);
		}
	}
};

template <typename Key1, typename Value1, typename Compare1, typename Alloc1, typename Key2, typename Value2, typename Compare2, typename Alloc2>
struct sdp_assign_to_imp <map<Key1, Value1, Compare1, Alloc1>, map<Key2, Value2, Compare2, Alloc2> >
{
	sdp_assign_to_imp(map<Key1, Value1, Compare1, Alloc1> &a, const map<Key2, Value2, Compare2, Alloc2> &b)
	{
		a.clear();
		for (typename map<Key2, Value2, Compare2, Alloc2>::const_iterator first = b.begin(), last = b.end(); first != last; ++first)
		{
			std::pair<Key1, Value1> kv;
			sdp_assign_to(kv.first, first->first);
			sdp_assign_to(kv.second, first->second);
			a.insert(kv);
		}
	}
};

}
}

#endif
