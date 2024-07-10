
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/contexts.dart';
import 'package:in4_solution/constants/fonts.dart';
import 'package:in4_solution/constants/keys.dart';
import 'package:in4_solution/constants/loaders.dart';
import 'package:in4_solution/constants/notifications.dart';
import 'package:in4_solution/constants/text_field.dart';
import 'package:in4_solution/constants/topnavbar.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/providers/auth_provider.dart';
import 'package:in4_solution/providers/permission_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../config/enums.dart';

class PermissionAskScreen extends StatefulWidget {
  const PermissionAskScreen({super.key});

  @override
  State<PermissionAskScreen> createState() => _PermissionAskScreenState();
}

class _PermissionAskScreenState extends State<PermissionAskScreen> {
  String? date;
  String? time;
  TextEditingController purposeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  String? duration;
  String? resultFromTime;
  String? resultToTime;
  String balanceLeave = '';
  int maxDuration = 2;
  bool isRestriction = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provdPermission.getPermissionsCount();
    });
    super.initState();
  }

  int getDuration(String data) {
    var format = DateFormat("HH:mm:ss");
    return format.parse(data).hour + (format.parse(data).minute ~/ 60);
  }

  int minDuration = 1;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<PermissionProvider>(builder: (context, permission, child) {
      balanceLeave =
          '${permission.permissionInfo['PERMISSION_BALANCE'] ?? permission.permissionInfo['balance_count'] ?? ''}';
      Map permissionMaster =
          permission.permissionInfo['permission_master'] ?? {};
      maxDuration = permissionMaster['max_duration'] != null
          ? getDuration(permissionMaster['max_duration'])
          : 3;
      minDuration = permissionMaster['min_duration'] != null
          ? getDuration(permissionMaster['min_duration'])
          : 1;
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: <Widget>[
                topnavBar("Ask Permission", () {
                  Navigator.pop(context);
                }, size),
                heading('Permission Date'),
                picker("Date", date ?? "", () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1990),
                    lastDate: DateTime(DateTime.now().year + 1),
                    builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                                primary: targetDetailColor.brand)),
                        child: child!),
                  );
                  if (pickedDate != null) {
                    var params = {
                      'employee_id':
                          provdAuth.userData['employee_id'].toString(),
                      'permission_date':
                          DateFormat('dd-MM-yyyy').format(pickedDate)
                    };
                    provdPermission.changeDate(params);

                    setState(() {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      date = formattedDate;
                    });
                  }
                }),
                const SizedBox(height: 12),
                timeDuration(),
                const SizedBox(height: 12),
                customTextField(purposeController, 'Purpose', 'Enter Purpose',
                    140, 9, TextInputType.multiline),
                const SizedBox(height: 24),
                permission.isCreating
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [loader35()],
                      )
                    : buttonPrimary(context.widthFull(), 24, "ASK PERMISSION",
                        () {
                        apiCall();
                      })
              ]),
        ),
      );
    });
  }

  Map selectedType = {};

  List permissionType = [
    {"id": "0", "name": "Personal"},
    {"id": "1", "name": "Official"},
  ];

  timeDuration() {
    return fromTimeToTime();
  }

  Widget durationOnly() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading('Duration (Max-${maxDuration}hrs)'),
        picker(
          "Time",
          duration ?? '',
          () async {
            resultingDuration = await showDurationPicker(
                context: context,
                initialTime: const Duration(minutes: 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)));

            if (resultingDuration != null && resultingDuration.inHours >= 2) {
              notif(
                  'Failed', 'The maximum duration of permission is two hours');
              setState(() {
                duration = '02:00';
              });
            } else if (resultingDuration != null) {
              setState(() {
                String formattedDuration =
                    '${resultingDuration.inHours}:${resultingDuration.inMinutes.remainder(60)}';
                duration = formattedDuration;
              });
            }
          },
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget fromTimeToTime() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      heading('From Time'),
      picker(
        "Time",
        resultFromTime ?? '',
        () async {
          Navigator.push(
              context,
              showPicker(
                iosStylePicker: true,
                value: initialTine,
                onChange: (res) {
                  // if (res.minute % 30 != 0) {
                  //   notif("Failed",
                  //       "You must enter the time as a multiple of 30 minutes");
                  //   return;
                  // }
                  setState(() {
                    resultToTime = null;
                    initialTine = Time(hour: res.hour, minute: res.minute);
                    resultFromTime = initialTine.format(context);
                  });
                },
              ));
        },
      ),
      const SizedBox(height: 12),
      heading('To Time'),
      picker(
        "Time",
        resultToTime ?? '',
        () async {
          if (resultFromTime == null) {
            return notif(
                'Failed', 'Kindly select the from time of the permission');
          }
          Navigator.push(
              context,
              showPicker(
                minHour: double.parse('${initialTine.hour}'),
                maxHour: double.parse(
                    '${initialTine.hour <= 20 ? initialTine.hour + maxDuration : double.infinity}'),
                maxMinute: initialTine.minute.toDouble(),
                iosStylePicker: true,
                value: initialTine,
                onChange: (res) {
                  if (res.minute != initialTine.minute) {
                    notif("Failed", "The time duration should be in hours");
                    return;
                  }
                  setState(() {
                    Time resultTime;
                    resultTime = Time(hour: res.hour, minute: res.minute);
                    var totalIntitial =
                        (initialTine.hour * 60) + initialTine.minute;
                    var totalResult =
                        (resultTime.hour * 60) + resultTime.minute;
                    int maxMinutes = maxDuration * 60;
                    int minMinutes = minDuration * 60;
                    // logger.e(totalResult - totalIntitial);
                    if (totalResult == totalIntitial) {
                      resultToTime = '';
                      durationController.text = '';
                      notif('Failed',
                          'There could be a difference between from time and to time');
                      setState(() {});
                    } else if ((totalResult - totalIntitial).abs() >
                        maxMinutes) {
                      resultToTime = '';
                      durationController.text = '';
                      notif('Failed',
                          'The maximum duration of permission is ${(maxMinutes / 60).toStringAsFixed(0)} hours');
                    } else if ((totalResult - totalIntitial).abs() <
                        minMinutes) {
                      resultToTime = '';
                      durationController.text = '';
                      notif('Failed',
                          'The minimum duration of permission is ${(minMinutes / 60).toStringAsFixed(0)} hours');
                    } else {
                      resultToTime = resultTime.format(context);
                      // String totalHour = ((initialTine.hour * 60) + (resultTime.hour * 60) / 60).toStringAsFixed(0);
                      // String totalMins = ((initialTine.minute) - (resultTime.minute)).abs().toStringAsFixed(0);
                      // duration =
                      //     "${totalHour.length == 1 ? "0$totalHour" : totalHour}:${totalMins.length == 1 ? "0$totalMins" : totalMins}";
                      // durationController.text = duration!;
                      duration = durationFromTimeOfDay(initialTine, resultTime);
                      durationController.text = duration!;
                    }
                  });
                },
              ));
        },
      ),
      const SizedBox(height: 12),
      customTextField(durationController, 'Duration', 'Permission Duration', 45,
          1, TextInputType.name,
          isReadOnly: true),
    ]);
  }

  String durationFromTimeOfDay(TimeOfDay? start, TimeOfDay? end) {
    if (start == null || end == null) return '';

    // DateTime(year, month, day, hour, minute)
    final startDT = DateTime(9, 9, 9, start.hour, start.minute);
    final endDT = DateTime(9, 9, 10, end.hour, end.minute);

    final range = DateTimeRange(start: startDT, end: endDT);
    final hours = range.duration.inHours % 24;
    final minutes = range.duration.inMinutes % 60;

    final onlyHours = minutes == 0;
    final onlyMinutes = hours == 0;
    final hourText = onlyMinutes
        ? '00'
        : '$hours'.length == 1
            ? '0$hours'
            : '$hours';
    final minutesText = onlyHours
        ? '00'
        : '$minutes'.length == 1
            ? '0$minutes'
            : '$minutes';
    return "$hourText:$minutesText";
  }

  var resultingDuration;
  Time initialTine = Time(hour: 0, minute: 0);
  Widget picker(String label, String value, VoidCallback function) {
    return InkWell(
      onTap: function,
      child: Container(
          alignment: Alignment.centerLeft,
          width: double.maxFinite,
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: targetDetailColor.brand),
              borderRadius: BorderRadius.circular(8)),
          child: Text('$label : $value', style: styleForm)),
    );
  }

  apiCall() {
    var format = DateFormat("HH:mm:ss");
    // logger.i(provdPermission.permissionInfo);

    FocusScope.of(context).unfocus();
    if (date == null) {
      return notif('Failed', 'Kindly select the permission date');
    }

    if (resultFromTime == null) {
      return notif('Failed', 'Kindly select the from time of the permission');
    }
    if (resultToTime == null) {
      return notif('Failed', 'Kindly select the to time of the permission');
    }

    // if (targetDetail.functions.any((element) => element == 21)) {
    if (provdPermission.permissionInfo["balance_hour"] == "00:00:00") {
      return notif("Failed",
          "There is 0 hour left in your balance time to apply for permission");
    }

    if (format
        .parse(provdPermission.permissionInfo["balance_hour"])
        .difference(format.parse("$duration:00"))
        .isNegative) {
      return notif("Failed",
          "There is only ${provdPermission.permissionInfo["balance_hour"]} left in your balance time to apply for permission");
    }

    if (provdPermission.permissionInfo["balance_count"] < 1) {
      return notif("Failed",
          "You requested that all permissions be completed this month");
    }
    // } else {

    // }
    var params = {
      'employee_id': Provider.of<AuthProvider>(context, listen: false)
          .userData['employee_id']
          .toString(),
      'permission_date': '$date',
      'purpose': purposeController.text
    };

    if (purposeController.text.isEmpty) {
      return notif('Failed', 'Kindly enter the purpose of the permission');
    }

    params.addAll({'permission_duration': '$duration'});
    if (resultFromTime != null && resultToTime != null) {
      params
          .addAll({'from_time': '$resultFromTime', 'to_time': '$resultToTime'});
    }
    logger.d(params);
    Provider.of<PermissionProvider>(context, listen: false)
        .askPermission(context, params)
        .then((value) {
      if (value) {
        // logger.e(params);
        setState(() {
          date = null;
          duration = null;
          purposeController.clear();
          resultFromTime = null;
          resultToTime = null;
          durationController.clear();
        });
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    purposeController.dispose();
    durationController.dispose();
    super.dispose();
  }
}

Widget heading(String title) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
    );
