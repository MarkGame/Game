#ifndef _MFW_UTIL_AES_
#define _MFW_UTIL_AES_

#include <string>
using namespace std;

extern unsigned char MsgEncryptKey[16];

namespace mfw
{

class UtilAES
{
public:
    static string aes_encrypt(const string &sData, const string &sKey);
    static string aes_decrypt(const string &sData, const string &sKey);

    static bool aes_encrypt(const string &sData, const string &sKey, string &sResult);
    static bool aes_decrypt(const string &sData, const string &sKey, string &sResult);
    static bool aes_encrypt(const char *pBegin, const char *pEnd, const string &sKey, string &sResult);
    static bool aes_decrypt(const char *pBegin, const char *pEnd, const string &sKey, string &sResult);
};

}

#endif
