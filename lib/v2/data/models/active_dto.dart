import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_dto.freezed.dart';
part 'active_dto.g.dart';

@Freezed(fromJson: true, toJson: true)
class ActiveDto with _$ActiveDto {
  const factory ActiveDto({
    @Default(0) int type,
    @Default('') String id,
    @Default('') String name,
    @Default('') String description,
    @Default(0) int startTime,
    @Default('') String url,
    @Default(0) int attendNum,
    @Default(false) bool status,
    @Default({}) Map<String, dynamic> extras,
    @Default(0) int signType,
  }) = _ActiveDto;

  factory ActiveDto.fromJson(Map<String, dynamic> json) {
    final activeType = json['activeType'] is int
        ? json['activeType'] as int
        : int.tryParse(json['activeType']?.toString() ?? '0') ?? 0;

    return ActiveDto(
      type: activeType,
      id: json['id'].toString(),
      name: json['nameOne']?.toString() ?? '',
      description: json['nameTwo']?.toString() ?? '',
      startTime: json['startTime'] as int? ?? 0,
      url: json['url']?.toString() ?? '',
      attendNum: json['attendNum'] as int? ?? 0,
      status: json['status'] == 1,
      extras: json['extraInfo'] as Map<String, dynamic>? ?? {},
    );
  }
}
