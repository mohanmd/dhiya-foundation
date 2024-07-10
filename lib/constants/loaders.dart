import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';


loader80() => SizedBox(
    height: 80,
    width: 80,
    child: CircularProgressIndicator(
      strokeWidth: 1.25,
      color: targetDetailColor.brand,
    ));
loader50() => SizedBox(
    height: 50,
    width: 50,
    child: CircularProgressIndicator(
      strokeWidth: 1.25,
      color: targetDetailColor.brand,
    ));
loader45() => SizedBox(
    height: 45,
    width: 45,
    child: CircularProgressIndicator(
      strokeWidth: 1.25,
      color: targetDetailColor.brand,
    ));
loader35() => SizedBox(
    height: 35,
    width: 35,
    child: CircularProgressIndicator(
      strokeWidth: 1.5,
      color: targetDetailColor.brand,
    ));
