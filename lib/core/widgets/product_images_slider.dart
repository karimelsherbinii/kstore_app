import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class ProductImagesSliderWidget extends StatefulWidget {
  final List<dynamic> banners;
  const ProductImagesSliderWidget({Key? key, required this.banners}) : super(key: key);

  @override
  State<ProductImagesSliderWidget> createState() => _CustomProductImagesSliderWidgetState();
}

class _CustomProductImagesSliderWidgetState extends State<ProductImagesSliderWidget> {
  int activeIndex = 0;
  @override
  void initState() {
    buildDotsIndicator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white
      ),
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: widget.banners.length,
            itemBuilder: (context, index, realIndex) {
              return buildImage(imageUrl: widget.banners[index]);
            },
            options: CarouselOptions(
                height: context.height * 0.35,
                autoPlay: false,
                scrollPhysics: widget.banners.length>1? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                viewportFraction: 1,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: (index, reason) {
                  setState(() {
                    activeIndex = index;
                  });
                }),
          ),
          Positioned(
            bottom: context.height * 0.05,
            right: 0,
            left: 0,
            child: Center(child: buildDotsIndicator()),
          ),
        ],
      ),
    );
  }

  Widget buildImage({
    required String imageUrl,
  }) {
    return Container(
      height: context.height ,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
      child:   ClipRRect(
        child: Image.network(
          imageUrl,
          fit: BoxFit.fill,
          // height: context.height * 0.4,
          width: context.width,
        ),
      ),
    );
  }

  Widget buildDotsIndicator() {
    return AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: widget.banners.length,
        effect: ExpandingDotsEffect(
            spacing: 5.0,
            radius: 30,
            dotWidth: 5.0,
            dotHeight: 5.0,
            // paintStyle: PaintingStyle.stroke,
            strokeWidth: 1.5,
            dotColor: Colors.grey,
            activeDotColor:widget.banners.length>1? Colors.black : Colors.transparent));
  }
}
