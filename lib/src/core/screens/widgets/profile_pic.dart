import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double? padleft;
  final double? padTop;
  final double? padRight;
  final double? padBottom;

  const ProfilePic(
      {this.padleft,
      this.padTop,
      this.padRight,
      this.padBottom,
      required this.width,
      required this.height,
      required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: padleft ?? 0,
        top: padTop ?? 0,
        right: padRight ?? 0,
        bottom: padBottom ?? 0,
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
              color: Colors.grey, width: width, height: height, child: child)),
    );
  }
}
