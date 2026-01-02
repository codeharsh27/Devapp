import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/connection_checker.dart';
import '../../data/datasources/job_local_data_source.dart';
import '../../data/datasources/job_remote_data_source.dart';
import '../../data/model/job_model.dart';
import '../../domain/entity/job.dart';
import '../../domain/repository/job_repository.dart';

class JobRepositoryImpl implements JobRepository {
  final JobLocalDataSource localDataSource;
  final JobRemoteDataSource jSearchRemoteDataSource;
  final JobRemoteDataSource remotiveRemoteDataSource;
  final JobRemoteDataSource findWorkRemoteDataSource;
  final ConnectionChecker connectionChecker;

  JobRepositoryImpl(
    this.localDataSource,
    this.jSearchRemoteDataSource,
    this.remotiveRemoteDataSource,
    this.findWorkRemoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, List<Job>>> getCachedJobs() async {
    try {
      final localJobs = await localDataSource.loadJobs();
      if (localJobs.isNotEmpty) {
        return right(_mapModelsToEntities(localJobs));
      }
      return left(Failure('No cached jobs found'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getRemoteJobs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet connection'));
      }

      // Fetch from both sources
      List<JobModel> allJobs = [];

      // try {
      //   final jSearchJobs = await jSearchRemoteDataSource.getJobs();
      //   allJobs.addAll(jSearchJobs);
      // } catch (e) {
      //   debugPrint('JSearch failed: $e');
      // }

      try {
        final remotiveJobs = await remotiveRemoteDataSource.getJobs();
        allJobs.addAll(remotiveJobs);
      } catch (e) {
        debugPrint('Remotive failed: $e');
      }

      try {
        final findWorkJobs = await findWorkRemoteDataSource.getJobs();
        allJobs.addAll(findWorkJobs);
      } catch (e) {
        debugPrint('FindWork failed: $e');
      }

      if (allJobs.isEmpty) {
        return left(Failure('Failed to fetch jobs from all sources'));
      }

      // Cache the results
      try {
        await localDataSource.uploadLocalJobs(allJobs);
      } catch (e) {
        debugPrint('Cache save error: $e');
      }

      // Update isSaved status
      final savedIds = await localDataSource.getSavedJobIds();
      final jobsWithSavedStatus = allJobs.map((job) {
        final id = '${job.title}_${job.company}';
        return JobModel(
          title: job.title,
          company: job.company,
          location: job.location,
          employmentType: job.employmentType,
          applyUrl: job.applyUrl,
          postedAt: job.postedAt,
          description: job.description,
          skills: job.skills,
          companyLogo: job.companyLogo,
          isSaved: savedIds.contains(id),
        );
      }).toList();

      return right(_mapModelsToEntities(jobsWithSavedStatus));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleSaveJob(String jobId) async {
    try {
      await localDataSource.toggleSavedJob(jobId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  List<Job> _mapModelsToEntities(List<JobModel> models) {
    return models
        .map(
          (model) => Job(
            title: model.title,
            company: model.company,
            location: model.location,
            employmentType: model.employmentType,
            applyUrl: model.applyUrl,
            postedAt: model.postedAt,
            description: model.description,
            skills: model.skills,
            matchScore: null,
            companyLogo: model.companyLogo,
            isSaved: model.isSaved,
          ),
        )
        .toList();
  }
}
