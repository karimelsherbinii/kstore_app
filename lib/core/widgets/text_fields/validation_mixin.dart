import 'package:flutter/material.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:validators/validators.dart';
import '../../../config/locale/app_localizations.dart';

mixin ValidationMixin<T extends StatefulWidget> on State<T> {
  String? _password, _newPassword;

  String? validateName(String? name) {
    if (name!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('name_validation');
    } else if (name.length < 3) {
      return AppLocalizations.of(context)!.translate('name_validation_length');
    } else if (name.length > 20) {
      return AppLocalizations.of(context)!
          .translate('name_validation_length_20');
    } else if (!isAlpha(name)) {
      return AppLocalizations.of(context)!.translate('name_validation_alpha');
    } else {
      return null;
    }
  }

  String? validatePhone(String? phone) {
    if (phone!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('phone_validation');
    } else if (phone.length < 11) {
      return AppLocalizations.of(context)!.translate('phone_validation_length');
    } else if (phone.length > 11) {
      return AppLocalizations.of(context)!
          .translate('phone_validation_length_2');
    } else if (!isNumeric(phone)) {
      return AppLocalizations.of(context)!
          .translate('phone_validation_numeric');
    } else {
      return null;
    }
  }

  String? validatePassword(String? password) {
    _password = password;
    if (password!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('password_validation');
    }
    if (password.length < 8) {
      return AppLocalizations.of(context)!
          .translate('password_short_validation');
    }
    if (password.length > 20) {
      return AppLocalizations.of(context)!
          .translate('password_validation_length_20');
    } else {
      return null;
    }
  }

  String? validateNewPassword(String? newPassword) {
    _newPassword = newPassword;
    if (newPassword!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('new_password_validation');
    } else if (newPassword.length < 8) {
      return AppLocalizations.of(context)!
          .translate('password_short_validation');
    }

    return null;
  }

  String? validateEmail(String? email) {
    if (email!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('email_validation_empty');
    } else if (!isEmail(email)) {
      return AppLocalizations.of(context)!
          .translate('email_validation_email_format');
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword!.trim().isEmpty) {
      return AppLocalizations.of(context)!
          .translate('confirm_password_validation')!;
    } else if (_newPassword != confirmPassword) {
      return AppLocalizations.of(context)!.translate('password_not_identical');
    } else if (confirmPassword.length < 8) {
      return AppLocalizations.of(context)!
          .translate('password_short_validation');
    }
    return null;
  }

  String? validateDate(String? date) {
    if (date!.trim().isEmpty) {
      return AppLocalizations.of(context)!
          .translate(AppLocalizationStrings.birthdayValidationEmpty);
    } else {
      return '';
    }
  }

// first name
  String? validationFirstName(String? firstName) {
    if (firstName!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('first_name_validation');
    } else {
      return null;
    }
  }

  // last name
  String? validationLastName(String? lastName) {
    if (lastName!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('last_name_validation');
    } else {
      return null;
    }
  }
  //gender

  String? validationGender(dynamic gender) {
    if (gender == null) {
      return AppLocalizations.of(context)!.translate('validation_gender');
    } else {
      return null;
    }
  }

  ///!payment section
  // card name
  String? validationCardName(String? cardName) {
    if (cardName!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('card_name_validation');
    } else {
      return null;
    }
  }

  // card number
  String? validationCardNumber(String? cardNumber) {
    if (cardNumber!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('card_number_validation');
    } else {
      return null;
    }
  }

  // card expiry date
  String? validationCardExpiryDate(String? cardExpiryDate) {
    if (cardExpiryDate!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('expiration_date');
    } else {
      return null;
    }
  }

  // card cvv

  String? validationCardCvv(String? cardCvv) {
    if (cardCvv!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('card_cvv_validation');
    } else {
      return null;
    }
  }
}
