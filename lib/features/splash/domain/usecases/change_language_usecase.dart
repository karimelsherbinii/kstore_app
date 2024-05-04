import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/lang_repository.dart';

class ChangeLanguageUseCase implements UseCase<bool, String> {
  final LanguageRepository languageRepository;
  ChangeLanguageUseCase({required this.languageRepository});
  @override
  Future<Either<Failure, bool>> call(String languageCode) async {
    return await languageRepository.changeLanguage(languageCode: languageCode);
  }
}
