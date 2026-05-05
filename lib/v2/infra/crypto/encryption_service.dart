import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/export.dart';
import 'package:convert/convert.dart';
import 'package:uuid/uuid.dart';
import 'crypto_config.dart';

class EncryptionService {
  final CryptoConfig _config;

  EncryptionService(this._config);

  String aesCbcEncrypt(String text, String key) {
    final keyObj = encrypt.Key.fromUtf8(key);
    final iv = encrypt.IV.fromUtf8(key);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(keyObj, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  String aesEcbEncrypt(String text, String key) {
    final keyObj = encrypt.Key.fromUtf8(key);
    final iv = encrypt.IV.fromLength(0);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(keyObj, mode: encrypt.AESMode.ecb, padding: 'PKCS7'),
    );
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  String aesEcbDecrypt(String base64Cipher, String key) {
    final keyObj = encrypt.Key.fromUtf8(key);
    final iv = encrypt.IV.fromLength(0);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(keyObj, mode: encrypt.AESMode.ecb, padding: 'PKCS7'),
    );
    return encrypter.decrypt64(base64Cipher, iv: iv);
  }

  String aesEcbEncryptHex(String text, String key) {
    final keyObj = encrypt.Key.fromUtf8(key);
    final iv = encrypt.IV.fromLength(0);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(keyObj, mode: encrypt.AESMode.ecb, padding: 'PKCS7'),
    );
    final encrypted = encrypter.encrypt(text, iv: iv);
    return hex.encode(encrypted.bytes);
  }

  String aesEcbDecryptHex(String hexCipher, String key) {
    final keyObj = encrypt.Key.fromUtf8(key);
    final iv = encrypt.IV.fromLength(0);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(keyObj, mode: encrypt.AESMode.ecb, padding: 'PKCS7'),
    );
    final cipherBytes = Uint8List.fromList(hex.decode(hexCipher));
    final encrypted = encrypt.Encrypted(cipherBytes);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  String desEcbDecrypt(String hexCipher, String key) {
    final cipherBytes = Uint8List.fromList(hex.decode(hexCipher));
    final keyBytes = utf8.encode(key);
    final extendedKey = Uint8List(24);
    for (int i = 0; i < 3; i++) {
      extendedKey.setRange(i * 8, i * 8 + 8, keyBytes);
    }
    final desEngine = DESedeEngine();
    final ecbCipher = ECBBlockCipher(desEngine);
    ecbCipher.init(false, KeyParameter(extendedKey));
    final decrypted = Uint8List(cipherBytes.length);
    var offset = 0;
    while (offset < cipherBytes.length) {
      final processed = ecbCipher.processBlock(
        cipherBytes,
        offset,
        decrypted,
        offset,
      );
      offset += processed;
    }
    final paddedLength = decrypted.length;
    final padValue = decrypted[paddedLength - 1];
    final actualLength = paddedLength - padValue;
    return utf8.decode(decrypted.sublist(0, actualLength));
  }

  String desEcbEncrypt(String text, String key) {
    final keyBytes = utf8.encode(key);
    final extendedKey = Uint8List(24);
    for (int i = 0; i < 3; i++) {
      extendedKey.setRange(i * 8, i * 8 + 8, keyBytes);
    }
    final desEngine = DESedeEngine();
    final ecbCipher = ECBBlockCipher(desEngine);
    ecbCipher.init(true, KeyParameter(extendedKey));
    final data = utf8.encode(text);
    final padLen = 8 - (data.length % 8);
    final paddedData = Uint8List(data.length + padLen);
    paddedData.setRange(0, data.length, data);
    for (int i = data.length; i < paddedData.length; i++) {
      paddedData[i] = padLen;
    }
    final encrypted = Uint8List(paddedData.length);
    var offset = 0;
    while (offset < paddedData.length) {
      final processed = ecbCipher.processBlock(
        paddedData,
        offset,
        encrypted,
        offset,
      );
      offset += processed;
    }
    return hex.encode(encrypted);
  }

  String rsaEncrypt(String text, String publicKeyBase64) {
    final keyDer = base64.decode(publicKeyBase64);
    final asn1Parser = ASN1Parser(Uint8List.fromList(keyDer));
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    final asn1Objects = topLevelSeq.elements!;
    final bitString = asn1Objects[1] as ASN1BitString;
    final publicKeyBytes = bitString.valueBytes!.sublist(1);
    final publicKeyParser = ASN1Parser(Uint8List.fromList(publicKeyBytes));
    final publicKeySeq = publicKeyParser.nextObject() as ASN1Sequence;
    final publicKeyElements = publicKeySeq.elements!;
    final modulusBigInt = (publicKeyElements[0] as ASN1Integer).integer!;
    final exponentBigInt = (publicKeyElements[1] as ASN1Integer).integer!;
    final publicKey = RSAPublicKey(modulusBigInt, exponentBigInt);
    final keyLength = (publicKey.modulus!.bitLength + 7) ~/ 8;
    final maxChunkSize = keyLength - 11;
    final plainBytes = Uint8List.fromList(utf8.encode(text));
    final encryptedChunks = <Uint8List>[];
    for (int i = 0; i < plainBytes.length; i += maxChunkSize) {
      final end = (i + maxChunkSize) < plainBytes.length
          ? i + maxChunkSize
          : plainBytes.length;
      final chunk = plainBytes.sublist(i, end);
      final cipher = PKCS1Encoding(RSAEngine());
      cipher.init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
      encryptedChunks.add(cipher.process(chunk));
    }
    final totalLen = encryptedChunks.fold(
      0,
      (sum, chunk) => sum + chunk.length,
    );
    final allEncrypted = Uint8List(totalLen);
    int offset = 0;
    for (final chunk in encryptedChunks) {
      allEncrypted.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return base64.encode(allEncrypted);
  }

  String md5Hash(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  String signEnc(String data, {String? time}) {
    final t = time ?? _formatDateTime(DateTime.now());
    return md5Hash('[$data][${_config.signEncKey}][$t]');
  }

  String cozeaEnc(String courseId, {String isStudent = '1'}) {
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    return md5Hash('$courseId&$isStudent&$ts${_config.cozeaKey}');
  }

  String getUniqueId() {
    return getUuid().replaceAll('-', '');
  }

  String getDeviceCode() {
    final oaid = getUuid();
    return aesEcbEncrypt(oaid, _config.deviceCodeKey);
  }

  String calcCourseSettingEnc(String courseId, {bool isStudent = false}) {
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    return md5Hash(
      '$courseId&${isStudent.toString().toLowerCase()}&${ts}2024!@#\$qwePOi~',
    );
  }

  Map<String, String> getCourseSettingEncParams(
    String courseId,
    String classId, {
    bool isStudent = false,
  }) {
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    final enc = md5Hash(
      '$courseId&${isStudent.toString().toLowerCase()}&${ts}2024!@#\$qwePOi~',
    );
    return {
      'ut': '2',
      'clazzId': classId,
      'courseId': courseId,
      'isStudent': isStudent.toString().toLowerCase(),
      'timestamp': ts,
      'enc': enc,
    };
  }

  Map<String, String> getDomainConfigEncParams(String domain) {
    final ts = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final enc = md5Hash('$domain${ts}2024!@#\$qwePOi~');
    return {'domain': domain, 't': ts, 'v': '1', 'enc': enc};
  }

  Map<String, String> getEncParams(Map<String, String> params) {
    final encParams = <String, String>{
      '_c_0_': getUniqueId(),
      'token': _config.infEncToken,
      '_time': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    params.addAll(encParams);
    final queryString = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
    encParams['inf_enc'] = md5Hash('$queryString&DESKey=${_config.infEncKey}');
    return encParams;
  }

  String getUuid() {
    return const Uuid().v4();
  }

  Future<String> getCRC(File file) async {
    final totalSize = await file.length();
    final raf = await file.open();
    try {
      List<int> bytesToHash;
      if (totalSize > 1048576) {
        final first = await raf.read(524288);
        await raf.setPosition(totalSize - 524288);
        final last = await raf.read(524288);
        bytesToHash = [...first, ...last];
      } else {
        bytesToHash = List<int>.from(await raf.read(totalSize));
      }
      final sizeHex = totalSize.toRadixString(16);
      bytesToHash.addAll(utf8.encode(sizeHex));
      final digest = md5.convert(bytesToHash);
      return digest.bytes
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();
    } finally {
      await raf.close();
    }
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}'
        '${dt.month.toString().padLeft(2, '0')}'
        '${dt.day.toString().padLeft(2, '0')}'
        '${dt.hour.toString().padLeft(2, '0')}'
        '${dt.minute.toString().padLeft(2, '0')}'
        '${dt.second.toString().padLeft(2, '0')}';
  }
}
