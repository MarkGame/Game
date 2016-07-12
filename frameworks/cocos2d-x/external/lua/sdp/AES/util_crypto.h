#ifndef _MFW_UTIL_CRYPTO_
#define _MFW_UTIL_CRYPTO_

#include <string>
using namespace std;

namespace mfw
{

class UtilCrypto
{
public:
	typedef void (*block_encrypt_func)(void *ctx, const void *input, void *output);
	typedef void (*block_decrypt_func)(void *ctx, const void *input, void *output);

	static bool cbc_encrypt(const char *pBegin, const char *pEnd, block_encrypt_func encrypt_func, int iBlockSize, void *ctx, string &sResult);
	static bool cbc_decrypt(const char *pBegin, const char *pEnd, block_decrypt_func decrypt_func, int iBlockSize, void *ctx, string &sResult);

	static bool cbc_encrypt(const string &sData, block_encrypt_func encrypt_func, int iBlockSize, void *ctx, string &sResult);
	static bool cbc_decrypt(const string &sData, block_decrypt_func decrypt_func, int iBlockSize, void *ctx, string &sResult);
};

}

#endif
