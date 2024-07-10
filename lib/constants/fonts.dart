import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in4_solution/config/enums.dart';

import 'dimensions.dart';

TextStyle styleButton = GoogleFonts.inter(
    fontSize: D.nr,
    fontWeight: FontWeight.w400,
    color: targetDetailColor.light,
    letterSpacing: 0.25);
TextStyle styleHint = GoogleFonts.inter(
    fontSize: D.nr,
    fontWeight: FontWeight.w400,
    color: targetDetailColor.dark.withOpacity(0.5),
    letterSpacing: 0.5);
TextStyle styleHintDark = GoogleFonts.inter(
    fontSize: D.des,
    fontWeight: FontWeight.w200,
    color: targetDetailColor.dark,
    letterSpacing: 0.25);
TextStyle styleForm = GoogleFonts.inter(
    fontSize: D.nr,
    fontWeight: FontWeight.w400,
    color: targetDetailColor.dark,
    letterSpacing: 0.5);
TextStyle styleReport({weight, color, double size = 14}) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight ?? FontWeight.w500,
    color: color ?? targetDetailColor.dark,
    letterSpacing: 0.5);
TextStyle styleReportDate = GoogleFonts.inter(
    fontSize: D.des,
    fontWeight: FontWeight.w500,
    color: targetDetailColor.dark,
    letterSpacing: 0.5);
Widget textTime(String name) => Text(name,
    style: GoogleFonts.inter(
        fontSize: D.uiTimeBar,
        fontWeight: FontWeight.w600,
        color: targetDetailColor.dark,
        letterSpacing: 0.75));
Widget textTimeAm(String name) => Text(name,
    style: GoogleFonts.inter(
        fontSize: D.btn,
        fontWeight: FontWeight.w500,
        color: targetDetailColor.dark,
        letterSpacing: 0.25));
Widget textCheckTim(String name, Color color, {align}) => Text(name,
    textAlign: align ?? TextAlign.start,
    style: GoogleFonts.inter(
        fontSize: D.nr,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.25));
Widget textFormLabel(String name) => Text(name,
    style: GoogleFonts.inter(
        fontSize: D.nr,
        fontWeight: FontWeight.w500,
        color: targetDetailColor.dark,
        letterSpacing: 0.25));
Widget textSuccess(String name) => Text(name,
    style: GoogleFonts.inter(
        fontSize: D.p12,
        fontWeight: FontWeight.w500,
        color: targetDetailColor.success,
        letterSpacing: 0.25));
Widget textError(String name) => Text(name,
    style: GoogleFonts.inter(
        fontSize: D.p12,
        fontWeight: FontWeight.w500,
        color: targetDetailColor.danger,
        letterSpacing: 0.25));
Widget textDate(String name) => Text(name,
    style: GoogleFonts.inter(
        fontSize: D.h1,
        fontWeight: FontWeight.w600,
        color: targetDetailColor.dark,
        letterSpacing: 0.25));
Widget textUser(String name) => Text(name,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: targetDetailColor.dark,
        letterSpacing: 0.25));
Widget textStatus(String name) => Text(name,
    style: GoogleFonts.inter(
        fontSize: D.nr,
        fontWeight: FontWeight.w500,
        color: targetDetailColor.dark,
        letterSpacing: 0.25));
Widget textTittle(String name, Color color, {size}) => Text(name,
    style: GoogleFonts.inter(
        fontSize: size ?? D.btn,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: 1));
Widget textCheckIn(String name, Color color) => Text(name,
    style: GoogleFonts.inter(
        fontSize: D.nr,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: 1));
Widget textNavBar(String name) => Text(name,
    style: GoogleFonts.inter(
        fontSize: D.btn,
        fontWeight: FontWeight.w500,
        color: targetDetailColor.brand,
        letterSpacing: 0.25));
Widget textPayslipNavBar(String name) => Text(name,
    style: GoogleFonts.inter(
        fontSize: D.nr,
        fontWeight: FontWeight.w500,
        color: targetDetailColor.dark,
        letterSpacing: 0.25));
Widget textSideHead(String name) => Text(name,
    style: GoogleFonts.inter(
        fontSize: D.btn,
        fontWeight: FontWeight.w500,
        color: targetDetailColor.dark,
        letterSpacing: 0.25));
Widget textButtonDark(String name, {color, size}) => Text(name,
    style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? targetDetailColor.light,
        letterSpacing: 0.75));
Widget textHeadCommon(String name) => Text(name,
    style: GoogleFonts.poppins(
        fontSize: D.btn,
        fontWeight: FontWeight.w500,
        color: targetDetailColor.brand,
        letterSpacing: 0.75));
Widget textHeadCaps(String name) => Text(name,
    style: GoogleFonts.poppins(
        fontSize: D.nr,
        fontWeight: FontWeight.w500,
        color: targetDetailColor.brand,
        letterSpacing: 0.75));
Widget textTablehead(String name, {align}) => Text(name,
    textAlign: align ?? TextAlign.start,
    style: GoogleFonts.poppins(
        fontSize: D.nr,
        fontWeight: FontWeight.w500,
        color: targetDetailColor.dark,
        letterSpacing: 0.25));
Widget textCustom(String name,
        {align, color, double size = 14, weight, decoration}) =>
    Text(name,
        textAlign: align ?? TextAlign.start,
        style: GoogleFonts.poppins(
            decoration: decoration,
            fontSize: size,
            fontWeight: weight ?? FontWeight.w600,
            color: color,
            letterSpacing: 0.25));
