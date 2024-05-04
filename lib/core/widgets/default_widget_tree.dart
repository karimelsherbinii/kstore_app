import 'package:flutter/material.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/widgets/screen_container.dart';

class DefaultWidgetTree extends StatefulWidget {
  final bool haveAppBar;
  final String? appBarTitle;
  final Widget child;
  final bool haveLeading;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const DefaultWidgetTree(
      {Key? key,
      this.haveAppBar = false,
      this.appBarTitle,
      required this.child,
      this.haveLeading = true,
      this.bottomNavigationBar,
      this.actions,
      this.onBack})
      : super(key: key);

  @override
  State<DefaultWidgetTree> createState() => _DefaultWidgetTreeState();
}

class _DefaultWidgetTreeState extends State<DefaultWidgetTree> {
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        child: Scaffold(
      appBar: widget.haveAppBar
          ? Constants.getAppBar(context,
              title: widget.appBarTitle ?? '',
              haveLeading: widget.haveLeading,
              onPressed: widget.onBack,
              actions: widget.actions)
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: widget.child,
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    ));
  }
}
