import 'enums.dart';

class Active {
  final int type;
  final String id;
  final String name;
  final String description;
  final int startTime;
  final String url;
  final int attendNum;
  final bool status;
  final Map<String, dynamic>? extras;
  final SignType? signType;

  const Active({
    required this.type,
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.url,
    required this.attendNum,
    required this.status,
    this.extras,
    this.signType,
  });

  Active copyWith({
    int? type,
    String? id,
    String? name,
    String? description,
    int? startTime,
    String? url,
    int? attendNum,
    bool? status,
    Map<String, dynamic>? extras,
    SignType? signType,
  }) {
    return Active(
      type: type ?? this.type,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      url: url ?? this.url,
      attendNum: attendNum ?? this.attendNum,
      status: status ?? this.status,
      extras: extras ?? this.extras,
      signType: signType ?? this.signType,
    );
  }

  ActiveType get activeType => ActiveType.fromValue(type) ?? ActiveType.signIn;
}
