import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:kstore/features/splash/presentation/cubit/locale_cubit.dart';

import '../../../config/locale/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../utils/hex_color.dart';

class DefaultTextFormField extends StatefulWidget {
  final bool enabled;
  final String? initialValue;
  final String? hintTxt;
  final bool borderIsEnabled;
  final String? title;
  final BoxShadow? shadowBox;
  final bool marginIsEnabled;
  final TextInputType? keyboardType;
  final bool isObscured;
  final double? radius;
  final double? margin;
  final double? fieldHeight;
  final bool readOnly;
  final bool haveShadow;
  final double? fieldWidth;
  final String? Function(String?)? validationFunction;
  final dynamic Function(String?)? onChangedFunction;
  final ValueChanged<String>? onFieldSubmitted;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final Widget? suffix;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefix;
  final Widget? prefixIcon;
  final String? labelTxt;
  final bool expands;
  final bool haveApplyButton;
  final bool isApplyed;
  final Function()? onTapApplyButton;
  final TextEditingController? controller;
  final Color? unfocusColor;
  final Color? hintColor;
  final Color? focusColor;
  final Color? filledColor;
  final Color? borderColor;
  final bool filled;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;
  final TextInputAction? textInputAction;
  final String? helperText;
  final TextStyle? hintTextStyle;
  final bool isUnderline;
  final bool withTitle;
  final bool passIsValid;

  const DefaultTextFormField({
    Key? key,
    this.hintTxt,
    this.onFieldSubmitted,
    this.keyboardType,
    this.borderIsEnabled = true,
    this.isObscured = false,
    this.readOnly = false,
    this.validationFunction,
    this.onChangedFunction,
    this.initialValue,
    this.suffixIcon,
    this.radius,
    this.maxLength,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.enabled = true,
    this.maxLines,
    this.expands = false,
    this.labelTxt,
    this.prefix,
    this.unfocusColor,
    this.hintColor,
    this.focusColor,
    this.suffix,
    this.filled = true,
    this.marginIsEnabled = true,
    this.filledColor,
    this.prefixIcon,
    this.controller,
    this.inputFormatters,
    this.textInputAction,
    this.onEditingComplete,
    this.onTap,
    this.helperText,
    this.borderColor,
    this.margin,
    this.haveShadow = false,
    this.hintTextStyle,
    this.title,
    this.fieldWidth,
    this.fieldHeight,
    this.shadowBox,
    this.haveApplyButton = false,
    this.isApplyed = false,
    this.onTapApplyButton,
    this.isUnderline = false,
    this.withTitle = false,
    this.passIsValid = false,
  }) : super(key: key);
  const DefaultTextFormField.withTitle({
    Key? key,
    this.hintTxt,
    this.onFieldSubmitted,
    this.keyboardType,
    this.borderIsEnabled = true,
    this.isObscured = false,
    this.readOnly = false,
    this.validationFunction,
    this.onChangedFunction,
    this.initialValue,
    this.suffixIcon,
    this.radius,
    this.maxLength,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.enabled = true,
    this.maxLines,
    this.expands = false,
    this.labelTxt,
    this.prefix,
    this.unfocusColor,
    this.hintColor,
    this.focusColor,
    this.suffix,
    this.filled = true,
    this.marginIsEnabled = true,
    this.filledColor,
    this.prefixIcon,
    this.controller,
    this.inputFormatters,
    this.textInputAction,
    this.onEditingComplete,
    this.onTap,
    this.helperText,
    this.borderColor,
    this.margin,
    this.haveShadow = false,
    this.hintTextStyle,
    this.title,
    this.fieldWidth,
    this.fieldHeight,
    this.shadowBox,
    this.haveApplyButton = false,
    this.isApplyed = false,
    this.onTapApplyButton,
    this.isUnderline = false,
    this.withTitle = true,
    this.passIsValid = false,
  }) : super(key: key);

  const DefaultTextFormField.isUnderLineField(
      {Key? key,
      this.hintTxt,
      this.onFieldSubmitted,
      this.keyboardType,
      this.borderIsEnabled = true,
      this.isObscured = false,
      this.readOnly = false,
      this.validationFunction,
      this.onChangedFunction,
      this.initialValue,
      this.suffixIcon,
      this.radius,
      this.maxLength,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.enabled = true,
      this.maxLines,
      this.expands = false,
      this.labelTxt,
      this.prefix,
      this.unfocusColor,
      this.hintColor,
      this.focusColor,
      this.suffix,
      this.filled = true,
      this.marginIsEnabled = true,
      this.filledColor,
      this.prefixIcon,
      this.controller,
      this.inputFormatters,
      this.textInputAction,
      this.onEditingComplete,
      this.onTap,
      this.helperText,
      this.borderColor,
      this.margin,
      this.haveShadow = false,
      this.hintTextStyle,
      this.title,
      this.fieldWidth,
      this.fieldHeight,
      this.shadowBox,
      this.haveApplyButton = false,
      this.isApplyed = false,
      this.onTapApplyButton,
      this.isUnderline = true,
      this.withTitle = false,
      this.passIsValid = false})
      : super(key: key);

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  bool _obsecureText = true;

  Widget _buildTextFormField() {
    return StatefulBuilder(
        builder: (context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.withTitle
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(widget.title ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w700)),
                      )
                    : Container(),
                TextFormField(
                  onFieldSubmitted: widget.onFieldSubmitted,
                  onEditingComplete: widget.onEditingComplete,
                  onTap: widget.onTap,
                  readOnly: widget.readOnly,
                  textInputAction: widget.textInputAction,
                  autovalidateMode: widget.autovalidateMode,
                  inputFormatters: widget.inputFormatters,
                  expands: widget.expands,
                  controller: widget.controller,
                  enabled: widget.enabled,
                  maxLines: widget.isObscured ? 1 : widget.maxLines,
                  maxLength: widget.maxLength,
                  initialValue: widget.initialValue,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: widget.fieldHeight ?? context.height * 0.025),
                    helperText: widget.helperText,
                    filled: widget.filled ? true : false,
                    fillColor: widget.filledColor ??
                        (context.read<SettingsCubit>().currentDarkModeState
                            ? AppColors.appAccentDarkColor
                            : Colors.white),
                    suffix: widget.suffix,
                    suffixIcon: widget.isObscured
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                _obsecureText = !_obsecureText;
                              });
                            },
                            child: Icon(
                              _obsecureText
                                  ? Icons.remove_red_eye
                                  : Icons.visibility_off,
                              color: widget.passIsValid == true
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                              size: 18,
                            ),
                          )
                        : widget.suffixIcon,
                    border: !widget.borderIsEnabled
                        ? InputBorder.none
                        : widget.isUnderline
                            ? UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.shadowColor, width: 3),
                                borderRadius:
                                    BorderRadius.circular(widget.radius ?? 15),
                              )
                            : OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(widget.radius ?? 15),
                                borderSide: BorderSide(
                                    color: widget.borderColor ??
                                        Colors.transparent)),
                    enabledBorder: !widget.borderIsEnabled
                        ? InputBorder.none
                        : widget.isUnderline
                            ? UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.shadowColor, width: 3),
                                borderRadius:
                                    BorderRadius.circular(widget.radius ?? 15),
                              )
                            : OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(widget.radius ?? 15),
                                borderSide: BorderSide(
                                    color: widget.borderColor ??
                                        AppColors.shadowColor)),
                    focusedBorder: !widget.borderIsEnabled
                        ? InputBorder.none
                        : widget.isUnderline
                            ? UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.shadowColor, width: 3),
                                borderRadius:
                                    BorderRadius.circular(widget.radius ?? 15),
                              )
                            : OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.primaryColor, width: 2),
                                borderRadius:
                                    BorderRadius.circular(widget.radius ?? 15),
                              ),
                    prefix: widget.prefix,
                    prefixIcon: widget.prefixIcon,
                    hintStyle: widget.hintTextStyle ??
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: HexColor('#959FAB'),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                    hintText: widget.hintTxt,
                    labelText: widget.labelTxt,
                  ),
                  keyboardType: widget.keyboardType ?? TextInputType.text,
                  obscureText: widget.isObscured ? _obsecureText : false,
                  validator: widget.validationFunction,
                  onChanged: widget.onChangedFunction,
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.fieldWidth ?? context.width * 0.9,
        decoration: widget.haveShadow
            ? BoxDecoration(boxShadow: [
                if (widget.shadowBox == null &&
                    !context.read<SettingsCubit>().currentDarkModeState)
                  BoxShadow(
                    color: widget.isUnderline
                        ? Colors.transparent
                        : Colors.grey[300]!.withOpacity(0.1),
                    offset: const Offset(0, 20),
                    blurRadius: 10,
                    spreadRadius: -15,
                  )
              ])
            : null,
        margin: EdgeInsets.symmetric(
            horizontal: widget.marginIsEnabled ? widget.margin ?? 16 : 0),
        child: Stack(children: [
          _buildTextFormField(),
          widget.haveApplyButton
              ? Positioned(
                  top: 0,
                  right: AppLocalizations.of(context)!.isArLocale
                      ? context.width * 0.7 - 10
                      : -10,
                  left: !AppLocalizations.of(context)!.isArLocale
                      ? context.width * 0.7 - 10
                      : -10,
                  bottom: 0,
                  child: Container(
                    width: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius:
                          context.read<LocaleCubit>().currentLangCode != 'ar'
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  bottomRight: Radius.circular(32))
                              : const BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  bottomLeft: Radius.circular(32)),
                    ),
                    child: TextButton(
                      onPressed: (widget.haveApplyButton && !widget.isApplyed)
                          ? widget.onTapApplyButton
                          : null,
                      child: widget.isApplyed
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : Text(
                              '${AppLocalizations.of(context)!.translate('apply')}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                )
              : Container(),
        ]));
  }
}
