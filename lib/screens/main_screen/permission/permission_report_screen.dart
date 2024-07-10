import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/contexts.dart';
import 'package:in4_solution/constants/fonts.dart';
import 'package:in4_solution/constants/loaders.dart';
import 'package:in4_solution/constants/topnavbar.dart';
import 'package:in4_solution/providers/permission_provider.dart';
import 'package:in4_solution/screens/utility/dialogue.dart';
import 'package:in4_solution/screens/utility/empty_list.dart';
import 'package:in4_solution/screens/utility/shimmer_permission.dart';
import 'package:provider/provider.dart';

import '../../../config/enums.dart';

class PermissionReportScreen extends StatefulWidget {
  const PermissionReportScreen({super.key});

  @override
  State<PermissionReportScreen> createState() => _PermissionReportScreenState();
}

class _PermissionReportScreenState extends State<PermissionReportScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<PermissionProvider>(builder: (context, permission, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size(context.widthFull(), 40),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: topnavBar("Permission Report", () {
                  Navigator.pop(context);
                }, size),
              ),
            )),
        body: SafeArea(
          child: permission.isGetting
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: ShimmerPermission())
              : permission.permissions.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [EmptyList()])
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                          const SizedBox(height: 12),
                          permission.isGetting
                              ? Center(child: loader50())
                              : ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: permission.permissions.length,
                                  itemBuilder: (context, index) {
                                    return PermissionTile(
                                        permission:
                                            permission.permissions[index]);
                                  },
                                )
                        ]),
        ),
      );
    });
  }
}

class PermissionTile extends StatelessWidget {
  const PermissionTile({super.key, required this.permission});
  final Map permission;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => commonDialog(context, PermissionReportData(data: permission),
          isHadborder: true),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: targetDetailColor.brand),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
                getFormateddate(
                    "${permission['leave_permission_date'] ?? '-'}"),
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w500)),
            buttonPrimary1("View Status", () {
              commonDialog(context, PermissionReportData(data: permission),
                  isHadborder: true);
            }, height: 36.0, size: 12.0)
          ]),
          const SizedBox(height: 8),
          Text("${permission['leave_permission_purpose'] ?? '-'}",
              style:
                  GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Duration : ${permission['permission_duration'] ?? '-'}",
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w400)),
            Text(
                "${permission['from_time'] ?? ''} - ${permission['to_time'] ?? ''}",
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w400)),
          ]),
        ]),
      ),
    );
  }

  Color getColor(String val) {
    Color color = const Color(0xff41B3F9);
    if (val.contains('Approved')) {
      color = targetDetailColor.success;
    } else if (val.contains('Rejected')) {
      color = targetDetailColor.danger;
    } else {
      color = const Color(0xff41B3F9);
    }

    return color;
  }
}

class PermissionReportData extends StatelessWidget {
  const PermissionReportData({super.key, required this.data});
  final Map data;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 24),
          textTittle("Permission Report", targetDetailColor.brand),
          InkWell(
              onTap: () => Navigator.pop(context),
              child:
                  Icon(Icons.cancel_outlined, color: targetDetailColor.brand))
        ],
      ),
      const SizedBox(height: 12),
      const SizedBox(height: 8),
      const SizedBox(height: 8),
      ReportTile1(
          text1: 'Permission Date',
          text2: getFormateddate("${data['leave_permission_date'] ?? 'N/A'}")),
      const SizedBox(height: 8),
      ReportTile1(
          text1: 'Timing',
          text2: '${data['from_time'] ?? ''} - ${data['to_time'] ?? ''}'),
      const SizedBox(height: 8),
      ReportTile1(
          text1: 'Duration', text2: '${data['permission_duration'] ?? 'N/A'}'),
      const SizedBox(height: 8),
      ReportTile1(
          text1: 'Purpose',
          text2: '${data['leave_permission_purpose'] ?? 'N/A'}'),
      const SizedBox(height: 8),
      ReportTile1(
          text1: 'Status',
          text2: '${data['functional_head__status'] ?? 'N/A'}'),
      const SizedBox(height: 8),
      ReportTile1(text1: 'Remarks', text2: '${data['remark'] ?? 'N/A'}'),
      const SizedBox(height: 8),
    ]);
  }
}

class ReportTile1 extends StatelessWidget {
  const ReportTile1({super.key, required this.text1, required this.text2});
  final String text1, text2;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
          width: context.widthHalf() - 40,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(text1,
                style:
                    styleReport(weight: FontWeight.w400, color: Colors.grey)),
            Text(':', style: styleReport(weight: FontWeight.w400)),
          ])),
      const SizedBox(width: 8),
      Expanded(child: Text(text2, style: styleReport())),
    ]);
  }
}
