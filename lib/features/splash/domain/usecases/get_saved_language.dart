import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/lang_repository.dart';

class GetSavedLanguageUseCase implements UseCase<String, NoParams> {
  final LanguageRepository languageRepository;
  GetSavedLanguageUseCase({required this.languageRepository});
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await languageRepository.savedLanguage();
  }
}
