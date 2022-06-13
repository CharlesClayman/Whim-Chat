import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class CustomerButton extends StatelessWidget {
  final String? label;
  final Function onTapFunction;
  final bool isLoading;
  const CustomerButton(
      {required this.onTapFunction,
      required this.isLoading,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2),
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          color: mainAppColor,
        ),
        child: !isLoading
            ? Text(
                label!,
                style: TextStyle(color: lightModeColor, fontSize: 18),
              )
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
      onTap: () {
        onTapFunction();
      },
    );
  }
}
