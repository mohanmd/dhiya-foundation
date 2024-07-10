import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';


BoxDecoration decorBasic(Color color) => BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(6)), color: color);
BoxDecoration decorBasicShadow(Color color) => BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      color: color,
      boxShadow: [
        BoxShadow(
            color: targetDetailColor.dark.withOpacity(0.25),
            offset: const Offset(5.0, 5.0),
            blurRadius: 10.0,
            spreadRadius: 2.0)
      ],
    );
