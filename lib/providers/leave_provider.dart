import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:in4_solution/constants/keys.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/screens/main_screen/leave/leave_reports.dart';
import 'package:in4_solution/screens/utility/dialogue.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/../providers/auth_provider.dart';
import '../constants/notifications.dart';
import '../services/api_services.dart';

class LeaveProvider extends ChangeNotifier {
  bool leaveLoading = false;
  bool isloading = false;
  List leaveList = [];
  List leaveBalanceDetails = [];
  List leaveApplicationList = [];
  List adminApplicationList = [];
  // Map balanceDetails = {};
  Map leaveApplicationDetails = {};
  Map availableDate = {};

  void toggeleLoading(bool val) {
    isloading = val;
    notifyListeners();
  }

  setLeaveLoadingOn() {
    leaveLoading = true;
    notifyListeners();
  }

  setLeaveLoadingOff() {
    leaveLoading = false;
    notifyListeners();
  }

  String string = DateTime.now().toString();

  DateTime maternity = DateTime.now();
  DateTime paternity = DateTime.now();

  String getFormatedDateMonthYear(String date) {
    DateTime parseDate = DateFormat("dd/MM/yyyy").parse(date);
    DateTime inputDate = DateTime.parse(parseDate.toString());
    String outputDate = DateFormat('dd MMM yyyy').format(inputDate);
    return outputDate;
  }

  String getFormatedMonth(String date) {
    DateTime parseDate = DateFormat("dd/MM/yyyy").parse(date);
    DateTime inputDate = DateTime.parse(parseDate.toString());
    String outputDate = DateFormat('yyyy-MM-dd').format(inputDate);
    return outputDate;
  }

  applyLeave(BuildContext context, var data) {
    setLeaveLoadingOn();
    // logger.i(data);
    ApiService().post(context, "leave/store", params: data).then((received) {
      setLeaveLoadingOff();
      if (received['status'] == true) {
        notif('Success', received['message']);
        return Navigator.pop(context);
      } else {
        if ((received['message'] ?? '').isNotEmpty) {
          notif('Failed', received['message']);
        }
        return;
      }
    });
  }

  cancelLeave(data) {
    toggeleLoading(true);
    ApiService()
        .get(Get.context!, "leave/cancel", params: data)
        .then((received) {
      toggeleLoading(false);
      if (received['status'] == true) {
        notif('Success', received['message']);
        leaveApplications(Get.context!);
        return Navigator.pop(Get.context!);
      } else {
        if ((received['message'] ?? '').isNotEmpty) {
          notif('Failed', received['message']);
        }
        return;
      }
    });
  }

  applyLeaveIndex(BuildContext context) {
    if (leaveList.isEmpty) {
      setLeaveLoadingOn();
      ApiService().get(context, "leave/index").then((value) {
        setLeaveLoadingOff();
        // notif('Success',value['message']);
        return setLeaveList(context, value['list']);
      });
    } else {
      return;
    }
  }

  leaveApplications(BuildContext context) {
    var data = {
      'employee_id': Provider.of<AuthProvider>(context, listen: false)
          .userData['employee_id']
          .toString()
    };
    setLeaveLoadingOn();
    ApiService().get(context, "leave/index", params: data).then((value) {
      setLeaveLoadingOff();
      if (leaveList.isEmpty) setLeaveList(context, value['list']);
      return setLeaveApplicationList(context, value['data']);
    });
  }

  leaveBalance(id) {
    setLeaveLoadingOn();
    ApiService().get(Get.context!, "leave/create",
        params: {"employee_id": id["employee"]["employee_id"]}).then((value) {
      setLeaveLoadingOff();
      if (value["status"]) {
        commonDialog(Get.context!, LeaveBalanceReport(data: value["data"]),
            isHadborder: true);
        notifyListeners();
      } else {
        leaveBalanceDetails = [];
        notifyListeners();
      }
    });
  }

  adminLeaveApplication(BuildContext context) {
    setLeaveLoadingOn();
    ApiService().get(context, "leaveApplication/index", params: {
      'employee_id': '${provdAuth.userData['employee_id']}'
    }).then((value) {
      setLeaveLoadingOff();
      if (value["status"]) {
        adminApplicationList = value["data"];
        notifyListeners();
      } else {
        adminApplicationList = [];
        notifyListeners();
      }
    });
  }

  adminBalanceLeave(Map<String, dynamic> params) {
    setLeaveLoadingOn();
    ApiService()
        .get(Get.context!, "leaveApplication/view", params: params)
        .then((value) {
      setLeaveLoadingOff();
      if (value["status"]) {
        // balanceDetails = value["data"]["leaveTransactions"];
        leaveApplicationDetails = value["data"];
        notifyListeners();
      } else {
        adminApplicationList = [];
        notifyListeners();
      }
    });
  }

  leaveApprovedAdmin(Map<String, String> params) {
    toggeleLoading(true);
    ApiService()
        .post(Get.context!, "leaveApplication/update", params: params)
        .then((value) {
      toggeleLoading(false);
      if (value["status"]) {
        notif("Success", value["message"]);
        adminBalanceLeave(params);
        adminLeaveApplication(Get.context!);
        notifyListeners();
      } else {
        notif("Failed", value["message"]);
        notifyListeners();
      }
    });
  }

  leaveDataChanged(params) {
    toggeleLoading(true);
    ApiService()
        .get(Get.context!, "leave/dateChanged", params: params)
        .then((value) {
      logger.w(value);
      toggeleLoading(false);
      if (value["status"]) {
        logger.f(value);
        availableDate = value["data"];
        notifyListeners();
      } else {
        availableDate = {};
        notifyListeners();
      }
    });
  }

  setLeaveApplicationList(BuildContext context, List setLeaveApplicationLists) {
    leaveApplicationList = setLeaveApplicationLists;
    notifyListeners();
  }

  clearLeaveApplicationList() {
    leaveApplicationList.clear();
    notifyListeners();
  }

  setLeaveList(BuildContext context, List setLeaveLists) {
    leaveList = setLeaveLists;
    notifyListeners();
  }

  clearLeaveList() {
    leaveList.clear();
    notifyListeners();
  }
}
