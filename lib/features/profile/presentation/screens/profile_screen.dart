import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/config/routes/app_routes.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/assets_manager.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/buttons/default_button.dart';
import 'package:kstore/core/widgets/default_widget_tree.dart';
import 'package:kstore/core/widgets/loading_indicator.dart';
import 'package:kstore/core/widgets/text_fields/default_text_field.dart';
import 'package:kstore/core/widgets/text_fields/validation_mixin.dart';
import 'package:kstore/features/profile/presentation/cubit/profile_cubit.dart';

import '../../../../core/utils/app_localization_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/default_drop_down_button_form_field.dart';
import '../widgets/profile_header_widget.dart';

class ProfileScreen extends StatefulWidget {
  final bool fromHome;
  const ProfileScreen({Key? key, this.fromHome = false}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with ValidationMixin {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  String selectedGender = 'male';

  _getUserInfo() async {
    await context.read<ProfileCubit>().getUserInfo();
  }

  _autoFillUserData() {
    var cubit = context.read<ProfileCubit>();
    if (cubit.user != null) {
      _firstNameController.text = cubit.user!.firstName ?? '';
      _lastNameController.text = cubit.user!.lastName ?? '';
      _emailController.text = cubit.user!.email ?? '';
      _phoneController.text = cubit.user!.phone ?? '';
      if (cubit.user!.birthDate != null) {
        _birthDateController.text = DateTime.parse(cubit.user!.birthDate!)
            .toLocal()
            .toString()
            .split(' ')[0];
      }

      pickedDate = _birthDateController.text;
    } else {
      _firstNameController.text = '';
      _lastNameController.text = '';
      _emailController.text = '';
      _phoneController.text = '';
      _birthDateController.text = '';
    }
  }

  Future<void> _loadData() async {
    await context.read<ProfileCubit>().getUserInfo();
    _autoFillUserData();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void deactivate() {
    super.deactivate();
    _getUserInfo();
  }

  String pickedDate = '';
  formattedPickedDate() {
    if (pickedDate.isNotEmpty) {
      var date = DateTime.parse(pickedDate);
      return '${date.year}-${date.month}-${date.day}';
    } else {
      return '';
    }
  }

  bool isValidePassword = false;
  bool isVisblePassword = false;

  @override
  Widget build(BuildContext context) {
    var translator = AppLocalizations.of(context)!;
    return DefaultWidgetTree(
        haveAppBar: true,
        onBack: () {
          if (widget.fromHome) {
            Navigator.pushReplacementNamed(context, Routes.home);
          } else {
            Navigator.pop(context);
          }
        },
        haveLeading: widget.fromHome ? false : true,
        appBarTitle: translator.translate('profile'),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is UpdateUserInfoLoadedState) {
              if (context.read<ProfileCubit>().user == null) {
                Constants.showError(context, 'Please login first');
              }
              Constants.showToast(msg: 'Updated Successfully');
              Navigator.pop(context);
            } else if (state is UpdateUserInfoErrorState) {
              Constants.showError(context, state.message);
            }
          },
          builder: (context, state) {
            var cubit = context.read<ProfileCubit>();
            if (state is GetUserInfoLoadingState) {
              return SizedBox(
                height: context.height * 0.8,
                child: const LoadingIndicator(),
              );
            }
            if (state is UpdateUserInfoLoadingState) {
              return Stack(
                children: [
                  buildBodyContent(context, cubit, translator, state),
                  const LoadingIndicator(),
                ],
              );
            } else {
              return buildBodyContent(context, cubit, translator, state);
            }
          },
        ));
  }

  Padding buildBodyContent(BuildContext context, ProfileCubit cubit,
      AppLocalizations translator, ProfileState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.02),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              ProfileHeaderWidget(
                name: cubit.user != null ? cubit.user!.userName ?? '' : '',
                email: cubit.user != null ? cubit.user!.email ?? '' : '',
              ),
              DefaultTextFormField.isUnderLineField(
                keyboardType: TextInputType.name,
                haveShadow: true,
                radius: 10,
                hintTxt:
                    '${translator.translate(AppLocalizationStrings.firstName)}',
                controller: _firstNameController,
                isObscured: false,
                validationFunction: validationFirstName,
              ),
              const SizedBox(height: 20),
              DefaultTextFormField.isUnderLineField(
                keyboardType: TextInputType.name,
                haveShadow: true,
                radius: 10,
                hintTxt:
                    '${translator.translate(AppLocalizationStrings.lastName)}',
                controller: _lastNameController,
                isObscured: false,
                validationFunction: validationLastName,
              ),
              const SizedBox(height: 20),
              DefaultTextFormField.isUnderLineField(
                keyboardType: TextInputType.emailAddress,
                haveShadow: true,
                radius: 10,
                hintTxt:
                    '${translator.translate(AppLocalizationStrings.email)}',
                controller: _emailController,
                isObscured: false,
                validationFunction: validateEmail,
              ),
              const SizedBox(height: 20),
              DefaultTextFormField.isUnderLineField(
                prefixIcon: SizedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppImageAssets.egyptIcon,
                        width: context.width * 0.08,
                      ),
                      SizedBox(
                        height: context.height * 0.04,
                        child: VerticalDivider(
                          color: AppColors.hintColor,
                          thickness: 0,
                          width: 10,
                        ),
                      )
                    ],
                  ),
                ),
                keyboardType: TextInputType.phone,
                haveShadow: true,
                radius: 10,
                hintTxt:
                    '${translator.translate(AppLocalizationStrings.phoneNumber)}',
                controller: _phoneController,
                isObscured: false,
                validationFunction: validatePhone,
              ),
              const SizedBox(height: 20),
              DefaultDropdownButtonFormField.isUnderLine(
                  hintTxt: 'Select your gender', //translator
                  hintColor: Colors.black,
                  onChangedFunction: (value) {
                    log('selectedFGendet is $value');
                    setState(() {
                      context.read<ProfileCubit>().selectedGender =
                          value.toString();
                    });
                    log('selectedGender iss ${context.read<ProfileCubit>().selectedGender}');
                  },
                  value: context.read<ProfileCubit>().user!.gender ??
                      context.read<ProfileCubit>().selectedGender,
                  validationFunction: validationGender,
                  items: context.read<ProfileCubit>().genders.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Colors.black,
                            fontSize: context.width * 0.04,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            height: 30 / 24),
                      ),
                    );
                  }).toList()),
              const SizedBox(height: 20),
              DefaultTextFormField.isUnderLineField(
                keyboardType: TextInputType.text,
                controller: _birthDateController,
                haveShadow: true,
                radius: 10,
                hintTxt: 'What is your birthday ?',
                // '${translator.translate(AppLocalizationStrings.whatIsYourBirthbay)}',
                // controller: cubit.addressController,
                isObscured: false,
                suffixIcon: InkWell(
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        pickedDate = date.toString();
                        _birthDateController.text = formattedPickedDate();
                      });
                    }
                  },
                  child: Image.asset(
                    AppImageAssets.calendarIcon,
                    // width: 40,
                  ),
                ),
                // validationFunction: validationAddress,
              ),
              const SizedBox(height: 20),
              DefaultButton(
                // isLoading: state is UpdateUserInfoLoadingState,
                width: MediaQuery.of(context).size.width * 0.5,
                label:
                    '${translator.translate(AppLocalizationStrings.updateProfile)}',
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return confirmDialog(translator, context);
                      });

                  // Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  confirmDialog(AppLocalizations translator, BuildContext context) {
    return StatefulBuilder(builder: (context, setFState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: const Text('Confirm by password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextFormField(
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 20, top: 10, bottom: 10),
                child: SvgPicture.asset(
                  AppImageAssets.lockIcon,
                ),
              ),
              haveShadow: true,
              hintTxt:
                  '${translator.translate(AppLocalizationStrings.password)}',
              passIsValid: isValidePassword,
              isObscured: true,
              controller: _passwordController,
              onChangedFunction: (value) {
                if (value!.length >= 8 && value.isNotEmpty) {
                  setFState(() {
                    isValidePassword = true;
                  });
                } else {
                  setFState(() {
                    isValidePassword = false;
                  });
                }
              },
              validationFunction: (value) {
                if (value!.isEmpty) {
                  isValidePassword = false;
                  return 'Password is required';
                } else if (value.length < 8) {
                  isValidePassword = false;
                  return 'Password must be at least 8 characters';
                } else {
                  return null;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.translate('cancel')!,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                log('password is ${_passwordController.text}');
                log('username is  ${_firstNameController.text}${_lastNameController.text}');
                log('birthDate is' + formattedPickedDate());
                log('gender is: ${context.read<ProfileCubit>().selectedGender}');
                Navigator.pop(context);
                context.read<ProfileCubit>().updateUserInfo(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      userName:
                          ' ${_firstNameController.text}${_lastNameController.text}',
                      email: _emailController.text,
                      password: _passwordController.text,
                      confirmPassword: _passwordController.text,
                      birthDate: formattedPickedDate(),
                      phone: _phoneController.text,
                      gender: context.read<ProfileCubit>().selectedGender ??
                          context.read<ProfileCubit>().user!.gender!,
                    );
              }
            },
            child: Text(AppLocalizations.of(context)!.translate('confirm')!,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      );
    });
  }
}
