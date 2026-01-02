import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/feature/profile/data/datasources/profile_remote_data_source.dart';
import 'package:blog_app/feature/profile/data/models/user_profile_model.dart';
import 'package:blog_app/feature/profile/domain/entities/user_profile.dart';
import 'package:blog_app/feature/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
    UserProfile profile,
  ) async {
    try {
      final profileModel = UserProfileModel.fromEntity(profile);
      final updatedProfile = await remoteDataSource.updateProfile(profileModel);
      return right(updatedProfile);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getProfile(String userId) async {
    try {
      final profile = await remoteDataSource.getProfile(userId);
      if (profile == null) {
        return left(Failure('Profile not found'));
      }
      return right(profile);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage({
    required File image,
    required String userId,
  }) async {
    try {
      final imageUrl = await remoteDataSource.uploadProfileImage(
        image: image,
        userId: userId,
      );
      // Append timestamp to force cache refresh
      return right(imageUrl);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
