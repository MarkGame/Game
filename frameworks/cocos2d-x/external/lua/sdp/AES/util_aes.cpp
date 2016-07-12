#include "util_aes.h"
#include "util_crypto.h"
#include "aes.h"
#include <stdexcept>

// refrer: http://www.aescrypt.com/download
unsigned char MsgEncryptKey[16] = { 0xf5, 0xa1, 0x93, 0xd5, 0x0a, 0xde, 0x55, 0x3e, 0x98, 0x35, 0x59, 0x5f, 0x5c, 0xd7, 0x5d, 0xdd };

namespace mfw
{

string UtilAES::aes_encrypt(const string &sData, const string &sKey)
{
	string sResult;
	if (!aes_encrypt(sData, sKey, sResult))
	{
		throw std::runtime_error("aes encrypt");
	}
	return sResult;
}

string UtilAES::aes_decrypt(const string &sData, const string &sKey)
{
	string sResult;
	if (!aes_decrypt(sData, sKey, sResult))
	{
		throw std::runtime_error("aes decrypt");
	}
	return sResult;
}

bool UtilAES::aes_encrypt(const string &sData, const string &sKey, string &sResult)
{
	return aes_encrypt(sData.c_str(), sData.c_str() + sData.size(), sKey, sResult);
}

bool UtilAES::aes_decrypt(const string &sData, const string &sKey, string &sResult)
{
	return aes_decrypt(sData.c_str(), sData.c_str() + sData.size(), sKey, sResult);
}

bool UtilAES::aes_encrypt(const char *pBegin, const char *pEnd, const string &sKey, string &sResult)
{
	aes_context ctx;
	if (aes_set_key(&ctx, (unsigned char *)sKey.c_str(), sKey.size() * 8) != 0)
	{
		return false;
	}

	return UtilCrypto::cbc_encrypt(pBegin, pEnd, (UtilCrypto::block_encrypt_func)::aes_encrypt, 16, &ctx, sResult);
}

bool UtilAES::aes_decrypt(const char *pBegin, const char *pEnd, const string &sKey, string &sResult)
{
	aes_context ctx;
	if (aes_set_key(&ctx, (unsigned char *)sKey.c_str(), sKey.size() * 8) != 0)
	{
		return false;
	}

	return UtilCrypto::cbc_decrypt(pBegin, pEnd, (UtilCrypto::block_decrypt_func)::aes_decrypt, 16, &ctx, sResult);
}

}
