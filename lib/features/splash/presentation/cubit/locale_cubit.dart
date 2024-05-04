import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/usecases/change_language_usecase.dart';
import '../../domain/usecases/get_saved_language.dart';
import 'locale_states.dart';

class LocaleCubit extends Cubit<LocaleStates> {
  final GetSavedLanguageUseCase getSavedLanguageUseCase;
  final ChangeLanguageUseCase changeLanguageUseCase;
  LocaleCubit(
      {required this.getSavedLanguageUseCase,
      required this.changeLanguageUseCase})
      : super(const ChangeLocaleState(
          Locale(AppStrings.englishCode),
        ));
  String currentLangCode = AppStrings.englishCode;
  static LocaleCubit get(context) => BlocProvider.of(context);

  Future<void> getSavedLanguage() async {
    final response = await getSavedLanguageUseCase.call(NoParams());
    response.fold((failure) => debugPrint(AppStrings.cacheFailure), (value) {
      currentLangCode = value;
      emit(ChangeLocaleState(Locale(currentLangCode)));
    });
  }

  // change
  Future<void> changeLanguage(String languageCode,
      {BuildContext? context}) async {
    final response = await changeLanguageUseCase.call(languageCode);
    response.fold((failure) => debugPrint(AppStrings.cacheFailure), (value) {
      currentLangCode = languageCode;
      emit(ChangeLocaleState(Locale(currentLangCode)));
    });
  }

  // converting:
  void toEnglish() => changeLanguage(AppStrings.englishCode);
  void toArabic() => changeLanguage(AppStrings.arabicCode);
}
