import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';

Widget dropdownButtonCustom(var value, List list, String key, Function(Object?)? onChanged, {label}) {
  return LayoutBuilder(
    builder: (context, constraints) => Container(
        height: 45,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 1, color: targetDetailColor.brand)),
        child: DropdownButton(
            isExpanded: true,
            dropdownColor: Colors.white,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            iconEnabledColor: Colors.blue,
            underline: const SizedBox(),
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(label ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
            ),
            value: value,
            icon: const Icon(Icons.arrow_drop_down),
            items: list.map((items) {
              return DropdownMenuItem(
                  value: items,
                  child: SizedBox(
                    width: constraints.maxWidth - 36,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(items[key] ?? '',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: targetDetailColor.dark)),
                    ),
                  ));
            }).toList(),
            onChanged: onChanged)),
  );
}
