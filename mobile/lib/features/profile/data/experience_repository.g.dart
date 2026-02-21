// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$featuredExperiencesHash() =>
    r'8a6d9c3680fa210b3e2b4e98c2dcdd202ed558e0';

/// Provider for featured experiences (for profile section)
///
/// Copied from [featuredExperiences].
@ProviderFor(featuredExperiences)
final featuredExperiencesProvider =
    AutoDisposeFutureProvider<List<ExperienceSummary>>.internal(
  featuredExperiences,
  name: r'featuredExperiencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$featuredExperiencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeaturedExperiencesRef
    = AutoDisposeFutureProviderRef<List<ExperienceSummary>>;
String _$experienceRepositoryHash() =>
    r'b0dffec63b076b1a3a1ff7cde4e7fe22871573f1';

/// See also [ExperienceRepository].
@ProviderFor(ExperienceRepository)
final experienceRepositoryProvider = AutoDisposeAsyncNotifierProvider<
    ExperienceRepository, List<Experience>>.internal(
  ExperienceRepository.new,
  name: r'experienceRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$experienceRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExperienceRepository = AutoDisposeAsyncNotifier<List<Experience>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
