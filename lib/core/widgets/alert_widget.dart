import 'package:flutter/material.dart';
import 'package:kstore/core/utils/media_query_values.dart';

import '../../config/locale/app_localizations.dart';
import '../../config/routes/app_routes.dart';
import '../utils/app_colors.dart';
import '../utils/app_localization_strings.dart';
import 'buttons/default_button.dart';

class AlertWidget extends StatelessWidget {
  final String title;
  final String? message;
  final String buttonText;
  final VoidCallback onTap;
  const AlertWidget({
    Key? key,
    required this.appTranslations,
    required this.title,
    this.message,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  final AppLocalizations appTranslations;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.width * 0.5,
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: context.width * 0.05,
            vertical: context.width * 0.05,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.05, vertical: context.width * 0.1),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    fontSize: context.width * 0.06),
              ),
              SizedBox(
                height: context.height * 0.02,
              ),
              Text(
                message ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.hintColor, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: context.height * 0.02,
              ),
              DefaultButton(
                onTap: onTap,
                label: buttonText,
                height: context.height * 0.05,
                width: context.width * 0.5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
