import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/screens/main_screen/leave/leave_widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/../constants/buttons.dart';
import '/../constants/contexts.dart';
import '/../constants/fonts.dart';
import '/../constants/keys.dart';

import '/../providers/leave_provider.dart';
import '../../../constants/loaders.dart';
import '../../../constants/notifications.dart';
import '../../../constants/text_field.dart';
import '../../../constants/topnavbar.dart';
import '../../utility/dialogue.dart';

class LeaveApplication extends StatefulWidget {
  const LeaveApplication({Key? key}) : super(key: key);

  @override
  State<LeaveApplication> createState() => _LeaveApplicationState();
}

class _LeaveApplicationState extends State<LeaveApplication> {
  TextEditingController textControler = TextEditingController();
  TextEditingController fromDateControler = TextEditingController();
  TextEditingController toDateControler = TextEditingController();
  TextEditingController purposeControler = TextEditingController();
  Map data = {};
  Map selectedValue = {};
  Map selectedday = {};
  bool isFullDay = true;
  bool isHalfDay = false;
  double numberOfDays = 0.0;

  DateTime? fromDate;
  DateTime? toDate;

  Future datePick(bool forFromDate) async {
    DateTime selectedLeaveDate = await commonDialogCommon(
        context,
        ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: DatePickerDialog(
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2025))));

    if (forFromDate) {
      fromDatePick(selectedLeaveDate);
      var data = {
        'employee_id': provdAuth.userData['employee_id'].toString(),
        'leave_type_id': selectedValue['leave_type_id'].toString(),
        'application_from_date':
            DateFormat('yyyy-MM-dd').format(fromDate!).toString(),
        'application_to_date': ''
        // DateFormat('yyyy-MM-dd').format(toDate!).toString(),
      };
      logger.e(data);
      return provdLeave.leaveDataChanged(data);
    } else {
      toDatePick(selectedLeaveDate);
      var data = {
        'employee_id': provdAuth.userData['employee_id'].toString(),
        'leave_type_id': selectedValue['leave_type_id'].toString(),
        'application_from_date':
            DateFormat('yyyy-MM-dd').format(fromDate!).toString(),
        'application_to_date':
            DateFormat('yyyy-MM-dd').format(toDate!).toString(),
      };
      return provdLeave.leaveDataChanged(data);
    }
  }

  fromDatePick(DateTime dateFrom) {
    fromDate = dateFrom;
    setState(() {});
  }

  toDatePick(DateTime dateTo) {
    if (DateTime.parse('$dateTo')
        .difference(DateTime.parse('$fromDate'))
        .inDays
        .isNegative) {
      return notif(
          'Failed', 'To date must be greater than or eqaul to the from date');
    }
    toDate = dateTo;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provdLeave.leaveApplications(context);
      setState(() {
        selectedday = leaveDuration[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<LeaveProvider>(builder: (_, provider, __) {
      var selectDay = selectedday["id"] == null
          ? 0.0
          : double.parse("${selectedday["id"] ?? ""}");

      var availableDay = provider.availableDate["number_of_day"] == null
          ? 0
          : int.parse("${provider.availableDate["number_of_day"]}");

      if (provider.availableDate.isNotEmpty &&
          provider.availableDate["to"] != null &&
          fromDate != null &&
          (selectedValue['leave_type_id'] == 5 ||
              selectedValue['leave_type_id'] == 6)) {
        toDate = stringtoDate(provider.availableDate["to"]);
      }

      numberOfDays = availableDay - selectDay;
      return Scaffold(
        key: applyLeaveKey,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            width: size.width,
            height: size.height,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  topnavBar('Apply for Leave', () {
                    Navigator.of(context).pop();
                    provider.availableDate.clear();
                  }, size),
                  const Text('Leave Type',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropDown(
                    selectedValue: selectedValue,
                    givenList: provider.leaveList,
                    keyList: "leave_type_name",
                    hint: "Select Leave Type",
                    onChanged: (id) => setState(() {
                      selectedValue = id as Map;
                      selectedday = leaveDuration[0];
                      logger.e(selectedValue);
                      fromDate = null;
                      toDate = null;
                      provider.availableDate["number_of_day"] = null;
                      provider.availableDate["balance"] = null;
                      purposeControler.clear();
                    }),
                  ),
                  const Text('From Date',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DatePickerCommon(
                      fun: () => datePick(true),
                      text:
                          'From date : ${fromDate == null ? "" : DateFormat('dd MMM yyyy').format(fromDate!)}'),
                  selectedValue["leave_type_name"] == "OD"
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('To Date',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            DatePickerCommon(
                                fun: selectedValue["leave_type_id"] == 6 ||
                                        selectedValue["leave_type_id"] == 5
                                    ? () {}
                                    : fromDate == null
                                        ? () => notif("Warning",
                                            "Kindly Select From date")
                                        : () => datePick(false),
                                text:
                                    'To date : ${toDate == null ? "" : getFormateddateMonth(toDate.toString())}'),
                          ],
                        ),
                  const SizedBox(height: 4),
                  if (selectedValue['leave_type_id'] == 1 ||
                      selectedValue['leave_type_id'] == 2 ||
                      selectedValue['leave_type_id'] == 7) ...[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Leave Duration',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          DropDown(
                            selectedValue: selectedday,
                            givenList: leaveDuration,
                            keyList: "name",
                            hint: "Leave duration",
                            onChanged: (id) => setState(() {
                              selectedday = id as Map;
                              availableDay = 0;
                              selectDay = 0.0;
                            }),
                          ),
                        ])
                  ],
                  Text(
                      selectedValue["leave_type_id"] == 5
                          ? "Total Months"
                          : 'Number Of Days',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: double.maxFinite,
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: targetDetailColor.brand),
                          borderRadius: BorderRadius.circular(8)),
                      child: provider.availableDate.isNotEmpty
                          ? selectedValue["leave_type_id"] == 5
                              ? Text("${provider.availableDate["durations"]}",
                                  style: styleForm)
                              : selectedValue["leave_type_id"] == 3
                                  ? Text("1.0 Day", style: styleForm)
                                  : Text(
                                      numberOfDays == 0.0
                                          ? "No.Of.Days"
                                          : '$numberOfDays Days',
                                      style: styleForm)
                          : const Text('No.Of.Days',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey))),
                  const SizedBox(height: 8),
                  customTextField(purposeControler, 'Purpose', 'Enter Purpose',
                      140, 9, TextInputType.multiline),
                  Consumer<LeaveProvider>(builder: (_, provider, __) {
                    return provider.leaveLoading
                        ? Center(child: loader50())
                        : buttonPrimary(context.widthFull(), 24,
                            "SEND APPLICATION", () => apiCall());
                  }),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    textControler.dispose();
    fromDateControler.dispose();
    toDateControler.dispose();
    purposeControler.dispose();
    super.dispose();
  }

  apiCall() {
    FocusScope.of(context).unfocus();
    if (selectedValue.isEmpty) {
      return notif('Failed', "Kindly select the Leave Type");
    }
    if (fromDate == null) {
      return notif('Failed', "Kindly select the From Date");
    }
    // logger.i(selectedValue);
    if (toDate == null && selectedValue["leave_type_name"] != "OD") {
      return notif('Failed', "Kindly select the To Date");
    }
    if (selectedday.isEmpty &&
        !(selectedValue['leave_type_id'] == 5 ||
            selectedValue['leave_type_id'] == 3 ||
            selectedValue['leave_type_id'] == 6)) {
      return notif('Failed', "Kindly select leave duration");
    }
    if (purposeControler.text.isEmpty) {
      return notif('Failed', "Kindly enter the Purpose");
    }

    var maternity = selectedValue['leave_type_id'] == 5
        ? jsonDecode("${provdLeave.availableDate["balance"] ?? {}}")
        : {};
    var paternity = selectedValue['leave_type_id'] == 6
        ? jsonDecode("${provdLeave.availableDate["balance"] ?? {}}")
        : {};
    var data = {
      'employee_id': provdAuth.userData['employee_id'].toString(),
      'leave_type_id': selectedValue['leave_type_id'].toString(),
      'application_from_date':
          DateFormat('yyyy-MM-dd').format(fromDate!).toString(),
      'application_to_date': selectedValue['leave_type_id'] == 5
          ? provdLeave.getFormatedMonth("${maternity["to"]}")
          : selectedValue['leave_type_id'] == 3
              ? DateFormat('yyyy-MM-dd').format(fromDate!).toString()
              : DateFormat('yyyy-MM-dd').format(toDate!).toString(),
      'purpose': purposeControler.text,
    };
    data.addAll({
      "number_of_day":
          selectedValue['leave_type_id'] == 3 ? "1.0" : "$numberOfDays"
    });

    data.addAll(
        {'half_day': "${selectedday["id"] == "0.0" ? "" : selectedday["id"]}"});
    // else {
    //   data.addAllIf(targetDetail.functions.any((element) => element == 10), {
    //     'day_type': fromDate != toDate
    //         ? "1"
    //         : "${selectedday["id"] == "0.0" ? "1" : selectedday["id"]}"
    //   });
    //   // data.addAllIf(targetDetail.functions.any((element) => element == 10),
    //   //     {'day_type': isFullDay ? '1' : '2'});
    // }

    logger.e(data);
    return provdLeave.applyLeave(context, data);
  }
}
