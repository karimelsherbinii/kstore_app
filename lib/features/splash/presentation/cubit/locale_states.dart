import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LocaleStates extends Equatable {
  final Locale locale;
  const LocaleStates(this.locale);
  @override
  List<Object?> get props => [locale];
}

class ChangeLocaleState extends LocaleStates {
  const ChangeLocaleState(Locale selectedLocale) : super(selectedLocale);
}
