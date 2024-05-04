import 'package:flutter/material.dart';
import 'package:kstore/core/utils/media_query_values.dart';

import '../../utils/app_colors.dart';

// ignore: must_be_immutable
class DefaultButton extends StatefulWidget {
  Color? textColor;
  double? textSize;
  final String label;
  final double? width;
  final double? height;
  Color? backgroudColor;
  final bool isAlertButton;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;
  final double? borderRadius;
  final Border? border;
  final FontWeight? fontWeight;
  final bool isLoading;
  DefaultButton({
    super.key,
    required this.label,
    this.onTap,
    this.textColor,
    this.textSize,
    this.width,
    this.backgroudColor,
    this.height,
    this.isAlertButton = false,
    this.boxShadow,
    this.borderRadius,
    this.border,
    this.fontWeight,
    this.isLoading = false,
  });

  DefaultButton.alert({
    super.key,
    required this.label,
    this.onTap,
    this.textColor,
    this.width = 189,
    this.backgroudColor,
    this.textSize,
    this.isAlertButton = true,
    this.height = 41,
    this.boxShadow,
    this.borderRadius,
    this.border,
    this.fontWeight,
    this.isLoading = false,
  });
  DefaultButton.onBoarding({
    super.key,
    required this.label,
    this.onTap,
    this.textSize,
    this.textColor,
    this.width = 295,
    this.backgroudColor,
    this.height = 50,
    this.isAlertButton = false,
    this.boxShadow,
    this.borderRadius,
    this.border,
    this.fontWeight,
    this.isLoading = false,
  });
  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          )
        : InkWell(
            onTap: widget.onTap,
            child: Container(
              width: widget.width ?? context.width * 0.4,
              height: widget.height ?? context.height * 0.06,
              decoration: BoxDecoration(
                color: widget.isAlertButton
                    ? AppColors.alertColor
                    : widget.backgroudColor ?? AppColors.primaryColor,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 15),
                boxShadow: widget.boxShadow ?? [],
                border: widget.border ?? const Border(),
              ),
              child: Center(
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.button!.copyWith(
                        color: widget.textColor,
                        fontSize: widget.textSize ?? 16,
                        fontWeight: widget.fontWeight ?? FontWeight.w600,
                      ),
                ),
              ),
            ),
          );
  }
}
