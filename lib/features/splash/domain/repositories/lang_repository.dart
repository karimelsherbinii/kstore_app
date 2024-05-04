import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class LanguageRepository {
  Future<Either<Failure, bool>> changeLanguage({required String languageCode});
  Future<Either<Failure, String>> savedLanguage();
}
