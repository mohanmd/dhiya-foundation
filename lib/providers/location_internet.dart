import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/screens/main_screen/main_screen.dart';
import 'package:in4_solution/screens/utility/dialogue.dart';
import 'package:in4_solution/screens/utility/location_permission_dialogue.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/../constants/keys.dart';
import '/../services/connectivity.dart';
import '../constants/notifications.dart';
import '../services/api_services.dart';
import '../services/bio_metrics.dart';
import 'auth_provider.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  File? image;
  Uint8List? image2;
  String? latitude;
  String? longitude;
  bool locationLoading = false;
  bool isLoading = false;

  bool bioMetric = false;
  bool isMockLocation = false;
  List attendanceData = [];
  String shiftId = '';
  void loadingOn() {
    isLoading = true;
    notifyListeners();
  }

  void selectedShift(id) {
    shiftId = id.toString();
    notifyListeners();
  }

  void loadingOff() {
    isLoading = false;
    notifyListeners();
  }

  final Map source = {ConnectivityResult.none: false};
  final MyConnectivity connectivity = MyConnectivity.instance;
  bool? isConnectionSuccessful;

  Future tryConnection2() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      isConnectionSuccessful = response.isNotEmpty;
      notifyListeners();
      return;
    } on SocketException {
      isConnectionSuccessful = false;
      notifyListeners();
      return;
    }
  }

  Future getLocation() async {
    locationLoading = true;
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      commonDialog(Get.context!, LocationPermissionDialogue(
        onTap: () async {
          serviceEnabled = await location.requestService();
          if (serviceEnabled) {
            Navigator.pop(Get.context!);
          }
          if (!serviceEnabled) {
            return;
          }
          permissionGranted = await location.hasPermission();
          if (permissionGranted == PermissionStatus.denied) {
            permissionGranted = await location.requestPermission();
            if (permissionGranted != PermissionStatus.granted) {
              return;
            }
          }
          Position position = await Geolocator.getCurrentPosition();
          // locationData = await location.getLocation();
          // logger.i(position.latitude);
          locationLoading = false;
          latitude = position.latitude.toString();
          longitude = position.longitude.toString();
          isMockLocation = false;
          notifyListeners();
          return;
        },
      ));
    } else {
      Position position = await Geolocator.getCurrentPosition();
      // locationData = await location.getLocation();
      // logger.i(position.latitude);
      locationLoading = false;
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      isMockLocation = false;
      notifyListeners();
      return;
    }
    return;
  }

  Future getCamera() async {
    if (isMockLocation) {
      notif('Failed',
          'Mock Location, turn off/uninstall mock location application.');
      return false;
    }
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      await testCompressFile(image!);
      return true;
    } else {
      return false;
    }
  }

  Future<Uint8List?> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 320,
      minHeight: 680,
      quality: 50,
      rotate: 0,
    );
    image2 = result;
    return null;
  }

  getBioMetric() async {
    if (isMockLocation) {
      return notif('Failed',
          'Mock Location, turn off/uninstall mock location application.');
    }
    if (bioMetric == false) {
      bool safe = await bioMetricAuth();
      bioMetric = safe;
    } else {
      return notif('Success', "Already Verified!");
    }
  }

  Future<bool> validatePassword(String password) async {
    Map<String, String> params = {'password': password};
    dynamic response = await ApiService()
        .get(Get.context!, 'validate_password', params: params);
    bool isValidated = response['status'] ?? false;
    notif(isValidated ? 'Success' : 'Failed', response['message'] ?? '');
    return isValidated;
  }

  Future checkFunction(bool checkIn) async {
    loadingOn();
    FocusScope.of(Get.context!).unfocus();
    if (latitude == null || longitude == null) {
      await getLocation();
      locationLoading = false;
      notifyListeners();
    }
    if (latitude == null || longitude == null) {
      loadingOff();
      return;
    }
    if (bioMetric == false) {
      bool safe = await bioMetricAuth();
      bioMetric = safe;
      notifyListeners();
    }
    notifyListeners();
    if (bioMetric == false) {
      loadingOff();
      return;
    }

    return apiAttendanceCheckIn();
  }

  void apiAttendanceCheckIn() {
    var provd = provdAuth.userData;
    Map<String, dynamic> data = {
      'finger_id': provd['finger_id'].toString(),
      'employee_id': provd['employee_id'].toString(),
      'datetime':
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString(),
      'count': (attendanceData.length + 1).toString(),
      'latitude': latitude,
      'longitude': longitude,
      'face_id': image == null ? "null" : base64Encode(image2!),
      'in_out_time':
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString(),
      'check_type':
          (provdAuth.checkInData['in_time'] ?? '').isNotEmpty ? '1' : '0'
    };

    //0 - cehckin //1 - cehckout
    setAttendanceData(data);
  }

  storeAttendanceData(BuildContext context, List attData) {
    attendanceData = attData;
    notifyListeners();
  }

  void setAttendanceData(Map attData) async {
    attendanceData = [];
    attendanceData = [jsonEncode(attData)];
    logger.e(attendanceData);
    image = null;
    image2 = null;
    // encryptedSharedPreferences.remove(LocalVariable.attendanceData);
    // var pref = await SecureSharedPref.getInstance();
    // pref.putString(LocalVariable.attendanceData, jsonEncode(attendanceData));
    // await encryptedSharedPreferences.getString(LocalVariable.attendanceData).then((value) {
    //   logger.w(value);
    //   logger.w(jsonDecode(value));
    //   logger.w(jsonDecode(value).length);
    // });
    return setLocalData(attData);
  }

  void setLocalData(Map attData) async {
    logger.f(attendanceData);
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return ApiService().post(
            Get.context!, "attendance/employee_attendance_list",
            params: {'data': attendanceData.toString()}).then((value) {
          logger.f(value);
          latitude = null;
          longitude = null;
          image = null;
          bioMetric = false;
          loadingOff();
          if (value['status'] == true) {
            notif('Success', value['message']);
            provdAuth.setCheckinData(value['in_out_data']);
            deleteAttendanceData();
          } else {
            if (value['refresh'] == true) {
              notif('Failed', value['message']);
              Provider.of<AuthProvider>(Get.context!, listen: false)
                  .refreshCustom(Get.context!);
              return deleteAttendanceData();
            }
            if (value['refresh'] == true) {
              notif('Failed', value['message']);
              return deleteAttendanceData();
            }
            deleteAttendanceData();
            notif('Failed', value['message']);
            return;
          }
        });
      }
    } on SocketException catch (_) {
      latitude = null;
      longitude = null;
      bioMetric = false;
      image = null;
      notif('Failed', 'Kindly check your internet connection');
      loadingOff();
    }
  }

  void deleteAttendanceData() async {
    attendanceData.clear();
    attendanceData = [];
    notifyListeners();
  }
}
