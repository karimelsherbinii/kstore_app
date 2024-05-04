import 'package:flutter/material.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:kstore/core/utils/media_query_values.dart';

import '../../config/locale/app_localizations.dart';
import '../utils/constants.dart';

class ViewAllListTile extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool haveViewAll;
  final bool isViewAll;
  const ViewAllListTile(
      {super.key,
      required this.title,
      required this.onTap,
      this.haveViewAll = true,
      required this.isViewAll});

  @override
  Widget build(BuildContext context) {
    var appTranslations = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constants.getScreenMargin(context)),
      child: Row(children: [
        Text(title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: context.width * 0.0025,
                )),
        const Spacer(),
        haveViewAll
            ? InkWell(
                onTap: onTap,
                child: Text(
                  isViewAll
                      ? '${appTranslations.translate(AppLocalizationStrings.seeLess)}'
                      : '${appTranslations.translate(AppLocalizationStrings.viewAll)}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.appGreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: context.width * 0.0005,
                      ),
                ),
              )
            : Container(),
      ]),
    );
  }
}
