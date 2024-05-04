import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kstore/config/routes/app_routes.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/assets_manager.dart';
import 'package:kstore/core/utils/hex_color.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/text_fields/default_text_field.dart';
import 'package:kstore/features/products/presentation/cubit/products_cubit.dart';
import 'package:kstore/features/settings/presentation/cubit/settings_cubit.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/app_localization_strings.dart';
import '../cubit/home_cubit.dart';

class SearchWidget extends StatefulWidget {
  final Function()? onSearch;

  const SearchWidget({super.key, this.onSearch});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    var appTranslations = AppLocalizations.of(context)!;
    return DefaultTextFormField(
      hintTextStyle: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: HexColor('#A7A9B7'), fontSize: 14),
      filledColor: context.read<SettingsCubit>().currentDarkModeState
          ? AppColors.appAccentDarkColor
          : Colors.white,
      borderColor: AppColors.appGreyColor.withOpacity(0.2),
      controller: context.read<HomeCubit>().searchController,
      onTap: widget.onSearch,
      shadowBox: !context.read<SettingsCubit>().currentDarkModeState
          ? BoxShadow(
              color: AppColors.appGreyColor.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 10), // changes position of shadow
            )
          : null,
      radius: 12,
      haveShadow: true,
      prefixIcon: Padding(
        padding: EdgeInsets.only(
            left: context.width * 0.04, right: context.width * 0.02),
        child: SvgPicture.asset(
          AppImageAssets.searchIcon,
          color: context.read<SettingsCubit>().currentDarkModeState
              ? Colors.white
              : Colors.black,
        ),
      ),
      suffixIcon: Padding(
        padding: EdgeInsets.only(
            right: context.width * 0.04, left: context.width * 0.02),
        child: SvgPicture.asset(
          AppImageAssets.filterIcon,
          color: context.read<SettingsCubit>().currentDarkModeState
              ? Colors.white
              : Colors.black,
        ),
      ),
      unfocusColor: Colors.black,
      hintTxt:
          '${appTranslations.translate(AppLocalizationStrings.searchHintText)}',
      hintColor: context.read<SettingsCubit>().currentDarkModeState
          ? Colors.white
          : Colors.black,
      onChangedFunction: (value) {
        context.read<ProductsCubit>().clearData();
        context.read<ProductsCubit>().getProducts(searchQuery: value);
      },
    );
  }
}
