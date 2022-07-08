import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class MessageDecorator extends StatelessWidget {
  final Widget child;
  final Alignment alignment;
  final double margRight;
  final double margLeft;
  const MessageDecorator({
    required this.alignment,
    required this.margRight,
    required this.margLeft,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.only(
              left: margLeft, right: margRight, top: 5, bottom: 5),
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            color: mainAppColor,
          ),
          child: child),
    );
  }
}
