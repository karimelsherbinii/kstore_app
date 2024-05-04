import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:kstore/core/utils/assets_manager.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:transparent_image/transparent_image.dart';

import '../utils/app_colors.dart';

class ProductItemWidget extends StatelessWidget {
  final String name;
  final String price;
  final String rate;
  final String image;
  final Function()? onTap;
  const ProductItemWidget(
      {super.key,
      required this.name,
      required this.price,
      required this.rate,
      required this.image,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: context.width > 600 ? context.width * 0.3 : context.width * 0.7,
        height: context.height * 0.2,
        margin: EdgeInsets.symmetric(
            // horizontal: context.width * 0.03,
            vertical: context.height * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: FadeInImage.memoryNetwork(
                width: context.width,
                placeholder: kTransparentImage,
                image: image,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(AppImageAssets.whiteImage,
                      fit: BoxFit.cover);
                },
                fit: BoxFit.fill),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            top: context.width > 600
                ? context.height * 0.17
                : context.height * 0.105,
            left: context.width * 0,
            child: Stack(
              children: [
                Container(
                  // height: context.height * 0.1,
                  width: context.width,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                  ),
                ).blurred(
                  colorOpacity: 0.01,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30)),
                  // blurColor: Colors.grey.shade400.withOpacity(0.002),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: context.width * 0.03,
                      right: context.width * 0.03,
                      top: context.height * 0.01,
                      bottom: context.height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: context.width * 0.0025,
                                  )),
                          const Spacer(),
                          Text(price,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: context.width * 0.0005,
                                  ))
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_purple500_outlined,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(
                            width: context.width * 0.01,
                          ),
                          Text(rate,
                              style: TextStyle(color: AppColors.whiteColor))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
