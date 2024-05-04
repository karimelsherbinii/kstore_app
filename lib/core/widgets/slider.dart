import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderWidget extends StatefulWidget {
  final List<String> banners;
  const SliderWidget({Key? key, required this.banners}) : super(key: key);

  @override
  State<SliderWidget> createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<SliderWidget> {
  int activeIndex = 0;
  @override
  void initState() {
    buildDotsIndicator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.banners.length,
          itemBuilder: (context, index, realIndex) {
            return buildImage(imageUrl: widget.banners[index]);
          },
          options: CarouselOptions(
              height: _getSliderHeight(context),
              autoPlay: true,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              }),
        ),
        buildDotsIndicator()
      ],
    );
  }

  double _getSliderHeight(BuildContext context) {
    if (context.width > 500) {
      return context.height * 0.2;
    } else {
      return context.height * 0.17;
    }
  }

  Widget buildImage({
    required String imageUrl,
  }) {
    return Container(
      height: context.width * 0.2,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill,
              height: _getImageHeight,
              width: _getWidth(),
            ),
          ),
        ],
      ),
    );
  }

  double get _getImageHeight {
    if (context.width > 500) {
      return context.height * 0.2;
    } else {
      return context.height * 0.15;
    }
  }

  double _getWidth() {
    if (context.width > 500) {
      return context.width * 0.5;
    } else {
      return context.width * 0.8;
    }
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
            activeDotColor: AppColors.primaryColor));
  }
}
