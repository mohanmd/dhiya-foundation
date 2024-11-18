import 'package:flutter/cupertino.dart';
import 'package:in4_solution/constants/keys.dart';
import 'package:in4_solution/services/api_services.dart';

class EmployeeProvider extends ChangeNotifier {
  bool isloading = false;
  List employeeList = [];
  bool employeeListLoading = false;
  Map employeeDetail = {};

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  fromDatePick(DateTime dateFrom) {
    fromDate = dateFrom;
    notifyListeners();
  }

  toDatePick(DateTime dateTo) {
    toDate = dateTo;
    notifyListeners();
  }

  setReportLoadingOn() {
    employeeListLoading = true;
    notifyListeners();
  }

  setReportLoadingOff() {
    employeeListLoading = false;
    notifyListeners();
  }

  getEmployeeList(BuildContext context, var data) {
    setReportLoadingOn();
    ApiService().post(context, "attendance/day_punch_count", params: data).then((value) {
      setReportLoadingOff();
      // notif('Success', value['message']);
      logger.w("emlist $value");
      setreportList(context, value['data'] ?? []);
    });
  }

  getEmployeeDetail(BuildContext context, data) async {
    setReportLoadingOn();
    try {
      final value = await ApiService().post(context, "attendance/mobile_map", params: data);
      logger.w("emlist $value");
      employeeDetail = value ?? {};
    } finally {
      await Future.delayed(Duration(milliseconds: 500));
      setReportLoadingOff();
    }
  }

  setreportList(BuildContext context, List datalist) {
    logger.w("setreportList $datalist");
    employeeList = datalist;
    notifyListeners();
  }
}
