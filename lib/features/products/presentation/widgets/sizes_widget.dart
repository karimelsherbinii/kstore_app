import 'package:flutter/material.dart';
import 'package:kstore/core/utils/media_query_values.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/hex_color.dart';

class SizesWidget extends StatefulWidget {
  final Function()? onTap;
  final String title;
  final String subTitle;
  final bool isSelected;

  const SizesWidget({
    Key? key,
    this.onTap,
    required this.title,
    required this.subTitle,
    required this.isSelected,
  }) : super(key: key);

  @override
  State<SizesWidget> createState() => _SizesWidgetState();
}

class _SizesWidgetState extends State<SizesWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
          width: context.width * 0.2,
          height: context.height * 0.04,
          margin: EdgeInsets.symmetric(horizontal: context.width * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color:widget.isSelected ? AppColors.primaryColor : HexColor('#E5E5E5')),
          ),
          child: Center(
            child: Constants.getRichText(
              context,
              textBody: widget.title,
              textbodyColor: AppColors.hintColor,
              textBodySize: 14,
              textBodyWeight: FontWeight.w600,
              highlightText: widget.subTitle,
              highLightcolor: AppColors.secandryColor,
              highlightTextSize: 14,
              highlightWeight: FontWeight.w600,
            ),
          )),
    );
  }
}
