import 'package:flutter/material.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:kstore/core/utils/assets_manager.dart';
import 'package:kstore/core/utils/media_query_values.dart';

import '../../config/locale/app_localizations.dart';

class NoData extends StatelessWidget {
  final String? msg;

  const NoData({super.key, this.msg});

  @override
  Widget build(BuildContext context) {
    var translator = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppImageAssets.empty,
          // width: context.width * 0.5,
          // height: context.height * 0.3,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          msg ?? translator.translate(AppLocalizationStrings.noData)!,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
