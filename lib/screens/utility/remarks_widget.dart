import 'package:flutter/material.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/text_field.dart';

class RemarksDialog extends StatelessWidget {
  final Function(String) onSubmit;

  RemarksDialog({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    TextEditingController remarksController = TextEditingController();

    return AlertDialog(
      title: const Text('Add Remarks'),
      content: textField(
        remarksController,
        "Remarks",
        TextInputType.text,
        validator: (value) {
          print(value);
          if (value == null || value.isEmpty) {
            return "Remarks field is required";
          }
          return null;
        },
      ),
      actions: [
        buttonPrimary(MediaQuery.of(context).size.width, 0, "Submit", () {
          String remarks = remarksController.text.trim();
          onSubmit(remarks);
        })
      ],
    );
  }
}
