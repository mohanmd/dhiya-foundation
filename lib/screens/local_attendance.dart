import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/screens/utility/empty_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/../constants/contexts.dart';
import '/../providers/location_internet.dart';
import '../constants/topnavbar.dart';
import '../providers/attendance_provider.dart';
import 'utility/dialogue.dart';

class LocalAttendance extends StatefulWidget {
  const LocalAttendance({super.key});

  @override
  State<LocalAttendance> createState() => _LocalAttendanceState();
}

class _LocalAttendanceState extends State<LocalAttendance> {
  List localAttendance = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      List provid = Provider.of<LocationProvider>(context, listen: false).attendanceData;
      for (int i = 0; i < provid.length; i++) {
        setState(() {
          localAttendance.add(jsonDecode(provid[i]));
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              topnavBar("Offline Attendance Report", () {
                Navigator.pop(context);
                // Provider.of<LayoutProvider>(context, listen: false)
                //     .changeNav(0);
                Provider.of<AttendanceProvider>(context, listen: false).clearAttendanceList();
              }, MediaQuery.of(context).size),
              if (localAttendance.isNotEmpty)
                Container(
                  decoration: decorBgMutedBottomBorder,
                  child: ListView.builder(
                    itemCount: localAttendance.length,
                    scrollDirection: Axis.vertical,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var mod = index % 2;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        color: mod != 0 ? targetDetailColor.light : targetDetailColor.muted,
                        width: context.widthFull(),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  child: Text(
                                      DateFormat('dd MMM yyyy').format(DateTime.parse(localAttendance[index]['in_out_time'])).toString()),
                                ),
                                SizedBox(
                                  child: Text(
                                    DateFormat('hh:mm a').format(DateTime.parse(localAttendance[index]['in_out_time'])),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                localAttendance[index]['check_type'] == "0"
                                    ? const Text("Check In", textAlign: TextAlign.right)
                                    : const Text("Check out", textAlign: TextAlign.right),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'lat: ${localAttendance[index]['latitude']}',
                                  textAlign: TextAlign.right,
                                ),
                                Text(
                                  'long: ${localAttendance[index]['longitude']}',
                                  textAlign: TextAlign.right,
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              if (localAttendance.isEmpty) ...[
                const Spacer(),
                const EmptyList(),
                const Spacer(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
