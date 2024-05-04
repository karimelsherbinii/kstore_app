import 'dart:async';

import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kstore/config/routes/app_routes.dart';
import 'package:kstore/core/api/cach_helper.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/app_strings.dart';
import 'package:kstore/core/utils/assets_manager.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:kstore/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:kstore/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:kstore/features/settings/presentation/cubit/settings_cubit.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/widgets/notificatoins_label.dart';

class HomeAppBar extends StatefulWidget {
  final bool moreHeight;
  final bool haveLeading;
  final VoidCallback? onTap;

  const HomeAppBar(
      {super.key,
      this.onTap,
      this.moreHeight = false,
      this.haveLeading = true});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  late Timer _waveTimer;
  bool _waveHandIsRunning = true;

  _getUserInfo() async {
    await context.read<ProfileCubit>().getUserInfo();
  }

  bool isAuthenticated = CacheHelper.getData(key: AppStrings.token) != null;

  @override
  void initState() {
    super.initState();
    if (isAuthenticated) {
      _getUserInfo();
    }

    _waveTimer = Timer.periodic(const Duration(seconds: 8), (Timer timer) {
      setState(() {
        _waveHandIsRunning = !_waveHandIsRunning;
      });
    });
  }

  @override
  void dispose() {
    _waveTimer.cancel();
    super.dispose();
  }

  var selectedLocation = 'Cairo';

  @override
  Widget build(BuildContext context) {
    var translator = AppLocalizations.of(context)!;
    return PreferredSize(
      preferredSize: Size.fromHeight(
        widget.moreHeight ? 70 : 50,
      ),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return AppBar(
            toolbarHeight: widget.moreHeight ? 70 : 50,
            backgroundColor: context.read<SettingsCubit>().currentDarkModeState
                ? AppColors.darkBackground
                : Colors.white,
            elevation: 0,
            leading: widget.haveLeading
                ? RotatedBox(
                    quarterTurns: translator.isArLocale ? 2 : 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          AppImageAssets.menu,
                          color:
                              context.read<SettingsCubit>().currentDarkModeState
                                  ? Colors.white
                                  : Colors.black,
                        ),
                        onPressed: widget.onTap ??
                            () {
                              Navigator.pushNamed(
                                  context, Routes.settingsScreen);
                            },
                      ),
                    ),
                  )
                : null,
            title: BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (context.read<ProfileCubit>().user == null) {
                  return Image.asset(
                    AppImageAssets.kstorelogo,
                    height: 50,
                    width: 80,
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!kIsWeb)
                        AnimatedEmoji(
                          AnimatedEmojis.waveLight,
                          repeat: _waveHandIsRunning,
                        ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${translator.translate('hi')!} ${getUserName()}',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: context
                                        .read<SettingsCubit>()
                                        .currentDarkModeState
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: context.width * 0.04,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                height: 30 / 24),
                      ),
                    ],
                  ),
                );
              },
            ),
            // DefaultDropdownButtonFormField(
            //     hintTxt: context.read<HomeCubit>().userLocatoin,
            //     hintColor: Colors.black,
            //     value: selectedLocation,
            //     onChangedFunction: (value) {
            //       setState(() {
            //         selectedLocation = value.toString();
            //       });
            //     },
            //     items: context.read<HomeCubit>().locations.map((item) {
            //       return DropdownMenuItem<String>(
            //         value: item,
            //         child: Text(item,
            //             textAlign: TextAlign.center,
            //             style:
            //                 Theme.of(context).textTheme.displayLarge!.copyWith(
            //                       color: Colors.black,
            //                       fontSize: context.width * 0.04,
            //                       fontWeight: FontWeight.w600,
            //                       letterSpacing: 0.5,
            //                       height: 30 / 24,
            //                     )),
            //       );
            //     }).toList()),
            centerTitle: true,
            titleTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Colors.black,
                fontSize: context.width * 0.04,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                height: 30 / 24),
            actions: [
              if (context.read<LoginCubit>().authenticatedUser != null)
                BlocBuilder<NotificationsCubit, NotificationsState>(
                  // buildWhen: (previous, current) => previous != current,
                  builder: (context, state) {
                    return const NotificationLabelAlert();
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  String getUserName() {
    if (context.read<ProfileCubit>().user != null) {
      if (context.read<ProfileCubit>().user!.firstName == null) {
        return context.read<ProfileCubit>().user?.email!.split('@')[0] ?? '';
      } else {
        return context.read<ProfileCubit>().user?.firstName ?? '';
      }
    } else {
      return '';
    }
  }
}
