import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/features/auth/presentation/cubit/login/login_cubit.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/utils/assets_manager.dart';
import '../../../../../core/widgets/buttons/default_button.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';
import '../../../../../core/widgets/text_fields/validation_mixin.dart';
import '../../widgets/social_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with ValidationMixin {
  final emailController = TextEditingController();
  // final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  // final newPasswordController = TextEditingController();
  // final confirNewPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    // phoneController.dispose();
    passwordController.dispose();
    // newPasswordController.dispose();
    // confirNewPasswordController.dispose();
  }

  bool credentialsIsSaved = false;

  @override
  Widget build(BuildContext context) {
    var appTranslations = AppLocalizations.of(context)!;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          Constants.showError(context, state.message);
        } else if (state is LoginSuccessState) {
          Navigator.of(context).pushReplacementNamed(Routes.home);
        } else if (state is LoginErrorState) {
          Constants.showError(context, state.message);
        }
      },
      builder: (context, state) {
        return signInWidget(context, appTranslations, state);
      },
    );
  }

  Form signInWidget(BuildContext context, AppLocalizations appTranslations,
      LoginState state) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            height: context.height * 0.045,
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
          GestureDetector(
            onTap: () {
              setState(() {
                credentialsIsSaved = !credentialsIsSaved;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                        splashRadius: 0.1,
                        activeColor: AppColors.primaryColor,
                        checkColor: Colors.white,
                        side: BorderSide(color: AppColors.primaryColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: AppColors.primaryColor)),
                        value: credentialsIsSaved,
                        onChanged: (value) {
                          setState(() {
                            credentialsIsSaved = value!;
                          });
                        }),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${appTranslations.translate(AppLocalizationStrings.rememberMe)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
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
                onTap: (() {}),
                title:
                    '${appTranslations.translate(AppLocalizationStrings.facebook)}',
                iconUrl: AppImageAssets.facebookIcon,
              ),
              SizedBox(
                width: context.width * 0.06,
              ),
              SocialMediaWidget(
                onTap: (() {}),
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
              isLoading: state is LoginLoadingState,
              label:
                  '${appTranslations.translate(AppLocalizationStrings.signin)}',
              onTap: () {
                if (formKey.currentState!.validate()) {
                  context.read<LoginCubit>().login(
                      email: emailController.text,
                      password: passwordController.text,
                      credentialsIsSaved: credentialsIsSaved);
                }
              }),
          SizedBox(
            height: context.height * 0.02,
          ),
          // InkWell(
          //   onTap: () {
          //     Navigator.pushNamed(context, Routes.resetPassword);
          //   },
          //   child: Text(
          //     '${appTranslations.translate(AppLocalizationStrings.resetYourPassword)}',
          //     style: Theme.of(context).textTheme.bodySmall!.copyWith(
          //           decoration: TextDecoration.underline,
          //         ),
          //   ),
          // )
        ],
      ),
    );
  }
}
