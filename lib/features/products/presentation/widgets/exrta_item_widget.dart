import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/assets_manager.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/features/splash/presentation/cubit/locale_cubit.dart';

import '../../../../core/utils/hex_color.dart';

class ExtraItemWidget extends StatefulWidget {
  final Function()? onTap;
  final String title;
  final String? image;
  final Function()? onTapAdd;
  final Function()? onMinusTap;
  final bool haveAddButton;
  final double? width;
  final double? height;
  final int? quantity;
  final int? price;
  final bool fromCart;

  const ExtraItemWidget({
    Key? key,
    this.onTap,
    required this.title,
    this.image,
    this.onTapAdd,
    this.onMinusTap,
    this.haveAddButton = true,
    this.width,
    this.height,
    this.quantity,
    this.price,
    this.fromCart = false,
  }) : super(key: key);

  @override
  State<ExtraItemWidget> createState() => _ExtraItemWidgetState();
}

class _ExtraItemWidgetState extends State<ExtraItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, // widget.onTap,//TODO: will be removed
      child: Container(
        width: widget.width ?? context.width * 0.2,
        height: widget.height ?? context.height * 0.1,
        margin: EdgeInsets.symmetric(horizontal: context.width * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HexColor('#F2F2F2'), width: 1),
        ),
        child: Stack(
          children: [
            widget.image != null
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.network(
                      widget.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppImageAssets.whiteImage,
                          fit: BoxFit.cover,
                          width: widget.width ?? context.width * 0.2,
                          height: widget.height ?? context.height * 0.1,
                        );
                      },
                      width: widget.width ?? context.width * 0.2,
                      height: widget.height ?? context.height * 0.1,
                    ),
                  )
                : Container(),
            !widget.fromCart
                ? Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: context.width * 0.1,
                      height: context.height * 0.03,
                      child: Center(
                        child: Text(
                          '\$${widget.price ?? '\$1'}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            widget.haveAddButton
                ? GestureDetector(
                    onTap:
                        // () {},
                        widget.onTapAdd,
                    ////TODO: will be removed
                    child: Align(
                      alignment:
                          context.read<LocaleCubit>().currentLangCode == 'ar'
                              ? Alignment.bottomLeft
                              : Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          AppImageAssets.plusIcon,
                          width: 15,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  )
                : Container(),
            widget.haveAddButton
                ? GestureDetector(
                    onTap:
                        // () {},
                        widget.onMinusTap,
                    child: Align(
                      alignment:
                          context.read<LocaleCubit>().currentLangCode == 'ar'
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          AppImageAssets.minusIcon,
                          width: 15,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  )
                : Container(),
            //quantity in center bottom
            Positioned(
              bottom: -3,
              right: 0,
              left: 0,
              child: SizedBox(
                width: double.infinity,
                height: context.height * 0.03,
                child: Center(
                  child: Text(
                    widget.quantity.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            //?TODO this widget fo pause use exrta item widget
            // Container(
            //     color: Colors.black.withOpacity(0.2),
            //     width: double.infinity,
            //     height: double.infinity,
            //     child: Center(
            //       child: Transform(
            //         alignment: Alignment.center,
            //         transform: Matrix4.rotationZ(
            //             context.read<LocaleCubit>().currentLangCode == 'ar'
            //                 ? 180 * 3.14 / 180
            //                 : 0.4),
            //         child: Text(
            //           'soon',
            //           style: const TextStyle(
            //             color: Colors.black,
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ))
          ],
        ),
      ),
    );
  }
}
