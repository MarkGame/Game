#include "util_crypto.h"

namespace mfw
{

bool UtilCrypto::cbc_encrypt(const char *pBegin, const char *pEnd, block_encrypt_func encrypt_func, int iBlockSize, void *ctx, string &sResult)
{
	unsigned char buf[32] = { 0 };
	if (iBlockSize < 8 || iBlockSize > (int)sizeof(buf))
	{
		return false;
	}

	int iDataSize = pEnd - pBegin;
	int rem = iDataSize % iBlockSize;
	if (rem == 0)
	{
		sResult.reserve(sResult.size() + iDataSize);
	}
	else
	{
		sResult.reserve(sResult.size() + iDataSize - rem + iBlockSize + 1);
	}

	for (const char *r = pBegin; r < pEnd; r += iBlockSize)
	{
		int len = std::min(iBlockSize, (int)(pEnd - r));
		for (int i = 0; i < len; ++i)
		{
			buf[i] = *(r + i) ^ buf[i];
		}
		encrypt_func(ctx, buf, buf);
		sResult.append(buf, buf + iBlockSize);
	}
	if (rem != 0)
	{
		sResult.append(1, rem);
	}
	return true;
}

bool UtilCrypto::cbc_decrypt(const char *pBegin, const char *pEnd, block_decrypt_func decrypt_func, int iBlockSize, void *ctx, string &sResult)
{
	unsigned char buf[32] = { 0 };
	if (iBlockSize < 8 || iBlockSize > (int)sizeof(buf))
	{
		return false;
	}

	int iDataSize = pEnd - pBegin;
	int rem = iDataSize % iBlockSize;
	if (rem == 0)
	{
		sResult.reserve(sResult.size() + iDataSize);
	}
	else if (rem == 1)
	{
		if (iDataSize < iBlockSize + 1)
		{
			return false;
		}
		rem = *(pEnd - 1);
		if (rem <= 0 || rem >= iBlockSize)
		{
			return false;
		}
		sResult.reserve(sResult.size() + iDataSize - iBlockSize - 1 + rem);
		--pEnd;
	}
	else
	{
		return false;
	}

	for (const char *r = pBegin; r < pEnd; r += iBlockSize)
	{
		decrypt_func(ctx, r, buf);
		if (r != pBegin)
		{
			for (int i = 0; i < iBlockSize; ++i)
			{
				buf[i] ^= *(r - iBlockSize + i);
			}
		}
		if (rem != 0 && r + iBlockSize >= pEnd)
		{
			sResult.append(buf, buf + rem);
		}
		else
		{
			sResult.append(buf, buf + iBlockSize);
		}
	}
	return true;
}

bool UtilCrypto::cbc_encrypt(const string &sData, block_encrypt_func encrypt_func, int iBlockSize, void *ctx, string &sResult)
{
	return cbc_encrypt(sData.c_str(), sData.c_str() + sData.size(), encrypt_func, iBlockSize, ctx, sResult);
}

bool UtilCrypto::cbc_decrypt(const string &sData, block_decrypt_func decrypt_func, int iBlockSize, void *ctx, string &sResult)
{
	return cbc_decrypt(sData.c_str(), sData.c_str() + sData.size(), decrypt_func, iBlockSize, ctx, sResult);
}

}
