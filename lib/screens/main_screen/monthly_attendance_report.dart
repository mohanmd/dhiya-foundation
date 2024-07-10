import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/screens/utility/drop_down.dart';
import 'package:in4_solution/screens/utility/shimmer_attendance.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/../constants/contexts.dart';
import '/../constants/keys.dart';
import '/../providers/attendance_provider.dart';
import '../../constants/fonts.dart';
import '../../constants/topnavbar.dart';

class MonthlyAttendacneReport extends StatefulWidget {
  const MonthlyAttendacneReport({Key? key}) : super(key: key);

  @override
  State<MonthlyAttendacneReport> createState() =>
      _MonthlyAttendacneReportState();
}

class _MonthlyAttendacneReportState extends State<MonthlyAttendacneReport> {
  void attendanceData() {
    var data = {
      'employee_id': provdAuth.userData['employee_id'].toString(),
      'date': DateFormat('yyyy-MM-dd')
          .format(
              Provider.of<AttendanceProvider>(context, listen: false).fromDate)
          .toString(),
      // 'to_date': DateFormat('yyyy-MM-dd')
      //     .format(
      //         Provider.of<AttendanceProvider>(context, listen: false).toDate)
      //     .toString(),
    };
    Provider.of<AttendanceProvider>(context, listen: false)
        .attendanceReport(context, data);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (provdAttendance.months.isEmpty) provdAttendance.getMonths();
    });
    super.initState();
  }

  Map? selectedMonth;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List color = [
      {'color': const Color.fromARGB(255, 69, 192, 75)},
      {'color': const Color.fromARGB(255, 69, 192, 150)},
      {'color': const Color.fromARGB(255, 245, 83, 83)},
      {'color': const Color.fromARGB(255, 212, 184, 92)},
      {'color': const Color.fromARGB(255, 168, 121, 248)},
      {'color': Colors.blue.shade300},
      {'color': const Color.fromARGB(255, 146, 155, 62)},
      {'color': const Color.fromARGB(255, 255, 157, 0)},
      {'color': const Color.fromARGB(255, 20, 124, 107)},
      {'color': const Color.fromARGB(255, 255, 148, 148)},
      {'color': const Color.fromARGB(255, 98, 80, 255)},
    ];

    List presentData = [
      // {"head": "PR", "title": "", "color": Colors.green},
      // {"head": "", "title": "Present", "color": Colors.green},
      // {"head": "AB", "title": "", "color": Colors.red},
      // {"head": "", "title": "Absent", "color": Colors.red},
      // {"head": "WH", "title": "", "color": Colors.orange},
      // {"head": "", "title": "Week Holiday", "color": Colors.orange},
      // {"head": "PH", "title": "", "color": Colors.limeAccent},
      // {"head": "", "title": "Public Holiday", "color": Colors.limeAccent},
      {
        'title': 'P',
        'value': 'Present',
        'color': const Color.fromARGB(255, 69, 192, 75)
      },
      {
        'title': 'HD',
        'value': 'Half Day',
        'color': const Color.fromARGB(255, 69, 192, 150)
      },
      {
        'title': 'A',
        'value': 'Absent',
        'color': const Color.fromARGB(255, 245, 83, 83)
      },
      {
        'title': 'WH',
        'value': 'Week Holiday',
        'color': const Color.fromARGB(255, 212, 184, 92)
      },
      {
        'title': 'PH',
        'value': 'Public Holiday',
        'color': const Color.fromARGB(255, 168, 121, 248)
      },
      {'title': 'LE', 'value': 'Leave', 'color': Colors.blue.shade300},
      {
        'title': 'OD',
        'value': 'On Duty',
        'color': const Color.fromARGB(255, 146, 155, 62)
      },
      {
        'title': 'CO',
        'value': 'Comp Off',
        'color': const Color.fromARGB(255, 255, 157, 0)
      },

      {
        'title': 'LT',
        'value': 'Left',
        'color': const Color.fromARGB(255, 20, 124, 107)
      },
      {
        'title': 'MH',
        'value': 'Mandatory',
        'color': const Color.fromARGB(255, 255, 148, 148)
      },
      {
        'title': 'OH',
        'value': 'Optional Holiday',
        'color': const Color.fromARGB(255, 98, 80, 255)
      },
    ];

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
                    topnavBar("Monthly Attendance", () {
                      Navigator.pop(context);
                      // Provider.of<LayoutProvider>(context, listen: false)
                      //     .changeNav(0);

                      Provider.of<AttendanceProvider>(context, listen: false)
                          .clearAttendanceList();
                      setState(() {});
                    }, size),
                    const SizedBox(height: 12),
                    const Text('Month to Check',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    // textField(contMonth, 'Select a month', TextInputType.none, onTap: () {}),
                    dropdownButtonCustom(
                        provider.selectedMonth, provider.months, 'input',
                        (value) {
                      provider.selectedMonth = value as Map;
                      provdAttendance.setSelectedMonth(provider.selectedMonth);
                      setState(() {});
                    }, label: "Select Month"),
                    const SizedBox(height: 12),
                    // Consumer<AttendanceProvider>(builder: (_, provider, __) {
                    //   return provider.attendanceLoading
                    //       ? Center(child: loader50())
                    //       : buttonPrimary(
                    //           context.widthFull(),
                    //           24,
                    //           "CHECK",
                    //           () => );
                    // }),
                    provider.attendanceLoading
                        ? const ShimmerAttendance()
                        : provider.monthlyAttendanceList.isNotEmpty
                            ? Column(
                                children: [
                                  GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        provider.monthlyAttendanceList.length +
                                            provider.weeks.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisSpacing: 4,
                                            crossAxisSpacing: 8,
                                            crossAxisCount: 7),
                                    itemBuilder: (context, index) {
                                      // logger.e(provider.weeks);

                                      if (index < 7) {
                                        return Center(
                                            child: textCustom(
                                                provider.weeks[index]['day'],
                                                color:
                                                    targetDetailColor.brand));
                                      } else {
                                        var date = provider
                                            .monthlyAttendanceList[index - 7];

                                        Map color = presentData.firstWhere(
                                            (element) =>
                                                (date['halfday_status'] ==
                                                        "0.5" &&
                                                    element['title'] == 'HD') ||
                                                element['title'] ==
                                                    date['attendance_label'],
                                            orElse: () => {});

                                        return Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                color: color['color'],
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                textCustom(
                                                    '${date['day'] ?? ''}',
                                                    color:
                                                        color['color'] != null
                                                            ? targetDetailColor
                                                                .light
                                                            : targetDetailColor
                                                                .primaryDark),
                                                textCustom(
                                                    '${color['title'] ?? ''}',
                                                    color:
                                                        color['color'] != null
                                                            ? targetDetailColor
                                                                .light
                                                            : targetDetailColor
                                                                .primaryDark,
                                                    size: 11),
                                              ],
                                            ));
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  GridView.builder(
                                    itemCount: provider.attendanceStatus.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 30,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                      crossAxisCount: 2,
                                    ),
                                    itemBuilder: (context, index) {
                                      String title = provider
                                          .attendanceStatus[index]["value"];
                                      Color itemColor = color[index]["color"];

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          title == ""
                                              ? const SizedBox.shrink()
                                              : Row(
                                                  children: [
                                                    const SizedBox(width: 26),
                                                    Container(
                                                        width: 10,
                                                        height: 10,
                                                        color: itemColor),
                                                    const SizedBox(width: 8),
                                                    textCustom(title,
                                                        color: itemColor,
                                                        weight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                        ],
                                      );
                                    },
                                  )
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
              child: Text("${data['device_name'] ?? '-'}",
                  textAlign: TextAlign.right))
        ]));
  }
}
