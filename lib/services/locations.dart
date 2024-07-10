import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:in4_solution/screens/utility/dialogue.dart';
import 'package:in4_solution/screens/utility/location_permission_dialogue.dart';
import '../constants/notifications.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      notif('Failed', "Turn on GPS/Location");
      Future.error('Location services are disabled.');
    }
  }

  if (permission == LocationPermission.denied) {
    commonDialogCommon(Get.context!,
        LocationPermissionDialogue(onTap: () async {
      Navigator.pop(Get.context!);
      permission = await Geolocator.requestPermission();
    }));
    if (permission == LocationPermission.denied) {
      notif('Failed', "GPS/Location Permission Denied!");
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    notif('Failed', "GPS/Location permanently Permission Denied!");
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
