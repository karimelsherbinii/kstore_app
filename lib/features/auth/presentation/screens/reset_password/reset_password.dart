import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/alert_widget.dart';
import 'package:kstore/core/widgets/buttons/default_button.dart';
import 'package:kstore/core/widgets/screen_container.dart';
import 'package:kstore/core/widgets/text_fields/validation_mixin.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/utils/assets_manager.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';
import '../../cubit/auth_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with ValidationMixin {
  final newPasswordController = TextEditingController();
  final confirNewPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    newPasswordController.dispose();
    confirNewPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appTranslations = AppLocalizations.of(context)!;
    return ScreenContainer(
        child: Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Constants.getAppBar(context,
                  title:
                      '${appTranslations.translate(AppLocalizationStrings.resetPassword)}',
                  moreHeight: true),
              Padding(
                padding: EdgeInsets.all(Constants.getScreenMargin(context)),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${appTranslations.translate(AppLocalizationStrings.resetPasswordMessage)}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: context.width * 0.035),
                  ),
                ),
              ),
              DefaultTextFormField(
                keyboardType: TextInputType.visiblePassword,
                haveShadow: true,
                radius: 10,
                hintTxt:
                    '${appTranslations.translate(AppLocalizationStrings.newPassword)}',
                controller: newPasswordController,
                isObscured: true,
                validationFunction: validateNewPassword,
              ),
              SizedBox(
                height: context.height * 0.02,
              ),
              DefaultTextFormField(
                keyboardType: TextInputType.visiblePassword,
                haveShadow: true,
                radius: 10,
                hintTxt:
                    '${appTranslations.translate(AppLocalizationStrings.confirmNewPassword)}',
                controller: confirNewPasswordController,
                isObscured: true,
                validationFunction: validateConfirmPassword,
              ),
              SizedBox(
                height: context.height * 0.07,
              ),
              DefaultButton(
                  label:
                      '${appTranslations.translate(AppLocalizationStrings.submit)}',
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertWidget(
                                appTranslations: appTranslations,
                                title:
                                    '${appTranslations.translate(AppLocalizationStrings.passwordChangedSuccessfully)}',
                                buttonText:
                                    '${appTranslations.translate(AppLocalizationStrings.goToHomePage)}',
                                onTap: () =>
                                    Navigator.pushNamed(context, Routes.home),
                              ));
                    }
                  }),
            ],
          ),
        ),
      )),
    ));
  }
}
