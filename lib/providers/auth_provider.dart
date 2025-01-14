// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/screens/auth_screens/login_screen.dart';
import 'package:in4_solution/screens/auth_screens/splash_screen.dart';
import 'package:in4_solution/screens/main_screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/../constants/notifications.dart';
import '/../providers/location_internet.dart';
import '/../services/api_services.dart';
import '../constants/keys.dart';
import '../constants/local_variable.dart';

class AuthProvider extends ChangeNotifier {
  bool authLoading = false;
  Map userData = {};
  String accessToken = "";
  Map checkInData = {};
  Map loginCreds = {};
  bool isHadAttendance = true;

  // void setCheckinData(Map map) async {
  //   // if (targetDetail.target == AppTarget.tata) {
  //   //   checkInData = {};
  //   //   checkInData.clear();
  //   // }
  //   var pref = await SecureSharedPref.getInstance();
  //   checkInData = map;
  //   provdLocation.selectedShift(checkInData['work_shift_id'] ?? '');
  //   notifyListeners();
  //   pref.putMap(LocalVariable.checkedInData, map);
  // }

  // void clearCheckinData() async {
  //   var pref = await SecureSharedPref.getInstance();
  //   checkInData = {};
  //   checkInData.clear();
  //   notifyListeners();
  //   pref.putMap(LocalVariable.checkedInData, {});
  // }

  void authLoadingOff() {
    authLoading = false;
    notifyListeners();
  }

  void authLoadingOn() {
    authLoading = true;
    notifyListeners();
    Timer(const Duration(seconds: 30), () {
      authLoadingOff();
      notifyListeners();
      if (authLoading) {
        notif("Error!", "Server unreachable, Try again after some time");
      }
    });
    return;
  }

  void clearData(BuildContext context) async {
    provdLocation.deleteAttendanceData();
    // var pref = await SecureSharedPref.getInstance();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    // await encryptedSharedPreferences.remove(LocalVariable.accessToken);
    // await encryptedSharedPreferences.remove(LocalVariable.userData);
    // await encryptedSharedPreferences.remove(LocalVariable.attendanceData);
    // await encryptedSharedPreferences.remove(LocalVariable.checkedInData);
    authLoadingOff();
    forwarderLoginScreen(context);
  }

  // Future checkCheckInData() async {
  //   try {
  //     var pref = await SecureSharedPref.getInstance();

  //     await pref.getMap(LocalVariable.checkedInData).then((value) {
  //       if (value != null && value.isNotEmpty) {
  //         checkInData = value;

  //         notifyListeners();
  //       }
  //     });
  //   } catch (e) {
  //     logger.i(e);
  //   }
  // }

  Future checkSplashScreen(BuildContext context) async {
    // var pref = await SecureSharedPref.getInstance();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      final encryptData = pref.getString(LocalVariable.userData);
      final decodedData = jsonDecode(encryptData ?? '{}'); 
        getCreds();
        if (decodedData == null || decodedData.isEmpty) {
          forwarderLoginScreen(context);
        } else {
          if (pref.getString(LocalVariable.accessToken) != null)  {
            // logger.i(user);
            // logger.i(token);
            accessToken = pref.getString(LocalVariable.accessToken) ?? '';
            userData = decodedData;
            notifyListeners();
            authLoadingOff();
            refresh(context);
          };
        } 
    } catch (e) {
      authLoadingOff();
      forwarderLoginScreen(context);
    }
  }

  void setCheckLocalDatas(BuildContext context) async {
    // var pref = await SecureSharedPref.getInstance();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    // await checkCheckInData();
     final attendanceData = pref.getString(LocalVariable.attendanceData);
      if (attendanceData != null) {
        Provider.of<LocationProvider>(context, listen: false)
            .storeAttendanceData(context, jsonDecode(attendanceData));
      } 
  }

  refreshIfHadInternet(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        authLoadingOn();
        clearCheckinData();
        ApiService().get(context, "refresh").then((value) {
          authLoadingOff();
          logger.e(value);
          if (value != null && value['status']) {
            if (value['is_checked_in']) {
              setCheckinData(value['in_out_data']);
            }
            // notif('Success',value['message']);
            return setData(context, value);
          } else {
            forwarderLoginScreen(context);
          }
        });
      }
    } on Exception {
      forwarderMainScreen(context);
    }
  }

  refresh(BuildContext context) async {
    authLoadingOn();
    clearCheckinData();
    ApiService().get(context, "refresh").then((value) {
      authLoadingOff();
      if (value['status']) {
        if (value['is_checked_in']) {
          setCheckinData(value['in_out_data']);
        }
        // notif('Success',value['message']);
        return setData(context, value);
      } else {
        forwarderLoginScreen(context);
      }
    });
  }

  refreshCustom(BuildContext context) async {
    // var pref = await SecureSharedPref.getInstance();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    clearCheckinData();
    ApiService().get(context, "refresh").then((value) {
      if (value['status']) {
        if (value['is_checked_in']) {
          setCheckinData(value['in_out_data']);
        }
        userData = value['user'];
        accessToken = value['access_token'];
        pref.setString(LocalVariable.accessToken, value['access_token']);
        notifyListeners();
        final encodedData = jsonDecode(value['user'] ?? {});
        pref.setString(LocalVariable.userData, encodedData);
      }
    });
  }

  setData(BuildContext context, Map data) async {
    // var pref = await SecureSharedPref.getInstance();
    var pref = await SharedPreferences.getInstance();
    userData = data["user"];
    isHadAttendance = data["user"]["mobile_att"] != 2;
    accessToken = data["access_token"];
    pref.setString(LocalVariable.accessToken, data["access_token"]);
    notifyListeners();
    final encodedData = jsonEncode(data["user"]);
    pref.setString(LocalVariable.userData, encodedData);
    authLoadingOff();
    return forwarderMainScreen(context); 
  }

  void storeCreds(Map data) async {
    // var pref = await SecureSharedPref.getInstance();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(LocalVariable.loginCreds, jsonEncode(data));
  }

  Future getCreds() async {
    // var pref = await SecureSharedPref.getInstance();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setString(LocalVariable.loginCreds, "");
    final loginCredsData = pref.getString(LocalVariable.loginCreds) ?? '';
    if(loginCredsData.isNotEmpty){
      loginCreds = jsonDecode(loginCredsData); 
    }  
    notifyListeners();
    return;
  }

  Future login(BuildContext context, String email, String password,
      bool isRemember) async {
    FocusScope.of(context).unfocus();
    authLoadingOn();
    var params = {"user_name": email, "password": password};
    ApiService().post(context, "login", params: params).then((value) async {
      authLoadingOff();
      if (value['status'] == true) {
        notif('Success', value['message']);
        if (isRemember) {
          storeCreds(params);
        }
        // if (targetDetail.functions.any((element) => element == 2)) {
        if (value['is_checked_in']) {
          setCheckinData(value['in_out_data']);
        } else {
          clearCheckinData();
        }
        // }
        setData(context, value);
      } else {
        return notif('Failed', value['message']);
      }
    });
  }

  Future forgotPassword(BuildContext context, String name) async {
    FocusScope.of(context).unfocus();
    authLoadingOn();
    ApiService().post(context, "forgetpassword",
        params: {"user_name": name}).then((value) {
      authLoadingOff();
      if (value['status'] == true) {
        notif('Success', value['message']);
        Navigator.pop(context);
      } else {
        return notif('Failed', value['message']);
      }
    });
  }

  Future changePassword(BuildContext context, String password) async {
    authLoadingOn();
    ApiService().post(context, "change_password", params: {
      "user_id": '${userData['user_id']}',
      "password": password
    }).then((value) {
      authLoadingOff();
      if (value['status'] == true) {
        notif('Success', value['message']);
        Navigator.pop(context);
      } else {
        return notif('Failed', value['message']);
      }
    });
  }

  void setCheckinData(Map data) async {
    checkInData = data;
    notifyListeners();
  }

  void clearCheckinData() async {
    checkInData = {};
    checkInData.clear();
    notifyListeners();
  }

  Future logout(BuildContext context) async {
    // FocusScope.of(context).unfocus();
    // var pref = await SecureSharedPref.getInstance();
    var pref = await SharedPreferences.getInstance();
    await getCreds();
    ApiService().post(context, "logout");
    checkInData = {};
    checkInData.clear();
    userData = {};
    userData.clear();
    provdLocation.deleteAttendanceData();
    provdAttendance.clearMonthlyAttendance();
    await pref.clear();
    storeCreds(loginCreds);
    notifyListeners();
    forwarderSplashScreen(context);
  }

  forwarderSplashScreen(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen()),
        (route) => false);
  }

  forwarderLoginScreen(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()),
        (route) => false);
  }

  forwarderMainScreen(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen()),
        (route) => false);
  }
}
