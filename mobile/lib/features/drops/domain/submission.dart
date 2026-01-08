import 'package:freezed_annotation/freezed_annotation.dart';

part 'submission.freezed.dart';
part 'submission.g.dart';

@freezed
class Submission with _$Submission {
  const factory Submission({
    required int id,
    @JsonKey(name: 'drop_id') required int dropId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'submission_url') required String submissionUrl,
    required String status,
    int? score,
    String? feedback,
    @JsonKey(name: 'submitted_at') required DateTime submittedAt,
  }) = _Submission;

  factory Submission.fromJson(Map<String, dynamic> json) =>
      _$SubmissionFromJson(json);
}
