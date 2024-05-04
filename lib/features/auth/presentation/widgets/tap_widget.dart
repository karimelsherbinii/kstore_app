import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/features/settings/presentation/cubit/settings_cubit.dart';

class TapWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function()? onTap;
  const TapWidget({
    Key? key,
    required this.title,
    required this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: context.width * 0.43,
        height: context.height * 0.045,
        margin: EdgeInsets.symmetric(horizontal: context.width * 0.01),
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.04,
          // vertical: context.height * 0.01,
        ),
        decoration: !isSelected
            ? BoxDecoration(
                color: !isSelected
                    ? context.read<SettingsCubit>().currentDarkModeState
                        ? AppColors.darkBackground
                        : Colors.white
                    : context.read<SettingsCubit>().currentDarkModeState
                        ? AppColors.darkBackground
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      // offset: const Offset(0, 2), // changes position of shadow
                    )
                  ])
            : BoxDecoration(
                color: !isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: context.width * 0.038),
          ),
        ),
      ),
    );
  }
}
