import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/lang_repository.dart';
import '../datasources/lang_local_datasource.dart';

class LanguageRepositoryImplementation implements LanguageRepository {
  final LanguageLocalDataSource languageLocalDataSource;
  LanguageRepositoryImplementation({required this.languageLocalDataSource});
  @override
  Future<Either<Failure, bool>> changeLanguage(
      {required String languageCode}) async {
    try {
      final langIsChanged = await languageLocalDataSource.changeLanguage(
          languageCode: languageCode);
      return Right(langIsChanged);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

// 2
  @override
  Future<Either<Failure, String>> savedLanguage() async {
    try {
      final languageCode = await languageLocalDataSource.getSavedLanguage();
      return Right(languageCode);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}
