import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:in4_solution/providers/all_providers.dart';
import '../services/api_services.dart';

class AttendanceProvider extends ChangeNotifier {
  bool attendanceLoading = false;
  List attendanceList = [];
  List monthlyAttendanceList = [];
  List attendanceStatus = [];
  List months = [];
  Map? selectedMonth;
  List weeks = [
    {'id': 1, 'day': 'Sun'},
    {'id': 2, 'day': 'Mon'},
    {'id': 3, 'day': 'Tue'},
    {'id': 4, 'day': 'Wed'},
    {'id': 5, 'day': 'Thu'},
    {'id': 6, 'day': 'Fri'},
    {'id': 7, 'day': 'Sat'}
  ];

  String string = DateTime.now().toString();
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

  setAttendanceLoadingOn() {
    attendanceLoading = true;
    notifyListeners();
  }

  setAttendanceLoadingOff() {
    attendanceLoading = false;
    notifyListeners();
  }

  void setSelectedMonth(val) {
    selectedMonth = val;
    var params = {
      'employee_id': '${provdAuth.userData['employee_id']}',
      'year_month': '${selectedMonth?['input']}'
    };
    provdAttendance.getMonthlyData(params);
    notifyListeners();
  }

  attendanceReport(BuildContext context, var data) {
    setAttendanceLoadingOn();
    ApiService()
        .get(context, "attendance/my_attendance_report", params: data)
        .then((value) {
      setAttendanceLoadingOff();
      // notif('Success', value['message']);
      return setAttendanceList(context, value['data'] ?? []);
    });
  }

  getMonthlyAttendance() {}
  setAttendanceList(BuildContext context, List setattendacneList) {
    attendanceList = setattendacneList;
    notifyListeners();
  }

  clearAttendanceList() {
    attendanceList.clear();
    notifyListeners();
  }

  clearMonthlyAttendance() {
    selectedMonth = null;
    monthlyAttendanceList = [];
    notifyListeners();
  }

  getMonthlyData(params) {
    setAttendanceLoadingOn();
    monthlyAttendanceList = [];
    ApiService()
        .get(Get.context!, 'attendance/monthly_attendance', params: params)
        .then((value) {
      setAttendanceLoadingOff();
      if (value['status']) {
        List list = value['data']['month_attendance'] ?? [];
        attendanceStatus = value["data"]["attendance_status_legend"] ?? [];
        // logger.f(attendanceStatus);
        if (list.isNotEmpty && list[0]['day_name'] != 'Sun') {
          List prevMonth = [];
          int count = weeks
              .indexWhere((element) => element['day'] == list[0]['day_name']);
          for (var y = 0; y < count; y++) {
            prevMonth.add({'date': ''});
          }
          monthlyAttendanceList = prevMonth;
        }
        monthlyAttendanceList.addAll(list);
        notifyListeners();
      } else {
        monthlyAttendanceList = [];
        notifyListeners();
      }
    });
  }

  getMonths() {
    setAttendanceLoadingOn();
    selectedMonth = null;
    ApiService()
        .get(Get.context!, 'attendance/monthly_dropdown_list')
        .then((value) {
      setAttendanceLoadingOff();
      if (value['status']) {
        months = value['data']['year_month'] ?? [];
        notifyListeners();
      } else {
        months = [];
        notifyListeners();
      }
    });
  }
}
