import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import '../../config/enums.dart';

class FromDatePickerAttendance extends StatefulWidget {
  const FromDatePickerAttendance({Key? key}) : super(key: key);

  @override
  State<FromDatePickerAttendance> createState() =>
      _FromDatePickerAttendanceState();
}

class _FromDatePickerAttendanceState extends State<FromDatePickerAttendance> {
  final List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now()
  ];

  var config = CalendarDatePicker2Config(
    selectedDayHighlightColor: targetDetailColor.brand,
    weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    weekdayLabelTextStyle: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    controlsHeight: 50,
    controlsTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    dayTextStyle: const TextStyle(
      color: Colors.black38,
      fontWeight: FontWeight.bold,
    ),
    disabledDayTextStyle: const TextStyle(
      color: Colors.grey,
    ),
  );

  String getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        var startDate = values[0].toString().replaceAll('00:00:00.000', '');
        var endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 28),
        CalendarDatePicker2(
          config: config,
          value: _singleDatePickerValueWithDefaultValue,
          onValueChanged: (values) => setState(() {
            // _singleDatePickerValueWithDefaultValue = values;
            // Provider.of<AttendanceProvider>(context, listen: false)
            //     .fromDatePick(getValueText(
            //   config.calendarType,
            //   _singleDatePickerValueWithDefaultValue,
            // ));
            // logger.wtf('From :${getValueText(
            //   config.calendarType,
            //   _singleDatePickerValueWithDefaultValue,
            // )}');
          }),
          // selectableDayPredicate: (day) => !day
          //     .difference(DateTime.now().subtract(const Duration(days: 3)))
          //     .isNegative,
        ),
      ],
    );
  }
}

class ToDatePickerAttendance extends StatefulWidget {
  const ToDatePickerAttendance({Key? key}) : super(key: key);

  @override
  State<ToDatePickerAttendance> createState() => _ToDatePickerAttendanceState();
}

class _ToDatePickerAttendanceState extends State<ToDatePickerAttendance> {
  final List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];

  var config = CalendarDatePicker2Config(
    selectedDayHighlightColor: targetDetailColor.brand,
    weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    weekdayLabelTextStyle: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    controlsHeight: 50,
    controlsTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    dayTextStyle: const TextStyle(
      color: Colors.black38,
      fontWeight: FontWeight.bold,
    ),
    disabledDayTextStyle: const TextStyle(
      color: Colors.grey,
    ),
  );

  String getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        var startDate = values[0].toString().replaceAll('00:00:00.000', '');
        var endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 28),
        CalendarDatePicker2(
          config: config,
          value: _singleDatePickerValueWithDefaultValue,
          onValueChanged: (values) => setState(() {
            // _singleDatePickerValueWithDefaultValue = values;
            // Provider.of<AttendanceProvider>(context, listen: false)
            //     .toDatePick(values);
            // logger.wtf('To :${getValueText(
            //   config.calendarType,
            //   _singleDatePickerValueWithDefaultValue,
            // )}');
          }),
          // selectableDayPredicate: (day) => !day
          //     .difference(DateTime.now().subtract(const Duration(days: 3)))
          //     .isNegative,
        ),
      ],
    );
  }
}
