import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') String? fullName,
    String? bio,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default({})
    @JsonKey(name: 'social_links')
    Map<String, dynamic> socialLinks,
    @JsonKey(name: 'upi_id') String? upiId,
    @Default(0) @JsonKey(name: 'total_xp') int totalXp,
    @Default(1) int level,
    @Default({})
    @JsonKey(name: 'xp_breakdown')
    Map<String, dynamic> xpBreakdown,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
