import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/media_query_values.dart';

class SocialMediaWidget extends StatelessWidget {
  final String title;
  final String iconUrl;
  final Function()? onTap;
  const SocialMediaWidget({
    Key? key,
    required this.title,
    required this.iconUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onTap: onTap,
      child: Container(
          height: context.height * 0.06,
          width: context.width * 0.36,
          decoration: BoxDecoration(
              color:
                  //if theme dark
                  Theme.of(context).brightness == Brightness.dark
                      ? AppColors.appAccentDarkColor
                      : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ]),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(
              iconUrl,
              height: context.height * 0.03,
            ),
            SizedBox(
              width: context.width * 0.02,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ])),
    );
  }
}
