import 'package:flutter/material.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import '../utils/app_colors.dart';

// ignore: must_be_immutable
class DefaultDropdownButtonFormField extends StatefulWidget {
  final List<DropdownMenuItem<dynamic>> items;
  final dynamic value;
  final String? hintTxt;
  final String? Function(dynamic)? validationFunction;
  final Function(dynamic)? onChangedFunction;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? icon;
  final Widget? prefix;
  final Widget? prefixIcon;
  String title = 'العنوان';
  final String? labelTxt;
  final bool isExpanded;
  final AutovalidateMode autovalidateMode;
  final Color? unfocusColor;
  final Color? hintColor;
  final Color? filledColor;
  final bool filled;
  bool withTitle = false;
  final bool haveShadow;
  bool isUnderLine = false;
  final double? fieldMargin;

  DefaultDropdownButtonFormField({
    Key? key,
    required this.items,
    this.value,
    this.icon,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.hintTxt,
    this.validationFunction,
    this.onChangedFunction,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.labelTxt,
    this.isExpanded = true,
    this.unfocusColor,
    this.hintColor,
    this.filled = true,
    this.filledColor,
    this.haveShadow = false,
    this.isUnderLine = false,
    this.fieldMargin,
  }) : super(key: key);
  DefaultDropdownButtonFormField.withTitle({
    Key? key,
    required this.items,
    this.value,
    this.icon,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.hintTxt,
    this.validationFunction,
    this.onChangedFunction,
    required this.title,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.labelTxt,
    this.isExpanded = true,
    this.unfocusColor,
    this.hintColor,
    this.filled = true,
    this.filledColor,
    this.withTitle = true,
    this.haveShadow = false,
    this.fieldMargin,
  }) : super(key: key);
  DefaultDropdownButtonFormField.isUnderLine({
    Key? key,
    required this.items,
    this.value,
    this.icon,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.hintTxt,
    this.validationFunction,
    this.onChangedFunction,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.labelTxt,
    this.isExpanded = true,
    this.unfocusColor,
    this.hintColor,
    this.filled = true,
    this.filledColor,
    this.haveShadow = false,
    this.isUnderLine = true,
    this.fieldMargin,
  }) : super(key: key);
  @override
  State<DefaultDropdownButtonFormField> createState() =>
      _DefaultDropdownButtonFormFieldState();
}

class _DefaultDropdownButtonFormFieldState
    extends State<DefaultDropdownButtonFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.withTitle
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.3, vertical: 0.3),
                child: Padding(
                  padding: EdgeInsets.only(
                    right: context.width * 0.05,
                  ),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        color: AppColors.secandryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              )
            : Container(),
        const SizedBox(height: 10),
        Container(
            margin: EdgeInsets.symmetric(
              horizontal: widget.withTitle ? widget.fieldMargin ?? 0 : 16,
            ),
            decoration: widget.haveShadow
                ? BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  )
                : null,
            child: DropdownButtonFormField(
              borderRadius: BorderRadius.circular(10),
              autovalidateMode: widget.autovalidateMode,
              icon: widget.icon ??
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: widget.withTitle
                        ? AppColors.appGreyColor
                        : AppColors.hintColor,
                  ),
              style: Theme.of(context).textTheme.labelSmall,
              
              value: widget.value,
              isExpanded: widget.isExpanded,
              decoration: InputDecoration(
                border: widget.isUnderLine
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.hintColor,
                          width: 0,
                        ),
                      )
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: widget.withTitle
                              ? AppColors.appGreyColor
                              : AppColors.hintColor,
                        ),
                      ),
                enabledBorder: widget.isUnderLine
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.hintColor,
                          width: 0,
                        ),
                      )
                    : null,
                focusedBorder: widget.isUnderLine
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.hintColor,
                          width: 0,
                        ),
                      )
                    : null,
                filled: widget.filled ? true : false,
                fillColor: widget.filledColor ?? Colors.white,
                suffix: widget.suffix,
                suffixIcon: widget.suffixIcon,
                prefix: widget.prefix,
                prefixIcon: widget.prefixIcon,
                hintText: widget.hintTxt,
                labelText: widget.labelTxt,
              ),
              onChanged: widget.onChangedFunction,
              items: widget.items,
              validator: widget.validationFunction,
            )),
      ],
    );
  }
}
