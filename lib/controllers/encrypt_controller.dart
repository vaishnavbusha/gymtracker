import 'package:encrypt/encrypt.dart';

class EncryptController {
  // static var _key;
  // static var _iv;
  // EncryptController() {

  // }
  // static final _key =
  //     Key.fromUtf8('dcwNmFMx71L5m2w3JmLZX4IUQFjfzDOuhLUBMqBiRfI=');
  // static final _iv =
  //     IV.fromUtf8('CJt52VyjsQB6If6G/WNb2rCf+ZjWjQeMynrcyjV19Mg=');
  static final _key = Key.fromLength(32);
  static final _iv = IV.fromLength(16);
  static encryptData(String data) {
    final encrypter = Encrypter(AES(_key));
    final encrypteData = encrypter.encrypt(data, iv: _iv);
    return encrypteData.base64;
  }

  static decryptData(String encryptedData) {
    final encrypter = Encrypter(AES(_key));
    final decryptedData =
        encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: _iv);
    return decryptedData;
  }
}
