import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/app_colors.dart';
import '../../utils/hex_color.dart';

class SelectorListTile extends StatefulWidget {
  final bool isSelected;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final String title;
  final String subTitle;
  final String iconPath;
  final bool isOutLineBorder;
  const SelectorListTile(
      {super.key,
      this.backgroundColor,
      this.isSelected = false,
      this.width = 345,
      this.height = 88,
      required this.title,
      required this.subTitle,
      required this.iconPath,
      this.isOutLineBorder = false});
  const SelectorListTile.outLineBorder(
      {super.key,
      this.backgroundColor,
      this.isSelected = false,
      this.width = 345,
      this.height = 88,
      required this.title,
      required this.subTitle,
      required this.iconPath,
      this.isOutLineBorder = true});

  @override
  State<SelectorListTile> createState() => _SelectorListTileState();
}

class _SelectorListTileState extends State<SelectorListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (widget.isSelected && widget.isOutLineBorder) ? 355 : widget.width,
      height:
          (widget.isSelected && widget.isOutLineBorder) ? 90 : widget.height,
      decoration: BoxDecoration(
          color: (widget.isSelected && !widget.isOutLineBorder)
              ? AppColors.primaryColor
              : (widget.isSelected && widget.isOutLineBorder)
                  ? HexColor('#00B8B2')
                  : widget.isOutLineBorder
                      ? Colors.white
                      : widget.backgroundColor ?? AppColors.hintColor,
          borderRadius: BorderRadius.circular(10),
          border: widget.isOutLineBorder
              ? Border.all(color: AppColors.outLineBorderColor)
              : null),
      child: ListTile(
        contentPadding: Theme.of(context).listTileTheme.contentPadding,
        leading: CircleAvatar(
          backgroundColor:
              widget.isOutLineBorder ? HexColor('#F5F5F5') : Colors.white,
          radius: 30,
          child: SvgPicture.asset(widget.iconPath),
        ),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.bold,
              color: widget.isSelected ? Colors.white : null,
              fontSize: widget.isOutLineBorder ? 18 : 16),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: !widget.isOutLineBorder ? 10 : 0),
          child: Text(
            widget.subTitle,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: widget.isSelected ? Colors.white : null,
                fontSize: widget.isOutLineBorder ? 13 : 14),
          ),
        ),
        trailing: widget.isOutLineBorder
            ? Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: HexColor('#00000040').withOpacity(0.3),
                ),
              )
            : null,
      ),
    );
  }
}
