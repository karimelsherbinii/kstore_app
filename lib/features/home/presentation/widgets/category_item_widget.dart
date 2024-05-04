import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kstore/core/utils/hex_color.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../core/utils/assets_manager.dart';

class CategoryItemWidget extends StatelessWidget {
  final String image;
  final String categoryName;
  final bool isGrid;
  final Function()? onTap;
  const CategoryItemWidget(
      {super.key,
      required this.image,
      required this.categoryName,
      this.onTap,
      required this.isGrid});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: context.width * 0.25,
        // height: context.height * 0.1,
        margin: EdgeInsets.symmetric(
          // horizontal: context.width * 0.03,
          vertical: context.height * 0.02,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.03,
          // vertical: context.height * 0.01,
        ),
        // constraints: BoxConstraints(
        //   minHeight: context.height * 0.1,
        //   minWidth: context.width * 0.25,
        //   // maxWidth: context.width * 0.3,
        //   maxHeight: context.height * 0.2,
        // ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HexColor('#F2F2F2')),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.01,
                    // vertical: context.height * 0.02,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.memoryNetwork(
                        width: !isGrid
                            ? context.width * 0.11
                            : context.width * 0.1,
                        placeholder: kTransparentImage,
                        image: image,
                        height: !isGrid
                            ? context.width * 0.11
                            : context.width * 0.1,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.network(
                              width: !isGrid
                                  ? context.width * 0.15
                                  : context.width * 0.1,
                              image,
                              fit: BoxFit.cover);
                        },
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  categoryName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    color: HexColor('#333333'),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
