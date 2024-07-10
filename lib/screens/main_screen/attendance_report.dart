import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/../constants/contexts.dart';
import '/../constants/keys.dart';
import '/../providers/attendance_provider.dart';
import '../../constants/buttons.dart';
import '../../constants/fonts.dart';
import '../../constants/loaders.dart';
import '../../constants/topnavbar.dart';
import '../utility/dialogue.dart';
import '../utility/shimmer.dart';

class AttendacneReport extends StatefulWidget {
  const AttendacneReport({Key? key}) : super(key: key);

  @override
  State<AttendacneReport> createState() => _AttendacneReportState();
}

class _AttendacneReportState extends State<AttendacneReport> {
  void attendanceData() {
    var data = {
      'employee_id': provdAuth.userData['employee_id'].toString(),
      'date': DateFormat('yyyy-MM-dd')
          .format(
              Provider.of<AttendanceProvider>(context, listen: false).fromDate)
          .toString(),
    };
    Provider.of<AttendanceProvider>(context, listen: false)
        .attendanceReport(context, data);
  }

  Future datePick(bool forFromDate) async {
    DateTime selectedDate = await commonDialogCommon(
      context,
      DatePickerDialog(
          initialDate: DateTime.now(),
          firstDate: DateTime(2020, 1, 1),
          lastDate: DateTime.now()),
    );
    if (forFromDate) {
      // ignore: use_build_context_synchronously
      return Provider.of<AttendanceProvider>(context, listen: false)
          .fromDatePick(selectedDate);
    } else {
      // ignore: use_build_context_synchronously
      return Provider.of<AttendanceProvider>(context, listen: false)
          .toDatePick(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<AttendanceProvider>(builder: (_, provider, __) {
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
                    topnavBar("Day Attendance", () {
                      Navigator.pop(context);
                      Provider.of<AttendanceProvider>(context, listen: false)
                          .clearAttendanceList();
                    }, size),
                    const SizedBox(height: 12),
                    const Text('Date to Check',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    GestureDetector(
                        onTap: () => datePick(true),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            width: double.maxFinite,
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: targetDetailColor.brand),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                                'Date : ${DateFormat('dd MMM yyyy').format(provider.fromDate)}',
                                style: styleForm))),
                    const SizedBox(height: 12),
                    Consumer<AttendanceProvider>(builder: (_, provider, __) {
                      return provider.attendanceLoading
                          ? Center(child: loader50())
                          : buttonPrimary(
                              context.widthFull(),
                              24,
                              "CHECK",
                              () => attendanceData(),
                            );
                    }),
                    const SizedBox(height: 12),
                    provider.attendanceLoading
                        ? const ShimmerList()
                        : provider.attendanceList.isNotEmpty
                            ? Column(
                                children: [
                                  Container(
                                      decoration: decorBgMutedTopBorder,
                                      child: topBarListhead()),
                                  Container(
                                    decoration: decorBgMutedBottomBorder,
                                    child: ListView.builder(
                                      itemCount: provider.attendanceList.length,
                                      scrollDirection: Axis.vertical,
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        var mod = index % 2;
                                        return ReportContainer(
                                            mod: mod,
                                            data:
                                                provider.attendanceList[index]);
                                      },
                                    ),
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
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textTablehead("DATE & TIME"),
            textTablehead("TYPE"),
            SizedBox(
                width: 100,
                child: textTablehead("DEVICE", align: TextAlign.end)),
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
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        color: mod != 0 ? targetDetailColor.light : targetDetailColor.muted,
        width: context.widthFull(),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            child: Text(
              "${DateFormat('dd MMM yyyy').format(DateTime.parse(data['datetime']))}\n${DateFormat('hh:mm a').format(DateTime.parse(data['datetime']))}",
            ),
          ),
          Text("${data['type'] ?? '-'}", textAlign: TextAlign.center),
          SizedBox(
              width: 100,
              child: Text("${data['device_name'] ?? 'FRT'}",
                  textAlign: TextAlign.right))
        ]));
  }
}
