import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:intl/intl.dart';

extension ContextExtension on BuildContext {
  double widthFull() => MediaQuery.of(this).size.width;
  double heightFull() => MediaQuery.of(this).size.height;
  double widthHalf() => MediaQuery.of(this).size.width / 2;
  double heightHalf() => MediaQuery.of(this).size.height / 2;
  double widthQuarter() => MediaQuery.of(this).size.width / 3;
  double heightQuarter() => MediaQuery.of(this).size.height / 3;
}

bool isIos() {
  if (Platform.isAndroid) {
    return false;
  } else {
    return true;
  }
}

String getFormatedMonthYear(String year, String month) {
  DateTime parseDate = DateFormat("yyyy-MM-dd").parse("$year-$month-1");
  DateTime inputDate = DateTime.parse(parseDate.toString());
  String outputDate = DateFormat('MMM yyyy').format(inputDate);
  return outputDate;
}

String getFormateddate(String date) {
  DateTime parseDate = DateFormat("dd-MM-yyyy").parse(date);
  DateTime inputDate = DateTime.parse(parseDate.toString());
  String outputDate = DateFormat('dd MMM yyyy').format(inputDate);
  return outputDate;
}

DateTime stringtoDate(String date) {
  DateTime parseDate = DateFormat("dd/MM/yyyy").parse(date);
  DateTime inputDate = DateTime.parse(parseDate.toString());
  // String outputDate = DateFormat('dd MMM yyyy').format(inputDate);
  return inputDate;
}

String getFormateddateMonth(String date) {
  DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);
  DateTime inputDate = DateTime.parse(parseDate.toString());
  String outputDate = DateFormat('dd MMM yyyy').format(inputDate);
  return outputDate;
}

String getFormateddatehour(String date) {
  DateTime parseDate = DateFormat("hh:mm:ss").parse(date);
  DateTime inputDate = DateTime.parse(parseDate.toString());
  String outputDate = DateFormat('hh:mm').format(inputDate);
  return outputDate;
}

String getddMMMyyyy(String date) {
  try {
    DateTime parseDate = DateFormat("dd/MM/yyyy").parse(date);
    DateTime inputDate = DateTime.parse(parseDate.toString());
    String outputDate = DateFormat('dd MMM yyyy').format(inputDate);
    return outputDate;
  } on Exception {
    DateTime parseDate = DateFormat("dd/MM/yyyy").parse(date);
    DateTime inputDate = DateTime.parse(parseDate.toString());
    String outputDate = DateFormat('dd MMM yyyy').format(inputDate);
    return outputDate;
    // TODO
  }
}

String getFormateddateCooperwind(String date) {
  DateTime parseDate = DateFormat("dd-MM-yyyy").parse(date);
  DateTime inputDate = DateTime.parse(parseDate.toString());
  String outputDate = DateFormat('dd MMM yyyy').format(inputDate);
  return outputDate;
}
