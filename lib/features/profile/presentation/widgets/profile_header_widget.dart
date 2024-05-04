import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/assets_manager.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String email;
  const ProfileHeaderWidget({
    Key? key,
    required this.name,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppImageAssets.userProfileIcon,
          width: 80,
        ),
        Text(name, style: Theme.of(context).textTheme.headline6),
        Text(email, style: Theme.of(context).textTheme.subtitle2),
      ],
    );
  }
}
