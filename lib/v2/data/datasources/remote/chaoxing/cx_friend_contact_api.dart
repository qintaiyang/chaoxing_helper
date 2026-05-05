import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../../infra/network/dio_client.dart';

class _Sig {
  static const key = 'Z(AfY@XS';
  static const token = '4faa8662c59590c6f43ae9fe5b002b42';
  static const learn = 'https://learn.chaoxing.com';
}

String _urlEncode(String v) {
  const r =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~';
  final b = StringBuffer();
  for (var i = 0; i < v.length; i++) {
    final c = v[i];
    if (r.contains(c)) {
      b.write(c);
    } else {
      for (var bt in utf8.encode(c)) {
        b.write('%${bt.toRadixString(16).toUpperCase().padLeft(2, '0')}');
      }
    }
  }
  return b.toString();
}

String _md5(String s) => md5.convert(utf8.encode(s)).toString();
String _uuid() => const Uuid().v4().replaceAll('-', '');

String _infEnc(Map<String, dynamic> p, String uid, int ts) {
  final o = [
    ...p.entries,
    MapEntry('_c_0_', uid),
    const MapEntry('token', _Sig.token),
    MapEntry('_time', ts.toString()),
  ];
  final parts = o
      .where((e) => e.value != null)
      .map((e) => '${e.key}=${_urlEncode(e.value.toString())}')
      .toList();
  parts.add('DESKey=${_Sig.key}');
  return _md5(parts.join('&'));
}

class FollowerInfo {
  final int puid;
  final int uid;
  final String name;
  final String pic;
  final String alias;
  final String fullPinyin;
  final String simplePinyin;
  final String schoolName;
  final int sex;
  final int eachother;
  final int status;
  final int fid;
  final int rights;
  final int topsign;
  final String uname;
  final int insertTime;

  const FollowerInfo({
    required this.puid,
    required this.uid,
    required this.name,
    required this.pic,
    required this.alias,
    required this.fullPinyin,
    required this.simplePinyin,
    required this.schoolName,
    required this.sex,
    required this.eachother,
    required this.status,
    required this.fid,
    required this.rights,
    required this.topsign,
    required this.uname,
    required this.insertTime,
  });

  factory FollowerInfo.fromJson(Map<String, dynamic> json) {
    return FollowerInfo(
      puid: json['puid'] ?? 0,
      uid: json['uid'] ?? 0,
      name: json['name'] ?? '',
      pic: json['pic'] ?? '',
      alias: json['alias'] ?? '',
      fullPinyin: json['fullpinyin'] ?? '',
      simplePinyin: json['simplepinyin'] ?? '',
      schoolName: json['schoolname'] ?? '',
      sex: json['sex'] ?? -1,
      eachother: json['eachother'] ?? 0,
      status: json['status'] ?? 0,
      fid: json['fid'] ?? 0,
      rights: json['rights'] ?? 0,
      topsign: json['topsign'] ?? 0,
      uname: json['uname'] ?? '',
      insertTime: json['insertTime'] ?? 0,
    );
  }
}

class CXFriendContactApi {
  final AppDioClient _client;
  CXFriendContactApi(this._client);

  Future<Map<String, dynamic>?> _call(
    String path,
    String? puid, {
    Map<String, dynamic>? extra,
  }) async {
    try {
      final ts = DateTime.now().millisecondsSinceEpoch;
      final uid = _uuid();
      final params = <String, dynamic>{
        if (puid != null && puid.isNotEmpty) 'puid': puid,
        if (extra != null) ...extra,
      };
      final infEnc = _infEnc(params, uid, ts);
      final url = '${_Sig.learn}$path';
      final response = await _client.sendRequest(
        url,
        params: {
          ...params.map((k, v) => MapEntry(k, v.toString())),
          '_c_0_': uid,
          'token': _Sig.token,
          '_time': ts.toString(),
          'inf_enc': infEnc,
        },
        headers: {'X-Requested-With': 'XMLHttpRequest'},
      );
      return response.data is Map
          ? response.data as Map<String, dynamic>
          : null;
    } catch (e) {
      debugPrint('CXFriendContactApi._call error ($path): $e');
      return null;
    }
  }

  Future<List<FollowerInfo>> getFollowers({
    String isfollower = '1',
    String topsign = '-1',
    int page = 1,
    int pageSize = 9000,
    String isPull = '1',
  }) async {
    final result = await _call(
      '/v2apis/friend/getFollowers',
      '',
      extra: {
        'isfollower': isfollower,
        'topsign': topsign,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        'isPull': isPull,
      },
    );

    if (result != null && result['result'] == 1) {
      final data = result['data'];
      if (data is Map<String, dynamic>) {
        final list = data['list'];
        if (list is List) {
          return list.map((item) => FollowerInfo.fromJson(item)).toList();
        }
      }
    }
    return [];
  }

  Future<Map<String, dynamic>?> createContactCode({
    required String puid,
    required String code,
    String latitude = '0',
    String longitude = '0',
  }) => _call(
    '/apis/contact/createContactCode',
    puid,
    extra: {'code': code, 'latitude': latitude, 'longitude': longitude},
  );

  Future<Map<String, dynamic>?> faceToFaceResult({
    required String puid,
    required String code,
  }) => _call('/apis/contact/faceToFaceResult', puid, extra: {'code': code});

  Future<Map<String, dynamic>?> faceToFaceJoinGroup({
    required String puid,
    required String code,
    required String enc,
  }) => _call(
    '/apis/contact/faceToFaceJoinGroup',
    puid,
    extra: {'code': code, 'enc': enc},
  );
}
