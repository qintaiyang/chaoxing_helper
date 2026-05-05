class CryptoConfig {
  final String schildSalt;
  final String getFaceSalt;
  final String webLoginKey;
  final String sendCaptchaKey;
  final String appLoginKey;
  final String deviceCodeKey;
  final String rsaPublicKey;
  final String infEncToken;
  final String infEncKey;
  final String imKey;
  final String cxCaptchaId;
  final String tCaptchaAppId;
  final String signEncKey;
  final String cozeaKey;
  final String defaultDesKey;
  final String defaultAesKey;

  const CryptoConfig({
    required this.schildSalt,
    required this.getFaceSalt,
    required this.webLoginKey,
    required this.sendCaptchaKey,
    required this.appLoginKey,
    required this.deviceCodeKey,
    required this.rsaPublicKey,
    required this.infEncToken,
    required this.infEncKey,
    required this.imKey,
    required this.cxCaptchaId,
    required this.tCaptchaAppId,
    required this.signEncKey,
    required this.cozeaKey,
    required this.defaultDesKey,
    required this.defaultAesKey,
  });

  static const production = CryptoConfig(
    schildSalt: r'ipL$TkeiEmfy1gTXb2XHrdLN0a@7c^vu',
    getFaceSalt: 'uWwjeEKsri',
    webLoginKey: 'u2oh6Vu^HWe4_AES',
    sendCaptchaKey: 'jsDyctOCnay7uotq',
    appLoginKey: 'z4ok6lu^oWp4_AES',
    deviceCodeKey: 'QrCbNY@MuK1X8HGw',
    rsaPublicKey:
        'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC79d8Ot0hCbxxSISC6x8SCwTBspFSzlLKHJUYqoFNu1TSRaw4hEYkOnvEaL1VyoxV6HXcDrzwYvaFZaZaPQPFnfCHZy5dQwxcmifgSHqS+oKXw40Ys4cVIqnU5d90S7EWSRdBglX489jlqVaNcQSkDx2TYmC+DbAq9FV/BU09ISQIDAQAB',
    infEncToken: '4faa8662c59590c6f43ae9fe5b002b42',
    infEncKey: 'Z(AfY@XS',
    imKey: 'SL2(M/eD',
    cxCaptchaId: 'Qt9FIw9o4pwRjOyqM6yizZBh682qN2TU',
    tCaptchaAppId: '2091064951',
    signEncKey: r'P$M$rjqrtBq&#bM!',
    cozeaKey: r'2024!@#$qwePOi~',
    defaultDesKey: r'O)s$hk1D',
    defaultAesKey: '0123456789ABCDEF',
  );
}
