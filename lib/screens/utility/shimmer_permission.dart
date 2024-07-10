import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPermission extends StatefulWidget {
  const ShimmerPermission({Key? key}) : super(key: key);

  @override
  State<ShimmerPermission> createState() => _ShimmerPermissionState();
}

class _ShimmerPermissionState extends State<ShimmerPermission> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Shimmer.fromColors(
            baseColor: targetDetailColor.muted.withOpacity(0.45),
            highlightColor: targetDetailColor.brand.withOpacity(0.75),
            enabled: true,
            child: ListView.builder(
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 52.0,
                      height: 52.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 12.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: double.infinity,
                            height: 12.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: 40.0,
                            height: 12.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              itemCount: 15,
            ),
          ),
        ),
      ],
    );
  }
}
