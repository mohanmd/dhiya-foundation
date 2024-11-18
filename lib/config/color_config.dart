import 'package:flutter/material.dart';

import 'enums.dart';

class ColorConfig {
  final AppTarget target;
  late final Color brand, accent, muted, dark, light, border, static, success, danger, warning, info;

  ColorConfig({required this.target}) {
    switch (target) {
      case AppTarget.in4:
        primaryColor();
        common();
        break;
      case AppTarget.local:
        primaryColor();
        common();
        break;
      case AppTarget.dhiyafoundation:
        dhivyafoundation();
        common();
        break;

      default:
        primaryColor();
        common();
    }
  }

  get primaryDark => null;

  get errorText => null;

  common() {
    accent = const Color(0xff761E32);
    muted = const Color(0xffEEEEEE);
    dark = const Color(0xff353535);
    light = const Color(0xffF1F5F9);
    border = const Color(0xffCFECFD);
    success = const Color(0xff1ACD67);
    danger = const Color(0xffFD4B47);
    warning = const Color(0xffFD8E39);
    info = const Color(0xff24B3FF);
  }

  primaryColor() {
    brand = const Color(0xff41B3F9);
  }

  dhivyafoundation() {
    brand = const Color(0xff1b4e9b);
  }

  reliance() {
    brand = const Color(0xffFDAC04);
  }

  hbcc() {
    brand = const Color(0xffE81F26);
  }

  shahi() {
    brand = const Color(0xff00137C);
  }

  secondaryColor() {
    brand = const Color(0xffcc3234);
  }

  ehg() {
    brand = const Color(0xff776B26);
  }

  oqic() {
    brand = const Color(0xffab0635);
  }

  tessam() {
    // brand = const Color(0xfff9a8d4);
    // brand = const Color(0xfff472b6);
    // brand = const Color(0xffa78bfa);
    // brand = const Color(0xffd8b4fe);
    brand = const Color(0xffa5b4fc);
    // brand = Color.fromARGB(255, 215, 156, 251);
    // brand = Color.fromARGB(255, 247, 155, 248);
  }
}
