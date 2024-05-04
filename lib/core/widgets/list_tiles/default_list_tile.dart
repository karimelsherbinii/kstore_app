import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/app_colors.dart';

class DefaultListTile extends StatefulWidget {
  final bool isSelected;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final String title;
  final String subTitle;
  final String iconPath;
  final bool isOutLineBorder;
  const DefaultListTile(
      {super.key,
      this.backgroundColor,
      this.isSelected = false,
      this.width,
      this.height,
      required this.title,
      required this.subTitle,
      required this.iconPath,
      this.isOutLineBorder = false});
  const DefaultListTile.outLineBorder(
      {super.key,
      this.backgroundColor,
      this.isSelected = false,
      this.width,
      this.height,
      required this.title,
      required this.subTitle,
      required this.iconPath,
      this.isOutLineBorder = true});

  @override
  State<DefaultListTile> createState() => _SelectorListTileState();
}

class _SelectorListTileState extends State<DefaultListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: Colors.white,
          border: widget.isOutLineBorder
              ? Border.all(color: AppColors.outLineBorderColor)
              : null),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListTile(
          visualDensity: VisualDensity(horizontal: -4, vertical: -1),
          contentPadding: EdgeInsets.zero,
          title: Text(
            widget.title,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: SvgPicture.asset(
              widget.iconPath,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
