// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_name')
  String get senderName => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_role')
  String? get senderRole => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_avatar_color')
  String get senderAvatarColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'message_type')
  String get messageType => throw _privateConstructorUsedError;
  String? get subject => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message')
  String? get lastMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message_time')
  DateTime? get lastMessageTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_count')
  int get unreadCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) then) =
      _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'sender_name') String senderName,
      @JsonKey(name: 'sender_role') String? senderRole,
      @JsonKey(name: 'sender_avatar_color') String senderAvatarColor,
      @JsonKey(name: 'message_type') String messageType,
      String? subject,
      @JsonKey(name: 'last_message') String? lastMessage,
      @JsonKey(name: 'last_message_time') DateTime? lastMessageTime,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'unread_count') int unreadCount,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderName = null,
    Object? senderRole = freezed,
    Object? senderAvatarColor = null,
    Object? messageType = null,
    Object? subject = freezed,
    Object? lastMessage = freezed,
    Object? lastMessageTime = freezed,
    Object? isRead = null,
    Object? unreadCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderRole: freezed == senderRole
          ? _value.senderRole
          : senderRole // ignore: cast_nullable_to_non_nullable
              as String?,
      senderAvatarColor: null == senderAvatarColor
          ? _value.senderAvatarColor
          : senderAvatarColor // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      subject: freezed == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageTime: freezed == lastMessageTime
          ? _value.lastMessageTime
          : lastMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
          _$ConversationImpl value, $Res Function(_$ConversationImpl) then) =
      __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'sender_name') String senderName,
      @JsonKey(name: 'sender_role') String? senderRole,
      @JsonKey(name: 'sender_avatar_color') String senderAvatarColor,
      @JsonKey(name: 'message_type') String messageType,
      String? subject,
      @JsonKey(name: 'last_message') String? lastMessage,
      @JsonKey(name: 'last_message_time') DateTime? lastMessageTime,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'unread_count') int unreadCount,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
      _$ConversationImpl _value, $Res Function(_$ConversationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderName = null,
    Object? senderRole = freezed,
    Object? senderAvatarColor = null,
    Object? messageType = null,
    Object? subject = freezed,
    Object? lastMessage = freezed,
    Object? lastMessageTime = freezed,
    Object? isRead = null,
    Object? unreadCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ConversationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderRole: freezed == senderRole
          ? _value.senderRole
          : senderRole // ignore: cast_nullable_to_non_nullable
              as String?,
      senderAvatarColor: null == senderAvatarColor
          ? _value.senderAvatarColor
          : senderAvatarColor // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      subject: freezed == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageTime: freezed == lastMessageTime
          ? _value.lastMessageTime
          : lastMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationImpl implements _Conversation {
  const _$ConversationImpl(
      {required this.id,
      @JsonKey(name: 'sender_name') required this.senderName,
      @JsonKey(name: 'sender_role') this.senderRole,
      @JsonKey(name: 'sender_avatar_color') this.senderAvatarColor = '#6366F1',
      @JsonKey(name: 'message_type') this.messageType = 'general',
      this.subject,
      @JsonKey(name: 'last_message') this.lastMessage,
      @JsonKey(name: 'last_message_time') this.lastMessageTime,
      @JsonKey(name: 'is_read') this.isRead = false,
      @JsonKey(name: 'unread_count') this.unreadCount = 0,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$ConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'sender_name')
  final String senderName;
  @override
  @JsonKey(name: 'sender_role')
  final String? senderRole;
  @override
  @JsonKey(name: 'sender_avatar_color')
  final String senderAvatarColor;
  @override
  @JsonKey(name: 'message_type')
  final String messageType;
  @override
  final String? subject;
  @override
  @JsonKey(name: 'last_message')
  final String? lastMessage;
  @override
  @JsonKey(name: 'last_message_time')
  final DateTime? lastMessageTime;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Conversation(id: $id, senderName: $senderName, senderRole: $senderRole, senderAvatarColor: $senderAvatarColor, messageType: $messageType, subject: $subject, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime, isRead: $isRead, unreadCount: $unreadCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderRole, senderRole) ||
                other.senderRole == senderRole) &&
            (identical(other.senderAvatarColor, senderAvatarColor) ||
                other.senderAvatarColor == senderAvatarColor) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageTime, lastMessageTime) ||
                other.lastMessageTime == lastMessageTime) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
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
      senderName,
      senderRole,
      senderAvatarColor,
      messageType,
      subject,
      lastMessage,
      lastMessageTime,
      isRead,
      unreadCount,
      createdAt,
      updatedAt);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationImplToJson(
      this,
    );
  }
}

abstract class _Conversation implements Conversation {
  const factory _Conversation(
          {required final int id,
          @JsonKey(name: 'sender_name') required final String senderName,
          @JsonKey(name: 'sender_role') final String? senderRole,
          @JsonKey(name: 'sender_avatar_color') final String senderAvatarColor,
          @JsonKey(name: 'message_type') final String messageType,
          final String? subject,
          @JsonKey(name: 'last_message') final String? lastMessage,
          @JsonKey(name: 'last_message_time') final DateTime? lastMessageTime,
          @JsonKey(name: 'is_read') final bool isRead,
          @JsonKey(name: 'unread_count') final int unreadCount,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$ConversationImpl;

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$ConversationImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'sender_name')
  String get senderName;
  @override
  @JsonKey(name: 'sender_role')
  String? get senderRole;
  @override
  @JsonKey(name: 'sender_avatar_color')
  String get senderAvatarColor;
  @override
  @JsonKey(name: 'message_type')
  String get messageType;
  @override
  String? get subject;
  @override
  @JsonKey(name: 'last_message')
  String? get lastMessage;
  @override
  @JsonKey(name: 'last_message_time')
  DateTime? get lastMessageTime;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'unread_count')
  int get unreadCount;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConversationDetail _$ConversationDetailFromJson(Map<String, dynamic> json) {
  return _ConversationDetail.fromJson(json);
}

/// @nodoc
mixin _$ConversationDetail {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_name')
  String get senderName => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_role')
  String? get senderRole => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_email')
  String? get senderEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_avatar_color')
  String get senderAvatarColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'message_type')
  String get messageType => throw _privateConstructorUsedError;
  String? get subject => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<Message> get messages => throw _privateConstructorUsedError;

  /// Serializes this ConversationDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationDetailCopyWith<ConversationDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationDetailCopyWith<$Res> {
  factory $ConversationDetailCopyWith(
          ConversationDetail value, $Res Function(ConversationDetail) then) =
      _$ConversationDetailCopyWithImpl<$Res, ConversationDetail>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'sender_name') String senderName,
      @JsonKey(name: 'sender_role') String? senderRole,
      @JsonKey(name: 'sender_email') String? senderEmail,
      @JsonKey(name: 'sender_avatar_color') String senderAvatarColor,
      @JsonKey(name: 'message_type') String messageType,
      String? subject,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      List<Message> messages});
}

/// @nodoc
class _$ConversationDetailCopyWithImpl<$Res, $Val extends ConversationDetail>
    implements $ConversationDetailCopyWith<$Res> {
  _$ConversationDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderName = null,
    Object? senderRole = freezed,
    Object? senderEmail = freezed,
    Object? senderAvatarColor = null,
    Object? messageType = null,
    Object? subject = freezed,
    Object? isRead = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? messages = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderRole: freezed == senderRole
          ? _value.senderRole
          : senderRole // ignore: cast_nullable_to_non_nullable
              as String?,
      senderEmail: freezed == senderEmail
          ? _value.senderEmail
          : senderEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      senderAvatarColor: null == senderAvatarColor
          ? _value.senderAvatarColor
          : senderAvatarColor // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      subject: freezed == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationDetailImplCopyWith<$Res>
    implements $ConversationDetailCopyWith<$Res> {
  factory _$$ConversationDetailImplCopyWith(_$ConversationDetailImpl value,
          $Res Function(_$ConversationDetailImpl) then) =
      __$$ConversationDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'sender_name') String senderName,
      @JsonKey(name: 'sender_role') String? senderRole,
      @JsonKey(name: 'sender_email') String? senderEmail,
      @JsonKey(name: 'sender_avatar_color') String senderAvatarColor,
      @JsonKey(name: 'message_type') String messageType,
      String? subject,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      List<Message> messages});
}

/// @nodoc
class __$$ConversationDetailImplCopyWithImpl<$Res>
    extends _$ConversationDetailCopyWithImpl<$Res, _$ConversationDetailImpl>
    implements _$$ConversationDetailImplCopyWith<$Res> {
  __$$ConversationDetailImplCopyWithImpl(_$ConversationDetailImpl _value,
      $Res Function(_$ConversationDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderName = null,
    Object? senderRole = freezed,
    Object? senderEmail = freezed,
    Object? senderAvatarColor = null,
    Object? messageType = null,
    Object? subject = freezed,
    Object? isRead = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? messages = null,
  }) {
    return _then(_$ConversationDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderRole: freezed == senderRole
          ? _value.senderRole
          : senderRole // ignore: cast_nullable_to_non_nullable
              as String?,
      senderEmail: freezed == senderEmail
          ? _value.senderEmail
          : senderEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      senderAvatarColor: null == senderAvatarColor
          ? _value.senderAvatarColor
          : senderAvatarColor // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      subject: freezed == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationDetailImpl implements _ConversationDetail {
  const _$ConversationDetailImpl(
      {required this.id,
      @JsonKey(name: 'sender_name') required this.senderName,
      @JsonKey(name: 'sender_role') this.senderRole,
      @JsonKey(name: 'sender_email') this.senderEmail,
      @JsonKey(name: 'sender_avatar_color') this.senderAvatarColor = '#6366F1',
      @JsonKey(name: 'message_type') this.messageType = 'general',
      this.subject,
      @JsonKey(name: 'is_read') this.isRead = false,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      final List<Message> messages = const []})
      : _messages = messages;

  factory _$ConversationDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationDetailImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'sender_name')
  final String senderName;
  @override
  @JsonKey(name: 'sender_role')
  final String? senderRole;
  @override
  @JsonKey(name: 'sender_email')
  final String? senderEmail;
  @override
  @JsonKey(name: 'sender_avatar_color')
  final String senderAvatarColor;
  @override
  @JsonKey(name: 'message_type')
  final String messageType;
  @override
  final String? subject;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final List<Message> _messages;
  @override
  @JsonKey()
  List<Message> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'ConversationDetail(id: $id, senderName: $senderName, senderRole: $senderRole, senderEmail: $senderEmail, senderAvatarColor: $senderAvatarColor, messageType: $messageType, subject: $subject, isRead: $isRead, createdAt: $createdAt, updatedAt: $updatedAt, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderRole, senderRole) ||
                other.senderRole == senderRole) &&
            (identical(other.senderEmail, senderEmail) ||
                other.senderEmail == senderEmail) &&
            (identical(other.senderAvatarColor, senderAvatarColor) ||
                other.senderAvatarColor == senderAvatarColor) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      senderName,
      senderRole,
      senderEmail,
      senderAvatarColor,
      messageType,
      subject,
      isRead,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_messages));

  /// Create a copy of ConversationDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationDetailImplCopyWith<_$ConversationDetailImpl> get copyWith =>
      __$$ConversationDetailImplCopyWithImpl<_$ConversationDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationDetailImplToJson(
      this,
    );
  }
}

abstract class _ConversationDetail implements ConversationDetail {
  const factory _ConversationDetail(
      {required final int id,
      @JsonKey(name: 'sender_name') required final String senderName,
      @JsonKey(name: 'sender_role') final String? senderRole,
      @JsonKey(name: 'sender_email') final String? senderEmail,
      @JsonKey(name: 'sender_avatar_color') final String senderAvatarColor,
      @JsonKey(name: 'message_type') final String messageType,
      final String? subject,
      @JsonKey(name: 'is_read') final bool isRead,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final List<Message> messages}) = _$ConversationDetailImpl;

  factory _ConversationDetail.fromJson(Map<String, dynamic> json) =
      _$ConversationDetailImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'sender_name')
  String get senderName;
  @override
  @JsonKey(name: 'sender_role')
  String? get senderRole;
  @override
  @JsonKey(name: 'sender_email')
  String? get senderEmail;
  @override
  @JsonKey(name: 'sender_avatar_color')
  String get senderAvatarColor;
  @override
  @JsonKey(name: 'message_type')
  String get messageType;
  @override
  String? get subject;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  List<Message> get messages;

  /// Create a copy of ConversationDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationDetailImplCopyWith<_$ConversationDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_id')
  int get conversationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_from_user')
  bool get isFromUser => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'attachment_url')
  String? get attachmentUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'attachment_type')
  String? get attachmentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'conversation_id') int conversationId,
      @JsonKey(name: 'is_from_user') bool isFromUser,
      String content,
      @JsonKey(name: 'attachment_url') String? attachmentUrl,
      @JsonKey(name: 'attachment_type') String? attachmentType,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'is_read') bool isRead});
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? isFromUser = null,
    Object? content = null,
    Object? attachmentUrl = freezed,
    Object? attachmentType = freezed,
    Object? createdAt = null,
    Object? isRead = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int,
      isFromUser: null == isFromUser
          ? _value.isFromUser
          : isFromUser // ignore: cast_nullable_to_non_nullable
              as bool,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentUrl: freezed == attachmentUrl
          ? _value.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      attachmentType: freezed == attachmentType
          ? _value.attachmentType
          : attachmentType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'conversation_id') int conversationId,
      @JsonKey(name: 'is_from_user') bool isFromUser,
      String content,
      @JsonKey(name: 'attachment_url') String? attachmentUrl,
      @JsonKey(name: 'attachment_type') String? attachmentType,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'is_read') bool isRead});
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? isFromUser = null,
    Object? content = null,
    Object? attachmentUrl = freezed,
    Object? attachmentType = freezed,
    Object? createdAt = null,
    Object? isRead = null,
  }) {
    return _then(_$MessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int,
      isFromUser: null == isFromUser
          ? _value.isFromUser
          : isFromUser // ignore: cast_nullable_to_non_nullable
              as bool,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentUrl: freezed == attachmentUrl
          ? _value.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      attachmentType: freezed == attachmentType
          ? _value.attachmentType
          : attachmentType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl implements _Message {
  const _$MessageImpl(
      {required this.id,
      @JsonKey(name: 'conversation_id') required this.conversationId,
      @JsonKey(name: 'is_from_user') required this.isFromUser,
      required this.content,
      @JsonKey(name: 'attachment_url') this.attachmentUrl,
      @JsonKey(name: 'attachment_type') this.attachmentType,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'is_read') this.isRead = false});

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'conversation_id')
  final int conversationId;
  @override
  @JsonKey(name: 'is_from_user')
  final bool isFromUser;
  @override
  final String content;
  @override
  @JsonKey(name: 'attachment_url')
  final String? attachmentUrl;
  @override
  @JsonKey(name: 'attachment_type')
  final String? attachmentType;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;

  @override
  String toString() {
    return 'Message(id: $id, conversationId: $conversationId, isFromUser: $isFromUser, content: $content, attachmentUrl: $attachmentUrl, attachmentType: $attachmentType, createdAt: $createdAt, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.isFromUser, isFromUser) ||
                other.isFromUser == isFromUser) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.attachmentUrl, attachmentUrl) ||
                other.attachmentUrl == attachmentUrl) &&
            (identical(other.attachmentType, attachmentType) ||
                other.attachmentType == attachmentType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, conversationId, isFromUser,
      content, attachmentUrl, attachmentType, createdAt, isRead);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(
      this,
    );
  }
}

abstract class _Message implements Message {
  const factory _Message(
      {required final int id,
      @JsonKey(name: 'conversation_id') required final int conversationId,
      @JsonKey(name: 'is_from_user') required final bool isFromUser,
      required final String content,
      @JsonKey(name: 'attachment_url') final String? attachmentUrl,
      @JsonKey(name: 'attachment_type') final String? attachmentType,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'is_read') final bool isRead}) = _$MessageImpl;

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'conversation_id')
  int get conversationId;
  @override
  @JsonKey(name: 'is_from_user')
  bool get isFromUser;
  @override
  String get content;
  @override
  @JsonKey(name: 'attachment_url')
  String? get attachmentUrl;
  @override
  @JsonKey(name: 'attachment_type')
  String? get attachmentType;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
