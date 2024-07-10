import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in4_solution/constants/keys.dart';
import 'package:in4_solution/constants/notifications.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/services/api_services.dart';

class PermissionProvider extends ChangeNotifier {
  bool isCreating = false;
  bool isGetting = false;
  bool isloading = false;

  List permissions = [];
  Map permissionsCount = {};
  List adminPermissionList = [];
  Map adminPermissionDeatils = {};
  Map checkPermissionData = {};
  Map permissionInfo = {};
  String balanceLeave = '';

  void createLoading(bool value) {
    isCreating = value;
    notifyListeners();
  }

  void getLoading(bool value) {
    isGetting = value;
    notifyListeners();
  }

  void toggeleLoading(bool val) {
    isloading = val;
    notifyListeners();
  }

  Future getPermissionsCount() async {
    getLoading(true);
    var params = {'employee_id': provdAuth.userData['employee_id'].toString()};
    dynamic response = await ApiService()
        .get(Get.context!, "permission/create", params: params);
    getLoading(false);
    if (response['status']) {
      permissionsCount = response['data'];
      notifyListeners();
    } else {
      permissionsCount = {};
      notifyListeners();
    }
  }

  Future askPermission(BuildContext context, Map params) async {
    createLoading(true);
    dynamic response =
        await ApiService().post(context, "permission/store", params: params);
    createLoading(false);
    logger.f(response);
    if (response['status']) {
      notif('Success', response["message"]);
      return true;
    } else {
      notif('Failed', response["message"]);
      return false;
    }
  }

  changeDate(params) async {
    createLoading(true);
    dynamic response = await ApiService()
        .get(Get.context!, "permission/dateChanged", params: params);
    createLoading(false);
    logger.i(response);
    if (response['status']) {
      permissionInfo = response['data'] ?? {};
      balanceLeave =
          '${permissionInfo['PERMISSION_BALANCE'] ?? permissionInfo['balance_count'] ?? ''}';
      notifyListeners();
    } else {
      notif('Failed', response["message"]);
    }
  }

  Future getPermissions(BuildContext context) async {
    getLoading(true);
    var params = {'employee_id': provdAuth.userData['employee_id'].toString()};
    dynamic response =
        await ApiService().get(context, "permission/index", params: params);
    getLoading(false);
    // logger.f(response);
    if (response['status']) {
      permissions = response['data'];
      notifyListeners();
    } else {
      permissions = [];
      notif('Failed', response["message"]);
      notifyListeners();
    }
  }

  void adminPermissionIndex() async {
    getLoading(true);
    ApiService().get(Get.context!, "permissionApplication/index", params: {
      'employee_id': '${provdAuth.userData['employee_id']}'
    }).then((value) {
      getLoading(false);
      if (value["status"]) {
        adminPermissionList = value["data"];
        notifyListeners();
      } else {
        adminPermissionList = [];
        notifyListeners();
      }
    });
  }

  void adminPermissionView(Map<String, dynamic> params) async {
    getLoading(true);
    ApiService()
        .get(Get.context!, "permissionApplication/view", params: params)
        .then((value) {
      getLoading(false);
      if (value["status"]) {
        adminPermissionDeatils = value["data"];
        notifyListeners();
      } else {
        adminPermissionDeatils = {};
        notifyListeners();
      }
    });
  }

  void adminPermissionUpdate(Map<String, String> params) async {
    toggeleLoading(true);
    ApiService()
        .post(Get.context!, "permissionApplication/update", params: params)
        .then((value) {
      toggeleLoading(false);
      if (value["status"]) {
        notif("Success", value["message"]);
        adminPermissionIndex();
        adminPermissionView(params);
        Navigator.pop(Get.context!);
        notifyListeners();
      } else {
        notif("Failed", value["message"]);
        Navigator.pop(Get.context!);
        notifyListeners();
      }
    });
  }

  void checkPermission(params) {
    getLoading(true);
    ApiService()
        .get(Get.context!, "permission/check_permission", params: params)
        .then((value) {
      if (value != null) {
        checkPermissionData = value;
        // logger.e(checkPermissionData);
        notifyListeners();
      } else {
        checkPermissionData = {};
        notifyListeners();
      }
    });
  }
}
