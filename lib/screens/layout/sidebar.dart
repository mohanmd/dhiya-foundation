import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in4_solution/constants/contexts.dart';
import 'package:in4_solution/constants/local_icons.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/providers/permission_provider.dart';
import 'package:in4_solution/screens/main_screen/change_password_screen.dart';
import 'package:in4_solution/screens/main_screen/leave/leave_application_admin.dart';
import 'package:in4_solution/screens/main_screen/permission/permission_application.dart';
import 'package:in4_solution/screens/main_screen/permission/permission_ask_screen.dart';
import 'package:in4_solution/screens/main_screen/permission/permission_report_screen.dart';
import 'package:provider/provider.dart';
import '/../providers/layout_provider.dart';
import '../main_screen/leave/apply_leave.dart';
import '/../screens/main_screen/attendance_report.dart';
import '../main_screen/leave/leave_reports.dart';
import '../../config/enums.dart';
import '../utility/dialogue.dart';

// class ScreenColors extends StatefulWidget {
//   const ScreenColors({Key? key}) : super(key: key);

//   @override
//   State<ScreenColors> createState() => _ScreenColorsState();
// }

// class _ScreenColorsState extends State<ScreenColors> {
//   List<Widget> screens = [
//     const LeaveApplication(),
//     const LeaveReport(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LayoutProvider>(builder: (_, provd, __) {
//       return ClipRRect(
//         borderRadius: const BorderRadius.all(Radius.circular(12)),
//         child: Container(
//             color: Colors.white,
//             child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: screens[provd.navbar])),
//       );
//     });
//   }
// }

List commonSideBarList = [
  {
    'id': 1,
    'title': 'DashBoard',
    'icon': Icons.person_outline,
    'img': '',
    'children': [],
    'onTap': () => Navigator.pop(Get.context!)
  },
  {
    'id': 2,
    'title': 'Day Attendance',
    'icon': Icons.description_outlined,
    'img': LocalIcons.attendanceReport,
    'children': [],
    'onTap': () => Navigator.of(Get.context!).push(MaterialPageRoute(
        builder: (BuildContext context) => const AttendacneReport()))
  },
  {
    'id': 4,
    'title': 'Apply leave',
    "is_admin_menu": false,
    'icon': Icons.document_scanner_outlined,
    'img': LocalIcons.leaveApply,
    'onTap': () {
      Navigator.of(Get.context!).push(MaterialPageRoute(
          builder: (BuildContext context) => const LeaveApplication()));
    },
  },
  {
    "id": 5,
    'title': 'Leave Reports',
    "is_admin_menu": false,
    'icon': Icons.description_outlined,
    'img': LocalIcons.leaveReport,
    'onTap': () => Get.to(const LeaveReport()),
  },
  {
    "id": 6,
    'title': 'Leave Applications',
    "is_admin_menu": true,
    'icon': Icons.description_outlined,
    'img': LocalIcons.leaveReport,
    'onTap': () => Get.to(const LeaveApplicationAdmin()),
  },
  {
    'id': 8,
    'title': 'Ask Permission',
    "is_admin_menu": false,
    'icon': Icons.remember_me_outlined,
    'img': LocalIcons.permissionAsk,
    'onTap': () {
      Navigator.of(Get.context!).push(MaterialPageRoute(
          builder: (BuildContext context) => const PermissionAskScreen()));
    },
  },
  {
    "id": 9,
    'title': 'Permission Reports',
    "is_admin_menu": false,
    'icon': Icons.remember_me_outlined,
    'img': LocalIcons.permissionReport,
    'onTap': () {
      Provider.of<PermissionProvider>(Get.context!, listen: false)
          .getPermissions(Get.context!);
      Navigator.of(Get.context!).push(MaterialPageRoute(
          builder: (BuildContext context) => const PermissionReportScreen()));
    }
  },
  {
    "id": 10,
    'title': 'Permission Application',
    "is_admin_menu": true,
    'icon': Icons.remember_me_outlined,
    'img': LocalIcons.permissionReport,
    'onTap': () => Get.to(const PermissionApplicationAdmin()),
  },
  {
    'id': 11,
    'title': 'Change Password',
    'icon': Icons.lock_reset_outlined,
    'img': '',
    'children': [],
    'onTap': () => Navigator.of(Get.context!).push(MaterialPageRoute(
        builder: (BuildContext context) => const ChangePasswordScreen()))
  },
];
List sideBar = [];

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  getSideBarList() {
    if (sideBar.isNotEmpty) return null;
    for (var data in commonSideBarList) {
      if (provdCommon.sideBarList.any((id) => id["id"] == data['id'])) {
        sideBar.add(data);
      }
    }
  }

  @override
  void initState() {
    getSideBarList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      child: Container(
          height: size.height,
          width: context.widthHalf() + context.widthHalf() / 3,
          color: Colors.white,
          child: SafeArea(
            child: Column(children: [
              head(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: sideBar.length,
                  itemBuilder: (context, index) {
                    Map data = sideBar[index];
                    return middle(data, index);
                  },
                ),
              ),
              ListTile(
                  leading: Icon(Icons.logout,
                      size: 22, color: targetDetailColor.dark),
                  horizontalTitleGap: 0,
                  title: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text('Logout',
                        style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: targetDetailColor.dark,
                            fontWeight: FontWeight.w400,
                            height: 1,
                            letterSpacing: 0.75)),
                  ),
                  onTap: () {
                    commonDialog(Get.context!, logoutConfirm(Get.context!));
                  }),
            ]),
          )),
    );
  }

  bool isExpand = false;

  Widget head() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Image.asset("assets/In4 Solution.png",
          height: 140, width: 150, fit: BoxFit.fitWidth));

  Widget middle(Map data, int index) {
    return Consumer<LayoutProvider>(builder: (_, provd, __) {
      String image = data['img'] ?? '';
      Color color =
          provd.navbar == index ? Colors.white : targetDetailColor.dark;
      return Container(
        decoration: BoxDecoration(
            color:
                provd.navbar == index ? targetDetailColor.brand : Colors.white),
        child: ListTile(
            leading: image.isNotEmpty
                ? Image.asset(image, height: 20, color: color)
                : Icon(data['icon'], size: 22, color: color),
            horizontalTitleGap: 0,
            title: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(data['title'],
                  style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: provd.navbar == index
                          ? targetDetailColor.light
                          : targetDetailColor.dark,
                      fontWeight: FontWeight.w400,
                      height: 1,
                      letterSpacing: 0.75)),
            ),
            onTap: () {
              data['onTap']();
              provdLayout.changeNav(index);
            }),
      );
    });
  }
}
