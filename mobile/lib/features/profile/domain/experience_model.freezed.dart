// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'experience_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Experience _$ExperienceFromJson(Map<String, dynamic> json) {
  return _Experience.fromJson(json);
}

/// @nodoc
mixin _$Experience {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'experience_type')
  String get experienceType => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get contributions => throw _privateConstructorUsedError;
  @JsonKey(name: 'tech_stack')
  List<String> get techStack => throw _privateConstructorUsedError;
  @JsonKey(name: 'project_url')
  String? get projectUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_current')
  bool get isCurrent => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_featured')
  bool get isFeatured => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order')
  int get displayOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Experience to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExperienceCopyWith<Experience> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExperienceCopyWith<$Res> {
  factory $ExperienceCopyWith(
          Experience value, $Res Function(Experience) then) =
      _$ExperienceCopyWithImpl<$Res, Experience>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') String userId,
      String title,
      String? role,
      @JsonKey(name: 'experience_type') String experienceType,
      String? description,
      List<String> contributions,
      @JsonKey(name: 'tech_stack') List<String> techStack,
      @JsonKey(name: 'project_url') String? projectUrl,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'start_date') DateTime? startDate,
      @JsonKey(name: 'end_date') DateTime? endDate,
      @JsonKey(name: 'is_current') bool isCurrent,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'is_featured') bool isFeatured,
      @JsonKey(name: 'display_order') int displayOrder,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$ExperienceCopyWithImpl<$Res, $Val extends Experience>
    implements $ExperienceCopyWith<$Res> {
  _$ExperienceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? role = freezed,
    Object? experienceType = null,
    Object? description = freezed,
    Object? contributions = null,
    Object? techStack = null,
    Object? projectUrl = freezed,
    Object? imageUrl = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCurrent = null,
    Object? isVerified = null,
    Object? isFeatured = null,
    Object? displayOrder = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceType: null == experienceType
          ? _value.experienceType
          : experienceType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      contributions: null == contributions
          ? _value.contributions
          : contributions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      techStack: null == techStack
          ? _value.techStack
          : techStack // ignore: cast_nullable_to_non_nullable
              as List<String>,
      projectUrl: freezed == projectUrl
          ? _value.projectUrl
          : projectUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrent: null == isCurrent
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExperienceImplCopyWith<$Res>
    implements $ExperienceCopyWith<$Res> {
  factory _$$ExperienceImplCopyWith(
          _$ExperienceImpl value, $Res Function(_$ExperienceImpl) then) =
      __$$ExperienceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') String userId,
      String title,
      String? role,
      @JsonKey(name: 'experience_type') String experienceType,
      String? description,
      List<String> contributions,
      @JsonKey(name: 'tech_stack') List<String> techStack,
      @JsonKey(name: 'project_url') String? projectUrl,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'start_date') DateTime? startDate,
      @JsonKey(name: 'end_date') DateTime? endDate,
      @JsonKey(name: 'is_current') bool isCurrent,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'is_featured') bool isFeatured,
      @JsonKey(name: 'display_order') int displayOrder,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$ExperienceImplCopyWithImpl<$Res>
    extends _$ExperienceCopyWithImpl<$Res, _$ExperienceImpl>
    implements _$$ExperienceImplCopyWith<$Res> {
  __$$ExperienceImplCopyWithImpl(
      _$ExperienceImpl _value, $Res Function(_$ExperienceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? role = freezed,
    Object? experienceType = null,
    Object? description = freezed,
    Object? contributions = null,
    Object? techStack = null,
    Object? projectUrl = freezed,
    Object? imageUrl = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCurrent = null,
    Object? isVerified = null,
    Object? isFeatured = null,
    Object? displayOrder = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ExperienceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceType: null == experienceType
          ? _value.experienceType
          : experienceType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      contributions: null == contributions
          ? _value._contributions
          : contributions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      techStack: null == techStack
          ? _value._techStack
          : techStack // ignore: cast_nullable_to_non_nullable
              as List<String>,
      projectUrl: freezed == projectUrl
          ? _value.projectUrl
          : projectUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrent: null == isCurrent
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExperienceImpl implements _Experience {
  const _$ExperienceImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.title,
      this.role,
      @JsonKey(name: 'experience_type') this.experienceType = 'project',
      this.description,
      final List<String> contributions = const [],
      @JsonKey(name: 'tech_stack') final List<String> techStack = const [],
      @JsonKey(name: 'project_url') this.projectUrl,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'start_date') this.startDate,
      @JsonKey(name: 'end_date') this.endDate,
      @JsonKey(name: 'is_current') this.isCurrent = false,
      @JsonKey(name: 'is_verified') this.isVerified = false,
      @JsonKey(name: 'is_featured') this.isFeatured = false,
      @JsonKey(name: 'display_order') this.displayOrder = 0,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _contributions = contributions,
        _techStack = techStack;

  factory _$ExperienceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExperienceImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String title;
  @override
  final String? role;
  @override
  @JsonKey(name: 'experience_type')
  final String experienceType;
  @override
  final String? description;
  final List<String> _contributions;
  @override
  @JsonKey()
  List<String> get contributions {
    if (_contributions is EqualUnmodifiableListView) return _contributions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contributions);
  }

  final List<String> _techStack;
  @override
  @JsonKey(name: 'tech_stack')
  List<String> get techStack {
    if (_techStack is EqualUnmodifiableListView) return _techStack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_techStack);
  }

  @override
  @JsonKey(name: 'project_url')
  final String? projectUrl;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @override
  @JsonKey(name: 'is_current')
  final bool isCurrent;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @override
  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  @override
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Experience(id: $id, userId: $userId, title: $title, role: $role, experienceType: $experienceType, description: $description, contributions: $contributions, techStack: $techStack, projectUrl: $projectUrl, imageUrl: $imageUrl, startDate: $startDate, endDate: $endDate, isCurrent: $isCurrent, isVerified: $isVerified, isFeatured: $isFeatured, displayOrder: $displayOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExperienceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.experienceType, experienceType) ||
                other.experienceType == experienceType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._contributions, _contributions) &&
            const DeepCollectionEquality()
                .equals(other._techStack, _techStack) &&
            (identical(other.projectUrl, projectUrl) ||
                other.projectUrl == projectUrl) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isCurrent, isCurrent) ||
                other.isCurrent == isCurrent) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      role,
      experienceType,
      description,
      const DeepCollectionEquality().hash(_contributions),
      const DeepCollectionEquality().hash(_techStack),
      projectUrl,
      imageUrl,
      startDate,
      endDate,
      isCurrent,
      isVerified,
      isFeatured,
      displayOrder,
      createdAt,
      updatedAt);

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExperienceImplCopyWith<_$ExperienceImpl> get copyWith =>
      __$$ExperienceImplCopyWithImpl<_$ExperienceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExperienceImplToJson(
      this,
    );
  }
}

abstract class _Experience implements Experience {
  const factory _Experience(
          {required final int id,
          @JsonKey(name: 'user_id') required final String userId,
          required final String title,
          final String? role,
          @JsonKey(name: 'experience_type') final String experienceType,
          final String? description,
          final List<String> contributions,
          @JsonKey(name: 'tech_stack') final List<String> techStack,
          @JsonKey(name: 'project_url') final String? projectUrl,
          @JsonKey(name: 'image_url') final String? imageUrl,
          @JsonKey(name: 'start_date') final DateTime? startDate,
          @JsonKey(name: 'end_date') final DateTime? endDate,
          @JsonKey(name: 'is_current') final bool isCurrent,
          @JsonKey(name: 'is_verified') final bool isVerified,
          @JsonKey(name: 'is_featured') final bool isFeatured,
          @JsonKey(name: 'display_order') final int displayOrder,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$ExperienceImpl;

  factory _Experience.fromJson(Map<String, dynamic> json) =
      _$ExperienceImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get title;
  @override
  String? get role;
  @override
  @JsonKey(name: 'experience_type')
  String get experienceType;
  @override
  String? get description;
  @override
  List<String> get contributions;
  @override
  @JsonKey(name: 'tech_stack')
  List<String> get techStack;
  @override
  @JsonKey(name: 'project_url')
  String? get projectUrl;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'start_date')
  DateTime? get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  @JsonKey(name: 'is_current')
  bool get isCurrent;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;
  @override
  @JsonKey(name: 'is_featured')
  bool get isFeatured;
  @override
  @JsonKey(name: 'display_order')
  int get displayOrder;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExperienceImplCopyWith<_$ExperienceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExperienceCreate _$ExperienceCreateFromJson(Map<String, dynamic> json) {
  return _ExperienceCreate.fromJson(json);
}

/// @nodoc
mixin _$ExperienceCreate {
  String get title => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'experience_type')
  String get experienceType => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get contributions => throw _privateConstructorUsedError;
  @JsonKey(name: 'tech_stack')
  List<String> get techStack => throw _privateConstructorUsedError;
  @JsonKey(name: 'project_url')
  String? get projectUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_current')
  bool get isCurrent => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_featured')
  bool get isFeatured => throw _privateConstructorUsedError;

  /// Serializes this ExperienceCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExperienceCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExperienceCreateCopyWith<ExperienceCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExperienceCreateCopyWith<$Res> {
  factory $ExperienceCreateCopyWith(
          ExperienceCreate value, $Res Function(ExperienceCreate) then) =
      _$ExperienceCreateCopyWithImpl<$Res, ExperienceCreate>;
  @useResult
  $Res call(
      {String title,
      String? role,
      @JsonKey(name: 'experience_type') String experienceType,
      String? description,
      List<String> contributions,
      @JsonKey(name: 'tech_stack') List<String> techStack,
      @JsonKey(name: 'project_url') String? projectUrl,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'start_date') DateTime? startDate,
      @JsonKey(name: 'end_date') DateTime? endDate,
      @JsonKey(name: 'is_current') bool isCurrent,
      @JsonKey(name: 'is_featured') bool isFeatured});
}

/// @nodoc
class _$ExperienceCreateCopyWithImpl<$Res, $Val extends ExperienceCreate>
    implements $ExperienceCreateCopyWith<$Res> {
  _$ExperienceCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExperienceCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? role = freezed,
    Object? experienceType = null,
    Object? description = freezed,
    Object? contributions = null,
    Object? techStack = null,
    Object? projectUrl = freezed,
    Object? imageUrl = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCurrent = null,
    Object? isFeatured = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceType: null == experienceType
          ? _value.experienceType
          : experienceType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      contributions: null == contributions
          ? _value.contributions
          : contributions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      techStack: null == techStack
          ? _value.techStack
          : techStack // ignore: cast_nullable_to_non_nullable
              as List<String>,
      projectUrl: freezed == projectUrl
          ? _value.projectUrl
          : projectUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrent: null == isCurrent
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExperienceCreateImplCopyWith<$Res>
    implements $ExperienceCreateCopyWith<$Res> {
  factory _$$ExperienceCreateImplCopyWith(_$ExperienceCreateImpl value,
          $Res Function(_$ExperienceCreateImpl) then) =
      __$$ExperienceCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String? role,
      @JsonKey(name: 'experience_type') String experienceType,
      String? description,
      List<String> contributions,
      @JsonKey(name: 'tech_stack') List<String> techStack,
      @JsonKey(name: 'project_url') String? projectUrl,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'start_date') DateTime? startDate,
      @JsonKey(name: 'end_date') DateTime? endDate,
      @JsonKey(name: 'is_current') bool isCurrent,
      @JsonKey(name: 'is_featured') bool isFeatured});
}

/// @nodoc
class __$$ExperienceCreateImplCopyWithImpl<$Res>
    extends _$ExperienceCreateCopyWithImpl<$Res, _$ExperienceCreateImpl>
    implements _$$ExperienceCreateImplCopyWith<$Res> {
  __$$ExperienceCreateImplCopyWithImpl(_$ExperienceCreateImpl _value,
      $Res Function(_$ExperienceCreateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExperienceCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? role = freezed,
    Object? experienceType = null,
    Object? description = freezed,
    Object? contributions = null,
    Object? techStack = null,
    Object? projectUrl = freezed,
    Object? imageUrl = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCurrent = null,
    Object? isFeatured = null,
  }) {
    return _then(_$ExperienceCreateImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceType: null == experienceType
          ? _value.experienceType
          : experienceType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      contributions: null == contributions
          ? _value._contributions
          : contributions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      techStack: null == techStack
          ? _value._techStack
          : techStack // ignore: cast_nullable_to_non_nullable
              as List<String>,
      projectUrl: freezed == projectUrl
          ? _value.projectUrl
          : projectUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrent: null == isCurrent
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExperienceCreateImpl implements _ExperienceCreate {
  const _$ExperienceCreateImpl(
      {required this.title,
      this.role,
      @JsonKey(name: 'experience_type') this.experienceType = 'project',
      this.description,
      final List<String> contributions = const [],
      @JsonKey(name: 'tech_stack') final List<String> techStack = const [],
      @JsonKey(name: 'project_url') this.projectUrl,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'start_date') this.startDate,
      @JsonKey(name: 'end_date') this.endDate,
      @JsonKey(name: 'is_current') this.isCurrent = false,
      @JsonKey(name: 'is_featured') this.isFeatured = false})
      : _contributions = contributions,
        _techStack = techStack;

  factory _$ExperienceCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExperienceCreateImplFromJson(json);

  @override
  final String title;
  @override
  final String? role;
  @override
  @JsonKey(name: 'experience_type')
  final String experienceType;
  @override
  final String? description;
  final List<String> _contributions;
  @override
  @JsonKey()
  List<String> get contributions {
    if (_contributions is EqualUnmodifiableListView) return _contributions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contributions);
  }

  final List<String> _techStack;
  @override
  @JsonKey(name: 'tech_stack')
  List<String> get techStack {
    if (_techStack is EqualUnmodifiableListView) return _techStack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_techStack);
  }

  @override
  @JsonKey(name: 'project_url')
  final String? projectUrl;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @override
  @JsonKey(name: 'is_current')
  final bool isCurrent;
  @override
  @JsonKey(name: 'is_featured')
  final bool isFeatured;

  @override
  String toString() {
    return 'ExperienceCreate(title: $title, role: $role, experienceType: $experienceType, description: $description, contributions: $contributions, techStack: $techStack, projectUrl: $projectUrl, imageUrl: $imageUrl, startDate: $startDate, endDate: $endDate, isCurrent: $isCurrent, isFeatured: $isFeatured)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExperienceCreateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.experienceType, experienceType) ||
                other.experienceType == experienceType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._contributions, _contributions) &&
            const DeepCollectionEquality()
                .equals(other._techStack, _techStack) &&
            (identical(other.projectUrl, projectUrl) ||
                other.projectUrl == projectUrl) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isCurrent, isCurrent) ||
                other.isCurrent == isCurrent) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      role,
      experienceType,
      description,
      const DeepCollectionEquality().hash(_contributions),
      const DeepCollectionEquality().hash(_techStack),
      projectUrl,
      imageUrl,
      startDate,
      endDate,
      isCurrent,
      isFeatured);

  /// Create a copy of ExperienceCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExperienceCreateImplCopyWith<_$ExperienceCreateImpl> get copyWith =>
      __$$ExperienceCreateImplCopyWithImpl<_$ExperienceCreateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExperienceCreateImplToJson(
      this,
    );
  }
}

abstract class _ExperienceCreate implements ExperienceCreate {
  const factory _ExperienceCreate(
          {required final String title,
          final String? role,
          @JsonKey(name: 'experience_type') final String experienceType,
          final String? description,
          final List<String> contributions,
          @JsonKey(name: 'tech_stack') final List<String> techStack,
          @JsonKey(name: 'project_url') final String? projectUrl,
          @JsonKey(name: 'image_url') final String? imageUrl,
          @JsonKey(name: 'start_date') final DateTime? startDate,
          @JsonKey(name: 'end_date') final DateTime? endDate,
          @JsonKey(name: 'is_current') final bool isCurrent,
          @JsonKey(name: 'is_featured') final bool isFeatured}) =
      _$ExperienceCreateImpl;

  factory _ExperienceCreate.fromJson(Map<String, dynamic> json) =
      _$ExperienceCreateImpl.fromJson;

  @override
  String get title;
  @override
  String? get role;
  @override
  @JsonKey(name: 'experience_type')
  String get experienceType;
  @override
  String? get description;
  @override
  List<String> get contributions;
  @override
  @JsonKey(name: 'tech_stack')
  List<String> get techStack;
  @override
  @JsonKey(name: 'project_url')
  String? get projectUrl;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'start_date')
  DateTime? get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  @JsonKey(name: 'is_current')
  bool get isCurrent;
  @override
  @JsonKey(name: 'is_featured')
  bool get isFeatured;

  /// Create a copy of ExperienceCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExperienceCreateImplCopyWith<_$ExperienceCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExperienceSummary _$ExperienceSummaryFromJson(Map<String, dynamic> json) {
  return _ExperienceSummary.fromJson(json);
}

/// @nodoc
mixin _$ExperienceSummary {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'experience_type')
  String get experienceType => throw _privateConstructorUsedError;
  @JsonKey(name: 'tech_stack')
  List<String> get techStack => throw _privateConstructorUsedError;
  @JsonKey(name: 'project_url')
  String? get projectUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_current')
  bool get isCurrent => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;

  /// Serializes this ExperienceSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExperienceSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExperienceSummaryCopyWith<ExperienceSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExperienceSummaryCopyWith<$Res> {
  factory $ExperienceSummaryCopyWith(
          ExperienceSummary value, $Res Function(ExperienceSummary) then) =
      _$ExperienceSummaryCopyWithImpl<$Res, ExperienceSummary>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? role,
      @JsonKey(name: 'experience_type') String experienceType,
      @JsonKey(name: 'tech_stack') List<String> techStack,
      @JsonKey(name: 'project_url') String? projectUrl,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'is_current') bool isCurrent,
      @JsonKey(name: 'is_verified') bool isVerified});
}

/// @nodoc
class _$ExperienceSummaryCopyWithImpl<$Res, $Val extends ExperienceSummary>
    implements $ExperienceSummaryCopyWith<$Res> {
  _$ExperienceSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExperienceSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? role = freezed,
    Object? experienceType = null,
    Object? techStack = null,
    Object? projectUrl = freezed,
    Object? imageUrl = freezed,
    Object? isCurrent = null,
    Object? isVerified = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceType: null == experienceType
          ? _value.experienceType
          : experienceType // ignore: cast_nullable_to_non_nullable
              as String,
      techStack: null == techStack
          ? _value.techStack
          : techStack // ignore: cast_nullable_to_non_nullable
              as List<String>,
      projectUrl: freezed == projectUrl
          ? _value.projectUrl
          : projectUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isCurrent: null == isCurrent
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExperienceSummaryImplCopyWith<$Res>
    implements $ExperienceSummaryCopyWith<$Res> {
  factory _$$ExperienceSummaryImplCopyWith(_$ExperienceSummaryImpl value,
          $Res Function(_$ExperienceSummaryImpl) then) =
      __$$ExperienceSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? role,
      @JsonKey(name: 'experience_type') String experienceType,
      @JsonKey(name: 'tech_stack') List<String> techStack,
      @JsonKey(name: 'project_url') String? projectUrl,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'is_current') bool isCurrent,
      @JsonKey(name: 'is_verified') bool isVerified});
}

/// @nodoc
class __$$ExperienceSummaryImplCopyWithImpl<$Res>
    extends _$ExperienceSummaryCopyWithImpl<$Res, _$ExperienceSummaryImpl>
    implements _$$ExperienceSummaryImplCopyWith<$Res> {
  __$$ExperienceSummaryImplCopyWithImpl(_$ExperienceSummaryImpl _value,
      $Res Function(_$ExperienceSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExperienceSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? role = freezed,
    Object? experienceType = null,
    Object? techStack = null,
    Object? projectUrl = freezed,
    Object? imageUrl = freezed,
    Object? isCurrent = null,
    Object? isVerified = null,
  }) {
    return _then(_$ExperienceSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceType: null == experienceType
          ? _value.experienceType
          : experienceType // ignore: cast_nullable_to_non_nullable
              as String,
      techStack: null == techStack
          ? _value._techStack
          : techStack // ignore: cast_nullable_to_non_nullable
              as List<String>,
      projectUrl: freezed == projectUrl
          ? _value.projectUrl
          : projectUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isCurrent: null == isCurrent
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExperienceSummaryImpl implements _ExperienceSummary {
  const _$ExperienceSummaryImpl(
      {required this.id,
      required this.title,
      this.role,
      @JsonKey(name: 'experience_type') this.experienceType = 'project',
      @JsonKey(name: 'tech_stack') final List<String> techStack = const [],
      @JsonKey(name: 'project_url') this.projectUrl,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'is_current') this.isCurrent = false,
      @JsonKey(name: 'is_verified') this.isVerified = false})
      : _techStack = techStack;

  factory _$ExperienceSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExperienceSummaryImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? role;
  @override
  @JsonKey(name: 'experience_type')
  final String experienceType;
  final List<String> _techStack;
  @override
  @JsonKey(name: 'tech_stack')
  List<String> get techStack {
    if (_techStack is EqualUnmodifiableListView) return _techStack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_techStack);
  }

  @override
  @JsonKey(name: 'project_url')
  final String? projectUrl;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'is_current')
  final bool isCurrent;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;

  @override
  String toString() {
    return 'ExperienceSummary(id: $id, title: $title, role: $role, experienceType: $experienceType, techStack: $techStack, projectUrl: $projectUrl, imageUrl: $imageUrl, isCurrent: $isCurrent, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExperienceSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.experienceType, experienceType) ||
                other.experienceType == experienceType) &&
            const DeepCollectionEquality()
                .equals(other._techStack, _techStack) &&
            (identical(other.projectUrl, projectUrl) ||
                other.projectUrl == projectUrl) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isCurrent, isCurrent) ||
                other.isCurrent == isCurrent) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      role,
      experienceType,
      const DeepCollectionEquality().hash(_techStack),
      projectUrl,
      imageUrl,
      isCurrent,
      isVerified);

  /// Create a copy of ExperienceSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExperienceSummaryImplCopyWith<_$ExperienceSummaryImpl> get copyWith =>
      __$$ExperienceSummaryImplCopyWithImpl<_$ExperienceSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExperienceSummaryImplToJson(
      this,
    );
  }
}

abstract class _ExperienceSummary implements ExperienceSummary {
  const factory _ExperienceSummary(
          {required final int id,
          required final String title,
          final String? role,
          @JsonKey(name: 'experience_type') final String experienceType,
          @JsonKey(name: 'tech_stack') final List<String> techStack,
          @JsonKey(name: 'project_url') final String? projectUrl,
          @JsonKey(name: 'image_url') final String? imageUrl,
          @JsonKey(name: 'is_current') final bool isCurrent,
          @JsonKey(name: 'is_verified') final bool isVerified}) =
      _$ExperienceSummaryImpl;

  factory _ExperienceSummary.fromJson(Map<String, dynamic> json) =
      _$ExperienceSummaryImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get role;
  @override
  @JsonKey(name: 'experience_type')
  String get experienceType;
  @override
  @JsonKey(name: 'tech_stack')
  List<String> get techStack;
  @override
  @JsonKey(name: 'project_url')
  String? get projectUrl;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'is_current')
  bool get isCurrent;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;

  /// Create a copy of ExperienceSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExperienceSummaryImplCopyWith<_$ExperienceSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
