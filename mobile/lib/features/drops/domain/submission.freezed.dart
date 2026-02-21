// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Submission _$SubmissionFromJson(Map<String, dynamic> json) {
  return _Submission.fromJson(json);
}

/// @nodoc
mixin _$Submission {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'drop_id')
  int get dropId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'submission_url')
  String get submissionUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;
  String? get feedback => throw _privateConstructorUsedError;
  @JsonKey(name: 'submitted_at')
  DateTime get submittedAt => throw _privateConstructorUsedError;
  Drop? get drop => throw _privateConstructorUsedError;

  /// Serializes this Submission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Submission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmissionCopyWith<Submission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmissionCopyWith<$Res> {
  factory $SubmissionCopyWith(
          Submission value, $Res Function(Submission) then) =
      _$SubmissionCopyWithImpl<$Res, Submission>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'drop_id') int dropId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'submission_url') String submissionUrl,
      @JsonKey(name: 'image_url') String? imageUrl,
      String status,
      int? score,
      String? feedback,
      @JsonKey(name: 'submitted_at') DateTime submittedAt,
      Drop? drop});

  $DropCopyWith<$Res>? get drop;
}

/// @nodoc
class _$SubmissionCopyWithImpl<$Res, $Val extends Submission>
    implements $SubmissionCopyWith<$Res> {
  _$SubmissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Submission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dropId = null,
    Object? userId = null,
    Object? submissionUrl = null,
    Object? imageUrl = freezed,
    Object? status = null,
    Object? score = freezed,
    Object? feedback = freezed,
    Object? submittedAt = null,
    Object? drop = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      dropId: null == dropId
          ? _value.dropId
          : dropId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      submissionUrl: null == submissionUrl
          ? _value.submissionUrl
          : submissionUrl // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int?,
      feedback: freezed == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String?,
      submittedAt: null == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      drop: freezed == drop
          ? _value.drop
          : drop // ignore: cast_nullable_to_non_nullable
              as Drop?,
    ) as $Val);
  }

  /// Create a copy of Submission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DropCopyWith<$Res>? get drop {
    if (_value.drop == null) {
      return null;
    }

    return $DropCopyWith<$Res>(_value.drop!, (value) {
      return _then(_value.copyWith(drop: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SubmissionImplCopyWith<$Res>
    implements $SubmissionCopyWith<$Res> {
  factory _$$SubmissionImplCopyWith(
          _$SubmissionImpl value, $Res Function(_$SubmissionImpl) then) =
      __$$SubmissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'drop_id') int dropId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'submission_url') String submissionUrl,
      @JsonKey(name: 'image_url') String? imageUrl,
      String status,
      int? score,
      String? feedback,
      @JsonKey(name: 'submitted_at') DateTime submittedAt,
      Drop? drop});

  @override
  $DropCopyWith<$Res>? get drop;
}

/// @nodoc
class __$$SubmissionImplCopyWithImpl<$Res>
    extends _$SubmissionCopyWithImpl<$Res, _$SubmissionImpl>
    implements _$$SubmissionImplCopyWith<$Res> {
  __$$SubmissionImplCopyWithImpl(
      _$SubmissionImpl _value, $Res Function(_$SubmissionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Submission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dropId = null,
    Object? userId = null,
    Object? submissionUrl = null,
    Object? imageUrl = freezed,
    Object? status = null,
    Object? score = freezed,
    Object? feedback = freezed,
    Object? submittedAt = null,
    Object? drop = freezed,
  }) {
    return _then(_$SubmissionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      dropId: null == dropId
          ? _value.dropId
          : dropId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      submissionUrl: null == submissionUrl
          ? _value.submissionUrl
          : submissionUrl // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int?,
      feedback: freezed == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String?,
      submittedAt: null == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      drop: freezed == drop
          ? _value.drop
          : drop // ignore: cast_nullable_to_non_nullable
              as Drop?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmissionImpl implements _Submission {
  const _$SubmissionImpl(
      {required this.id,
      @JsonKey(name: 'drop_id') required this.dropId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'submission_url') required this.submissionUrl,
      @JsonKey(name: 'image_url') this.imageUrl,
      required this.status,
      this.score,
      this.feedback,
      @JsonKey(name: 'submitted_at') required this.submittedAt,
      this.drop});

  factory _$SubmissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmissionImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'drop_id')
  final int dropId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'submission_url')
  final String submissionUrl;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final String status;
  @override
  final int? score;
  @override
  final String? feedback;
  @override
  @JsonKey(name: 'submitted_at')
  final DateTime submittedAt;
  @override
  final Drop? drop;

  @override
  String toString() {
    return 'Submission(id: $id, dropId: $dropId, userId: $userId, submissionUrl: $submissionUrl, imageUrl: $imageUrl, status: $status, score: $score, feedback: $feedback, submittedAt: $submittedAt, drop: $drop)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dropId, dropId) || other.dropId == dropId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.submissionUrl, submissionUrl) ||
                other.submissionUrl == submissionUrl) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.drop, drop) || other.drop == drop));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, dropId, userId,
      submissionUrl, imageUrl, status, score, feedback, submittedAt, drop);

  /// Create a copy of Submission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmissionImplCopyWith<_$SubmissionImpl> get copyWith =>
      __$$SubmissionImplCopyWithImpl<_$SubmissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmissionImplToJson(
      this,
    );
  }
}

abstract class _Submission implements Submission {
  const factory _Submission(
      {required final int id,
      @JsonKey(name: 'drop_id') required final int dropId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'submission_url') required final String submissionUrl,
      @JsonKey(name: 'image_url') final String? imageUrl,
      required final String status,
      final int? score,
      final String? feedback,
      @JsonKey(name: 'submitted_at') required final DateTime submittedAt,
      final Drop? drop}) = _$SubmissionImpl;

  factory _Submission.fromJson(Map<String, dynamic> json) =
      _$SubmissionImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'drop_id')
  int get dropId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'submission_url')
  String get submissionUrl;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  String get status;
  @override
  int? get score;
  @override
  String? get feedback;
  @override
  @JsonKey(name: 'submitted_at')
  DateTime get submittedAt;
  @override
  Drop? get drop;

  /// Create a copy of Submission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmissionImplCopyWith<_$SubmissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
