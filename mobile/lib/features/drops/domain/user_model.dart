import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') String? fullName,
    String? bio,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'upi_id') String? upiId,
    @JsonKey(name: 'social_links') Map<String, dynamic>? socialLinks,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    @JsonKey(name: 'total_xp') required int totalXp,
    required int level,
    @JsonKey(name: 'completed_drops') required int completedDrops,
    required String rank,
    @JsonKey(name: 'xp_breakdown')
    @Default({})
    Map<String, dynamic> xpBreakdown,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}
