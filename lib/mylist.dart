import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MyList extends HookWidget {
  final widgetKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final PageController _pageController = usePageController(
      initialPage: 999,
      viewportFraction: 0.6,
    );
    return PageView(
      controller: _pageController,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black26),
          ),),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black26),
          ),),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black26),
          ),),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black26),
          ),),
      ],
    );
  }

}