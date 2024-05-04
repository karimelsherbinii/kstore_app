import 'package:flutter/material.dart';
import 'package:kstore/core/utils/media_query_values.dart';

import '../../utils/app_colors.dart';

Future<dynamic> showDefaultButtomSheet(
  BuildContext context, {
  required String title,
  required Widget body,
  bool bodyScrollable = false,
  bool isDismissible = false,
  bool withCloseIcon = true,
}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: bodyScrollable,
    isDismissible: isDismissible,
    enableDrag: false,
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Container(
                height: 8,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.appGreyColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (!withCloseIcon)
              Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF6B482F),
                        fontSize: 16,
                        fontFamily: 'Qatar2022 Arabic',
                        fontWeight: FontWeight.w700,
                      ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: const Color(0xFF6B482F),
                              fontSize: 16,
                              fontFamily: 'Qatar2022 Arabic',
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            body,
          ],
        ),
      ),
    ),
  );
}
