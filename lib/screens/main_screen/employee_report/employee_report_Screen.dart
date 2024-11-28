import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/providers/employee_provider.dart';
import 'package:in4_solution/screens/main_screen/employee_report/employee_view_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/../constants/contexts.dart';
import '/../constants/keys.dart';
import '/../providers/attendance_provider.dart';
import '../../../constants/buttons.dart';
import '../../../constants/fonts.dart';
import '../../../constants/loaders.dart';
import '../../../constants/topnavbar.dart';
import '../../utility/dialogue.dart';
import '../../utility/shimmer.dart';

class EmployeeReportScreen extends StatefulWidget {
  const EmployeeReportScreen({Key? key}) : super(key: key);

  @override
  _EmployeeReportScreenState createState() => _EmployeeReportScreenState();
}

class _EmployeeReportScreenState extends State<EmployeeReportScreen> {
  void employeeReportData() {
    var data = {
      'date': DateFormat('yyyy-MM-dd').format(Provider.of<EmployeeProvider>(context, listen: false).fromDate).toString(),
    };
    Provider.of<EmployeeProvider>(context, listen: false).getEmployeeList(context, data);
  }

  Future datePick(bool forFromDate) async {
    DateTime selectedDate = await commonDialogCommon(
      context,
      DatePickerDialog(initialDate: DateTime.now(), firstDate: DateTime(2020, 1, 1), lastDate: DateTime.now()),
    );
    if (forFromDate) {
      // ignore: use_build_context_synchronously
      return Provider.of<EmployeeProvider>(context, listen: false).fromDatePick(selectedDate);
    } else {
      // ignore: use_build_context_synchronously
      return Provider.of<EmployeeProvider>(context, listen: false).toDatePick(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<EmployeeProvider>(builder: (_, provider, __) {
      return Scaffold(
        key: attendanceKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: size.height,
              width: size.width,
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    topnavBar("Employee Report", () {
                      Navigator.pop(context);
                      // Provider.of<EmployeeProvider>(context, listen: false).clearAttendanceList();
                    }, size),
                    const SizedBox(height: 12),
                    const Text('Date to Check', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    GestureDetector(
                        onTap: () {
                          datePick(true);
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            width: double.maxFinite,
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration:
                                BoxDecoration(border: Border.all(width: 1, color: targetDetailColor.brand), borderRadius: BorderRadius.circular(8)),
                            child: Text('Date : ${DateFormat('dd MMM yyyy').format(provider.fromDate)}', style: styleForm))),
                    const SizedBox(height: 12),
                    Consumer<AttendanceProvider>(builder: (_, provider, __) {
                      return provider.attendanceLoading
                          ? Center(child: loader50())
                          : buttonPrimary(
                              context.widthFull(),
                              24,
                              "CHECK",
                              () {
                                employeeReportData();
                              },
                            );
                    }),
                    const SizedBox(height: 12),
                    provider.employeeListLoading
                        ? const ShimmerList()
                        : provider.employeeList.isNotEmpty
                            ? Column(
                                children: [
                                  ListView.builder(
                                    itemCount: provider.employeeList.length,
                                    scrollDirection: Axis.vertical,
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var mod = index % 2;
                                      // return Text("data");
                                      return ReportContainer(mod: mod, data: provider.employeeList[index]);
                                    },
                                  ),
                                ],
                              )
                            : Container(
                                alignment: Alignment.center,
                                height: context.heightHalf() / 2,
                                width: context.widthFull(),
                                child: Text("No Data Found", style: styleForm)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget topBarListhead() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      width: context.widthFull(),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        textTablehead("DATE & TIME"),
        textTablehead("TYPE"),
        SizedBox(width: 100, child: textTablehead("DEVICE", align: TextAlign.end)),
        // Expanded(flex: 4, child: textTablehead("OUT TIME")),
        // Expanded(flex: 4, child: textTablehead("TOTAL HRs")),
      ]));
}

class ReportContainer extends StatelessWidget {
  const ReportContainer({super.key, required this.mod, required this.data});

  final int mod;
  final Map data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeViewScreen(id: data['finger_id']),
          ),
        );
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: targetDetailColor.light,
          ),
          width: context.widthFull(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Employee Name ",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text("${data['employee_name'] ?? '-'}", textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    const Text(
                      "Employee ID",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text("${data['finger_id'] ?? '-'}", textAlign: TextAlign.center),
                  ],
                ),
              ),
              punchCount(count: "Punch Count : ${data['count'] ?? 'FRT'}"),
              // Expanded(
              //   child: Column(
              //     children: [
              //       const Text(
              //         "Punch In count",
              //         textAlign: TextAlign.center,
              //         style: TextStyle(color: Colors.grey),
              //       ),
              //       Text("${data['count'] ?? 'FRT'}", textAlign: TextAlign.right)
              //     ],
              //   ),
              // ),
            ],
          )),
    );
  }

  Container punchCount({count}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(color: Colors.red.shade300, borderRadius: BorderRadius.circular(10)),
      child: Text(
        count,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13.0,
        ),
      ),
    );
  }
}
