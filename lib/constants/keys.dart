import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

GlobalKey<ScaffoldState> materialKey = GlobalKey<ScaffoldState>();

GlobalKey<ScaffoldState> splashKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> mainKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> indexKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> homeKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> attendanceKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> leaveReportKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> applyLeaveKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> payslipKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

GlobalKey<ScaffoldState> scrollKey = GlobalKey<ScaffoldState>();

var logger = Logger();
// var encryptedSharedPreferences = SecureSharedPref.getInstance();
