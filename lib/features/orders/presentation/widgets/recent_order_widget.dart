import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/assets_manager.dart';
import 'package:kstore/core/utils/hex_color.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/buttons/default_button.dart';
import 'package:kstore/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:kstore/features/orders/presentation/cubit/orders_state.dart';
import 'package:transparent_image/transparent_image.dart';

class RecentOrdersWidget extends StatelessWidget {
  final String name;
  final String imgPath;
  final String price;
  final String description;
  final String? rate;
  final String avilability;
  final Function()? onReorderTap;
  final Function()? onTap;
  final double? height;
  final double? width;
  final bool withShadow;
  final EdgeInsetsGeometry? margin;
  final bool abaleToReorder;
  final String? status;
  final Function()? onCancelTap;

  const RecentOrdersWidget(
      {super.key,
      required this.name,
      required this.imgPath,
      required this.price,
      required this.description,
      this.rate,
      this.onReorderTap,
      this.onTap,
      required this.avilability,
      this.height,
      this.width,
      this.withShadow = true,
      this.margin,
      this.abaleToReorder = true,
      this.status,
      this.onCancelTap});

  @override
  Widget build(BuildContext context) {
    if (context.width > 600) {
      return webWidget(context);
    } else {
      return mobileWidget(context);
    }
  }

  mobileWidget(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? context.height * 0.16,
        width: width ?? context.width * 0.9,
        margin: margin,
        padding: EdgeInsets.all(context.width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            withShadow
                ? BoxShadow(
                    color: AppColors.shadowColor,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  )
                : const BoxShadow(),
          ],
          border: !withShadow ? Border.all(color: HexColor('#F2F2F2')) : null,
        ),
        child: Row(
          children: [
            SizedBox(
                width: context.width * 0.25,
                height: context.height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: FadeInImage.memoryNetwork(
                        width: context.width,
                        placeholder: kTransparentImage,
                        image: imgPath,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(AppImageAssets.whiteImage,
                              fit: BoxFit.cover);
                        },
                        fit: BoxFit.fill),
                  ),
                )),
            SizedBox(
              width: context.width * 0.04,
            ),
            Expanded(
              // width: context.width * 0.48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.width,
                    child: Row(
                      children: [
                        SizedBox(
                          child: Text(name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: context.width * 0.0025,
                                  )),
                        ),
                        const Spacer(),
                        rate != null
                            ? SizedBox(
                                // height: context.height * 0.04,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        AppImageAssets.starRateIcon),
                                    Text(rate!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing:
                                                  context.width * 0.0015,
                                              color: AppColors.hintColor,
                                            )),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  Text(description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.titleSmall!.copyWith()),
                  const Spacer(),
                  //avilabilaty
                  Text(
                    avilability,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.avilableColor),
                  ),
                  SizedBox(
                    width: context.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: context.width * 0.2,
                          child: Text('\$$price',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: context.width * 0.0025,
                                  )),
                        ),
                        const Spacer(),
                        abaleToReorder
                            ? BlocBuilder<OrdersCubit, OrdersState>(
                                builder: (context, state) {
                                  return DefaultButton(
                                      isLoading: state is ReOrderLoadingState,
                                      width: context.width * 0.2,
                                      height: context.height * 0.04,
                                      backgroudColor: Colors.white,
                                      borderRadius: 10,
                                      textSize: 14,
                                      textColor: Colors.black,
                                      border: Border.all(
                                          color: HexColor('#F2F2F2')),
                                      fontWeight: FontWeight.w700,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.shadowColor
                                              .withOpacity(0.1),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      label:
                                          '${AppLocalizations.of(context)!.translate('reorder')}',
                                      onTap: onReorderTap);
                                },
                              )
                            : status == '1'
                                ? BlocBuilder<OrdersCubit, OrdersState>(
                                    builder: (context, state) {
                                      return DefaultButton(
                                          width: context.width * 0.2,
                                          height: context.height * 0.04,
                                          backgroudColor: Colors.red,
                                          borderRadius: 10,
                                          textSize: 14,
                                          textColor: Colors.white,
                                          border: Border.all(
                                              color: HexColor('#F2F2F2')),
                                          fontWeight: FontWeight.w700,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.shadowColor
                                                  .withOpacity(0.1),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          label:
                                              '${AppLocalizations.of(context)!.translate('cancel')}',
                                          onTap: onCancelTap);
                                    },
                                  )
                                : InkWell(
                                    //status of order
                                    child: SizedBox(
                                      width: 100,
                                      height: 30,
                                      child: Center(
                                        child: Text(
                                          status ?? '',
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container webWidget(BuildContext context) {
    return Container(
      height: height ?? context.height * 0.2,
      width: width ?? context.width * 0.4,
      margin: EdgeInsets.only(
        bottom: context.height * 0.015,
      ),
      padding: EdgeInsets.all(context.width * 0.009),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: context.width * 0.1,
            height: context.height,
            child: ClipRRect(
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SizedBox(
            width: context.width * 0.004,
          ),
          SizedBox(
            width: context.width * 0.27,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: context.width,
                  child: Row(
                    children: [
                      SizedBox(
                        child: Text(name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: context.width * 0.0025,
                                )),
                      ),
                      const Spacer(),
                      rate != null
                          ? SizedBox(
                              // height: context.height * 0.04,
                              child: Row(
                                children: [
                                  SvgPicture.asset(AppImageAssets.starRateIcon),
                                  Text(rate!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing:
                                                context.width * 0.0015,
                                            color: AppColors.hintColor,
                                          )),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                Text(description,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith()),
                const Spacer(),
                //avilabilaty
                Text(
                  avilability,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: AppColors.avilableColor),
                ),
                SizedBox(
                  width: context.width,
                  child: Row(
                    children: [
                      SizedBox(
                        width: context.width * 0.05,
                        child: Text('\$$price',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: context.width * 0.0025,
                                )),
                      ),
                      const Spacer(),
                      DefaultButton(
                          width: context.width * 0.07,
                          height: context.height * 0.04,
                          backgroudColor: Colors.white,
                          borderRadius: 10,
                          textSize: 14,
                          textColor: Colors.black,
                          border: Border.all(color: HexColor('#F2F2F2')),
                          fontWeight: FontWeight.w700,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColor.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          label:
                              '${AppLocalizations.of(context)!.translate('reorder')}',
                          onTap: onTap),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
