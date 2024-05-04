import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kstore/config/routes/app_routes.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/features/auth/presentation/cubit/register/register_cubit.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/utils/assets_manager.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/buttons/default_button.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';
import '../../../../../core/widgets/text_fields/validation_mixin.dart';
import '../../cubit/auth_cubit.dart';
import '../../widgets/social_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with ValidationMixin {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appTranslations = AppLocalizations.of(context)!;
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterError) {
          Constants.showError(context, state.message);
        } else if (state is Authenticated) {
          Constants.showToast(msg: AppLocalizations.of(context)!.translate(
              AppLocalizationStrings.registerSuccessMessage)!);
          BlocProvider.of<AuthCubit>(context).selectSignInPage();
        }
        // else if (state is Unauthenticated) {
        //   Constants.showError(context, state.message);
        // }
      },
      builder: (context, state) {
        return signUpWidget(context, appTranslations, state);
      },
    );
  }

  Form signUpWidget(
      BuildContext context, AppLocalizations appTranslations, RegisterState state) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            height: context.height * 0.045,
          ),
          DefaultTextFormField(
            keyboardType: TextInputType.name,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 20, top: 10, bottom: 10),
              child: SvgPicture.asset(
                AppImageAssets.usericon,
              ),
            ),
            haveShadow: true,
            hintTxt:
                '${appTranslations.translate(AppLocalizationStrings.userName)}',
            controller: userNameController,
            isObscured: false,
            validationFunction: validateName,
          ),
          SizedBox(
            height: context.height * 0.03,
          ),
          DefaultTextFormField(
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 20, top: 10, bottom: 10),
              child: SvgPicture.asset(
                AppImageAssets.emailIcon,
                color: AppColors.primaryColor,
                width: 22,
              ),
            ),
            haveShadow: true,
            hintTxt:
                '${appTranslations.translate(AppLocalizationStrings.email)}',
            controller: emailController,
            isObscured: false,
            validationFunction: validateEmail,
          ),
          SizedBox(
            height: context.height * 0.03,
          ),
          DefaultTextFormField(
            keyboardType: TextInputType.visiblePassword,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 20, top: 10, bottom: 10),
              child: SvgPicture.asset(
                AppImageAssets.lockIcon,
              ),
            ),
            haveShadow: true,
            hintTxt:
                '${appTranslations.translate(AppLocalizationStrings.password)}',
            controller: passwordController,
            isObscured: true,
            validationFunction: validatePassword,
          ),
          SizedBox(
            height: context.height * 0.04,
          ),
          Center(
            child: Text(
              '${appTranslations.translate(AppLocalizationStrings.orContinueWith)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          SizedBox(
            height: context.height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialMediaWidget(
                title:
                    '${appTranslations.translate(AppLocalizationStrings.facebook)}',
                iconUrl: AppImageAssets.facebookIcon,
              ),
              SizedBox(
                width: context.width * 0.06,
              ),
              SocialMediaWidget(
                title:
                    '${appTranslations.translate(AppLocalizationStrings.google)}',
                iconUrl: AppImageAssets.googleIcon,
              ),
            ],
          ),
          SizedBox(
            height: context.height * 0.05,
          ),
          DefaultButton(
              isLoading: state is RegisterLoadingState,
              label:
                  '${appTranslations.translate(AppLocalizationStrings.signup)}',
              onTap: () {
                if (formKey.currentState!.validate()) {
                  context.read<RegisterCubit>().register(
                      userName: userNameController.text,
                      email: emailController.text,
                      password: passwordController.text);
                }
              }),
          SizedBox(
            height: context.height * 0.02,
          ),
          Constants.getRichText(
            context,
            haveThreeItems: true,
            textBody:
                '${appTranslations.translate(AppLocalizationStrings.termsOfUse)}',
            highlightText: '&',
            thirdItem:
                '${appTranslations.translate(AppLocalizationStrings.privacyPolicy)}',
          ),
          SizedBox(
            height: context.height * 0.03,
          ),
        ],
      ),
    );
  }
}
