import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/fonts.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerAttendance extends StatefulWidget {
  const ShimmerAttendance({super.key});
  @override
  State<ShimmerAttendance> createState() => _ShimmerAttendanceState();
}

class _ShimmerAttendanceState extends State<ShimmerAttendance> {
  List week = ["Sun", "Mon", 'Tue', "Wed", "Thu", "Fri", "Sat"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          itemCount: 35 + week.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 4, crossAxisSpacing: 8, crossAxisCount: 7),
          itemBuilder: (context, index) {
            if (index < 7) {
              return Center(
                  child: textCustom(week[index],
                      color: targetDetailColor.primaryDark));
            } else {
              return shimmerSquare(40, borderRadius: 4);
            }
          },
        ),
      ],
    );
  }
}

Widget shimmerSquare(double height,
    {double width = 0, double borderRadius = 12}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey.shade200,
            // highlightColor: const Color.fromARGB(255, 236, 234, 234),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: height,
              width: width != 0 ? width : null,
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(borderRadius)),
            )),
      ),
    ],
  );
}
