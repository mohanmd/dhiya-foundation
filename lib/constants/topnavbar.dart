import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

SizedBox topnavBar(String heading, VoidCallback function, Size size) {
  return SizedBox(
    height: 50,
    width: size.width,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
      InkWell(
          onTap: function,
          child: const Icon(
            Icons.arrow_back,
            size: 24,
          )),
      Text(heading, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(width: 24)
    ]),
  );
}
