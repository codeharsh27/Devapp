import 'package:freezed_annotation/freezed_annotation.dart';

part 'drop.freezed.dart';
part 'drop.g.dart';

@freezed
class Drop with _$Drop {
  const factory Drop({
    required int id,
    required String title,
    required String description,
    required String domain,
    required String difficulty,
    @JsonKey(name: 'time_limit_minutes') required int timeLimitMinutes,
    @JsonKey(name: 'reward_xp') required int rewardXp,
    @JsonKey(name: 'inputs_url') String? inputsUrl,
  }) = _Drop;

  factory Drop.fromJson(Map<String, dynamic> json) => _$DropFromJson(json);
}
