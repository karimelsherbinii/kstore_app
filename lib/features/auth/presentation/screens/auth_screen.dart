import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/hex_color.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/screen_container.dart';
import 'package:kstore/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kstore/features/settings/presentation/cubit/settings_cubit.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/widgets/text_fields/validation_mixin.dart';
import '../widgets/tap_widget.dart';
import 'signin/signin_screen.dart';
import 'signup/signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with ValidationMixin {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().selectSignInPage();
  }

  @override
  Widget build(BuildContext context) {
    var appTranslations = AppLocalizations.of(context)!;

    return ScreenContainer(child: Scaffold(
      body: SingleChildScrollView(child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Column(
            children: [
              Constants.getAppBar(context,
                  title:
                      '${appTranslations.translate(AppLocalizationStrings.welcome)}',
                  moreHeight: true,
                  haveLeading: false),
              SizedBox(
                height: context.height * 0.02,
              ),
              Container(
                height: context.height * 0.055,
                width: context.width * 0.9,
                decoration: BoxDecoration(
                  color: context.read<SettingsCubit>().currentDarkModeState
                      ? AppColors.appAccentDarkColor
                      : HexColor('#F8F9FB'),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TapWidget(
                      title:
                          '${appTranslations.translate(AppLocalizationStrings.signup)}',
                      isSelected: context.read<AuthCubit>().signUpIsSelected,
                      onTap: () {
                        BlocProvider.of<AuthCubit>(context).selectSignUpPage();
                      },
                    ),
                    TapWidget(
                      title:
                          '${appTranslations.translate(AppLocalizationStrings.signin)}',
                      isSelected: context.read<AuthCubit>().signInIsSelected,
                      onTap: () {
                        BlocProvider.of<AuthCubit>(context).selectSignInPage();
                      },
                    ),
                  ],
                ),
              ),
              //! screens
              context.read<AuthCubit>().signInIsSelected
                  ? const SignUpScreen()
                  : const SignInScreen(),
            ],
          );
        },
      )),
    ));
  }
}
