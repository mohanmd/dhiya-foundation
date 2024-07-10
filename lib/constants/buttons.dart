import 'package:flutter/material.dart';

import '../config/enums.dart';
import '/../constants/fonts.dart';

ButtonStyle buttonStyle({color}) => ElevatedButton.styleFrom(
    foregroundColor: targetDetailColor.dark,
    backgroundColor: color ?? targetDetailColor.brand,
    shadowColor: Colors.transparent,
    elevation: 2,
    padding: EdgeInsets.zero,
    enabledMouseCursor: MouseCursor.defer,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    animationDuration: const Duration(seconds: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));

buttonCancel(double width, double minus, BuildContext context,
        {color}) =>
    SizedBox(
        height: 45,
        width: width - minus,
        child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: buttonStyle(),
            child: Text("Discard", style: styleButton)));
buttonPrimary1(String name, VoidCallback voidCallback, {height, color, size}) =>
    Container(
        height: height ?? 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: targetDetailColor.brand),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(child: textButtonDark(name, size: size)));

buttonPrimary(
        double width, double minus, String name, VoidCallback voidCallback,
        {height, color, size}) =>
    SizedBox(
        height: height ?? 45,
        width: width - minus,
        child: ElevatedButton(
            onPressed: voidCallback,
            style: buttonStyle(color: color),
            child: textButtonDark(name, size: size)));

buttonOutlined(BuildContext context) => InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              border: Border.all(color: targetDetailColor.brand)),
          child: textButtonDark('Discard', color: targetDetailColor.brand)),
    );
