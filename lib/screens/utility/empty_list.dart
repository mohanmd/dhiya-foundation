import 'package:flutter/material.dart';
import '/../constants/contexts.dart';
import '../../constants/fonts.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        width: context.widthFull(),
        height: context.heightQuarter(),
        child: Text("No Data Found", style: styleForm));
  }
}
