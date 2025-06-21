class ExternalSignerTool {
  //

  static Future<String?> getPubKey() async {}

  static Future<Map<String, String>?> signEvent(String eventJson, String id, String current_user) async {}

  ///sign_message
  static Future<Map<String, String>?> signMessage(String eventJson, String id, String current_user) async {
  }


  static Future<Map<String, String>?> nip04Encrypt(String plaintext, String id, String current_user, String pubKey) async {

  }


  static Future<Map<String, String>?> nip44Encrypt(String plaintext, String id, String current_user, String pubKey) async {
  }


  static Future<Map<String, String>?> nip04Decrypt(String encryptedText, String id, String current_user, String pubKey) async {
  }


  static Future<Map<String, String>?> nip44Decrypt(String encryptedText, String id, String current_user, String pubKey) async {

  }


  static Future<Map<String, String>?> decryptZapEvent(String encryptedText, String id, String current_user) async {

  }
}

enum SignerType {
  SIGN_EVENT,
  SIGN_MESSAGE,
  NIP04_ENCRYPT,
  NIP04_DECRYPT,
  NIP44_ENCRYPT,
  NIP44_DECRYPT,
  GET_PUBLIC_KEY,
  DECRYPT_ZAP_EVENT,
}

extension SignerTypeEx on SignerType {
  String get name {
    switch (this) {
      case SignerType.GET_PUBLIC_KEY:
        return 'get_public_key';
      case SignerType.SIGN_EVENT:
        return 'sign_event';
      case SignerType.SIGN_MESSAGE:
        return 'sign_message';
      case SignerType.NIP04_ENCRYPT:
        return 'nip04_encrypt';
      case SignerType.NIP04_DECRYPT:
        return 'nip04_decrypt';
      case SignerType.NIP44_ENCRYPT:
        return 'nip44_encrypt';
      case SignerType.NIP44_DECRYPT:
        return 'nip44_decrypt';
      case SignerType.DECRYPT_ZAP_EVENT:
        return 'decrypt_zap_event';
    }
  }

  int get requestCode {
    switch (this) {
      case SignerType.GET_PUBLIC_KEY:
        return 101;
      case SignerType.SIGN_EVENT:
        return 102;
      case SignerType.NIP04_ENCRYPT:
        return 103;
      case SignerType.NIP04_DECRYPT:
        return 104;
      case SignerType.NIP44_ENCRYPT:
        return 105;
      case SignerType.NIP44_DECRYPT:
        return 106;
      case SignerType.DECRYPT_ZAP_EVENT:
        return 107;
      case SignerType.SIGN_MESSAGE:
        return 108;
    }
  }
}
