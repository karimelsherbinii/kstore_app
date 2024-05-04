import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/assets_manager.dart';
import 'package:kstore/core/utils/hex_color.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/buttons/default_button.dart';
import 'package:kstore/core/widgets/text_fields/default_text_field.dart';
import 'package:kstore/core/widgets/text_fields/validation_mixin.dart';
import 'package:kstore/features/location/presentation/cubit/location_cubit.dart';
import 'package:kstore/features/splash/presentation/cubit/locale_cubit.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_localization_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../../../../core/widgets/screen_container.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> with ValidationMixin {
  @override
  Widget build(BuildContext context) {
    var appTranslations = AppLocalizations.of(context)!;

    return ScreenContainer(
        child: Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              right: context.width * 0.07,
              left: context.width * 0.07,
              top: context.width * 0.07,
            ),
            width: context.width,
            height: context.height * 0.2,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImageAssets.currentLocation,
                      width: context.width * 0.07,
                    ),
                    SizedBox(
                      width: context.width * 0.05,
                    ),
                    Text(
                        '${appTranslations.translate(AppLocalizationStrings.useCurrentLocation)}'),
                  ],
                ),
                SizedBox(
                  height: context.height * 0.02,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: DefaultTextFormField(
                        fieldHeight: 12,
                        fieldWidth: context.width * 0.61,
                        keyboardType: TextInputType.name,
                        // haveShadow: true,
                        borderColor: HexColor('#F4F4F4'),
                        radius: 10,
                        hintTxt:
                            '${appTranslations.translate(AppLocalizationStrings.name)}',
                        controller:
                            context.read<LocationCubit>().locationController,
                        isObscured: false,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertWidget(
                                  appTranslations: appTranslations,
                                  buttonText:
                                      '${appTranslations.translate(AppLocalizationStrings.allowAccess)}',
                                  title:
                                      '${appTranslations.translate(AppLocalizationStrings.locationPermission)}',
                                  message:
                                      '${appTranslations.translate(AppLocalizationStrings.locationPermissionMessage)}',
                                  onTap: () =>
                                      Navigator.pushNamed(context, Routes.home),
                                ));
                      },
                      child: Container(
                          padding: EdgeInsets.all(context.width * 0.016),
                          width: context.width * 0.15,
                          height: context.width * 0.1,
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: SvgPicture.asset(
                            AppImageAssets.currentLocation,
                            color: Colors.white,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: context.height * 0.2,
          ),
          const Text('THE MAP...'),
        ],
      )),
    ));
  }
}
