// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conversationsListHash() => r'84e286324b61092cf6efe475e15b9639203c22ab';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for conversations list
///
/// Copied from [conversationsList].
@ProviderFor(conversationsList)
const conversationsListProvider = ConversationsListFamily();

/// Provider for conversations list
///
/// Copied from [conversationsList].
class ConversationsListFamily extends Family<AsyncValue<List<Conversation>>> {
  /// Provider for conversations list
  ///
  /// Copied from [conversationsList].
  const ConversationsListFamily();

  /// Provider for conversations list
  ///
  /// Copied from [conversationsList].
  ConversationsListProvider call({
    String? messageType,
  }) {
    return ConversationsListProvider(
      messageType: messageType,
    );
  }

  @override
  ConversationsListProvider getProviderOverride(
    covariant ConversationsListProvider provider,
  ) {
    return call(
      messageType: provider.messageType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'conversationsListProvider';
}

/// Provider for conversations list
///
/// Copied from [conversationsList].
class ConversationsListProvider
    extends AutoDisposeFutureProvider<List<Conversation>> {
  /// Provider for conversations list
  ///
  /// Copied from [conversationsList].
  ConversationsListProvider({
    String? messageType,
  }) : this._internal(
          (ref) => conversationsList(
            ref as ConversationsListRef,
            messageType: messageType,
          ),
          from: conversationsListProvider,
          name: r'conversationsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationsListHash,
          dependencies: ConversationsListFamily._dependencies,
          allTransitiveDependencies:
              ConversationsListFamily._allTransitiveDependencies,
          messageType: messageType,
        );

  ConversationsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.messageType,
  }) : super.internal();

  final String? messageType;

  @override
  Override overrideWith(
    FutureOr<List<Conversation>> Function(ConversationsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationsListProvider._internal(
        (ref) => create(ref as ConversationsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        messageType: messageType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Conversation>> createElement() {
    return _ConversationsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationsListProvider &&
        other.messageType == messageType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, messageType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConversationsListRef on AutoDisposeFutureProviderRef<List<Conversation>> {
  /// The parameter `messageType` of this provider.
  String? get messageType;
}

class _ConversationsListProviderElement
    extends AutoDisposeFutureProviderElement<List<Conversation>>
    with ConversationsListRef {
  _ConversationsListProviderElement(super.provider);

  @override
  String? get messageType => (origin as ConversationsListProvider).messageType;
}

String _$conversationDetailHash() =>
    r'073feb9901e0d92df8faa4a7834b84777c0ff0dd';

/// Provider for a single conversation detail
///
/// Copied from [conversationDetail].
@ProviderFor(conversationDetail)
const conversationDetailProvider = ConversationDetailFamily();

/// Provider for a single conversation detail
///
/// Copied from [conversationDetail].
class ConversationDetailFamily extends Family<AsyncValue<ConversationDetail>> {
  /// Provider for a single conversation detail
  ///
  /// Copied from [conversationDetail].
  const ConversationDetailFamily();

  /// Provider for a single conversation detail
  ///
  /// Copied from [conversationDetail].
  ConversationDetailProvider call(
    int conversationId,
  ) {
    return ConversationDetailProvider(
      conversationId,
    );
  }

  @override
  ConversationDetailProvider getProviderOverride(
    covariant ConversationDetailProvider provider,
  ) {
    return call(
      provider.conversationId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'conversationDetailProvider';
}

/// Provider for a single conversation detail
///
/// Copied from [conversationDetail].
class ConversationDetailProvider
    extends AutoDisposeFutureProvider<ConversationDetail> {
  /// Provider for a single conversation detail
  ///
  /// Copied from [conversationDetail].
  ConversationDetailProvider(
    int conversationId,
  ) : this._internal(
          (ref) => conversationDetail(
            ref as ConversationDetailRef,
            conversationId,
          ),
          from: conversationDetailProvider,
          name: r'conversationDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationDetailHash,
          dependencies: ConversationDetailFamily._dependencies,
          allTransitiveDependencies:
              ConversationDetailFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  ConversationDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final int conversationId;

  @override
  Override overrideWith(
    FutureOr<ConversationDetail> Function(ConversationDetailRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationDetailProvider._internal(
        (ref) => create(ref as ConversationDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ConversationDetail> createElement() {
    return _ConversationDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationDetailProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConversationDetailRef
    on AutoDisposeFutureProviderRef<ConversationDetail> {
  /// The parameter `conversationId` of this provider.
  int get conversationId;
}

class _ConversationDetailProviderElement
    extends AutoDisposeFutureProviderElement<ConversationDetail>
    with ConversationDetailRef {
  _ConversationDetailProviderElement(super.provider);

  @override
  int get conversationId =>
      (origin as ConversationDetailProvider).conversationId;
}

String _$inboxRepositoryHash() => r'961641873f5f9dd5413d31163c7df38b7dd8e173';

/// See also [InboxRepository].
@ProviderFor(InboxRepository)
final inboxRepositoryProvider =
    AutoDisposeNotifierProvider<InboxRepository, Dio>.internal(
  InboxRepository.new,
  name: r'inboxRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inboxRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InboxRepository = AutoDisposeNotifier<Dio>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
