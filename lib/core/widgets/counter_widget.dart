import 'package:flutter/material.dart';
import 'package:kstore/core/utils/media_query_values.dart';

import '../utils/app_colors.dart';

class CounterWidget extends StatefulWidget {
  final int count;
  final Function() onIncrement;
  final Function() onDecrement;
  final bool haveShadow;
  final double? width;
  final double? height;
  final double? fontSize;

  const CounterWidget({
    Key? key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    this.haveShadow = false,
    this.width,
    this.height,
    this.fontSize,
  }) : super(key: key);

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? context.width * 0.36,
      height: widget.height ?? context.height * 0.045,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: widget.haveShadow
            ? [
                BoxShadow(
                  color: AppColors.shadowColor,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: widget.onDecrement,
              child: Container(
                width: context.width * 0.1,
                height: context.height * 0.045,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Text(
              widget.count.toString(),
              style: TextStyle(
                fontSize: widget.fontSize ?? context.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: widget.onIncrement,
              child: Container(
                width: context.width * 0.1,
                height: context.height * 0.045,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
