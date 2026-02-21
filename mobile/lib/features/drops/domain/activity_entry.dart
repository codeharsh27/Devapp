import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_entry.freezed.dart';
part 'activity_entry.g.dart';

@freezed
class ActivityEntry with _$ActivityEntry {
  const factory ActivityEntry({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'user_avatar') String? userAvatar,
    @JsonKey(name: 'drop_title') required String dropTitle,
    @JsonKey(name: 'drop_domain') String? dropDomain,
    @JsonKey(name: 'completed_at') required DateTime completedAt,
    @JsonKey(name: 'xp_earned') required int xpEarned,
  }) = _ActivityEntry;

  factory ActivityEntry.fromJson(Map<String, dynamic> json) =>
      _$ActivityEntryFromJson(json);
}
