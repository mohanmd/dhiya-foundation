import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/fonts.dart';

class DropDown extends StatefulWidget {
  const DropDown(
      {super.key,
      required this.selectedValue,
      required this.givenList,
      required this.keyList,
      this.onChanged,
      required this.hint});
  final Map selectedValue;
  final List givenList;
  final String keyList;
  final Function(Object?)? onChanged;
  final String hint;

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: targetDetailColor.brand)),
        child: DropdownButton(
            isExpanded: true,
            dropdownColor: Colors.white,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            iconEnabledColor: Colors.blue,
            underline: const SizedBox(),
            hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(widget.hint,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey))),
            value: widget.selectedValue.isEmpty ? null : widget.selectedValue,
            items: widget.givenList.map((list) {
              return DropdownMenuItem(
                value: list,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: textSideHead(list[widget.keyList])),
              );
            }).toList(),
            onChanged: widget.onChanged),
      ),
      const SizedBox(height: 8),
    ]);
  }
}

class DatePickerCommon extends StatefulWidget {
  const DatePickerCommon({super.key, required this.fun, required this.text});
  final VoidCallback fun;
  final String text;

  @override
  State<DatePickerCommon> createState() => _DatePickerCommonState();
}

class _DatePickerCommonState extends State<DatePickerCommon> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
          onTap: widget.fun,
          child: Container(
              alignment: Alignment.centerLeft,
              width: double.maxFinite,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: targetDetailColor.brand),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(widget.text, style: styleForm))),
      const SizedBox(height: 8),
    ]);
  }
}

List leaveDuration = [
  {"id": "0.0", "name": "Full day"},
  {"id": "0.5", "name": "Half day"},
];



class CustomRadio extends StatelessWidget {
  const CustomRadio({super.key, required this.value});
  final bool value;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: value ? Colors.blue : Colors.black, width: 2)),
      child: const Icon(Icons.circle, color: Colors.blue, size: 12),
    );
  }
}
