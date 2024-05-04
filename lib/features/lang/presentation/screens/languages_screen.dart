import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/core/api/cach_helper.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/default_widget_tree.dart';
import 'package:kstore/features/splash/presentation/cubit/locale_cubit.dart';
import 'package:kstore/features/splash/presentation/cubit/locale_states.dart';
import 'package:kstore/restart_app.dart';

import '../../../../config/locale/app_localizations.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  @override
  Widget build(BuildContext context) {
    var appTranslations = AppLocalizations.of(context)!;
      var langIsSelected = CacheHelper.getData(key: 'langIsSelected') ?? false;

    return DefaultWidgetTree(
        haveAppBar: true,
        appBarTitle: appTranslations.translate('languages'),
        haveLeading: langIsSelected,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.getScreenMargin(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.height * 0.02,
              ),
              Text('${appTranslations.translate('suggested')}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: AppColors.secandryColor, fontSize: 18)),
              SizedBox(
                height: context.height * 0.02,
              ),
              BuildLanguages(appTranslations: appTranslations),
            ],
          ),
        ));
  }
}

class BuildLanguages extends StatefulWidget {
  const BuildLanguages({
    Key? key,
    required this.appTranslations,
  }) : super(key: key);

  final AppLocalizations appTranslations;

  @override
  State<BuildLanguages> createState() => _BuildLanguagesState();
}

class _BuildLanguagesState extends State<BuildLanguages> {
  var languages = ['en', 'ar'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleStates>(
      builder: (context, state) {
        return Column(children: [

          ...languages.map((lang) => InkWell(
                onTap: () {
                  setState(() {
                    BlocProvider.of<LocaleCubit>(context).changeLanguage(lang);
                    CacheHelper.saveData(key: 'langIsSelected', value: true);
                    RestartWidget.restartApp(context);
                  });
                },
                child: ListTile(
                  title: Text(
                      '${widget.appTranslations.translate(lang == 'en' ? 'english' : 'arabic')} (${lang.toUpperCase()})',
                      style: Theme.of(context).textTheme.bodyMedium!),
                  trailing: Container(
                    width: context.width * 0.075,
                    decoration: BoxDecoration(
                      color: context.read<LocaleCubit>().currentLangCode == lang
                          ? AppColors.primaryColor
                          : AppColors.appGreyColor,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Center(
                        child: CircleAvatar(
                          radius: 7,
                          backgroundColor:
                              context.read<LocaleCubit>().currentLangCode ==
                                      lang
                                  ? AppColors.whiteColor
                                  : AppColors.appGreyColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ))
        ]);
      },
    );
  }
}
