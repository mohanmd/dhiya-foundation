import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:provider/provider.dart';

import '/../constants/contexts.dart';
import '/../constants/loaders.dart';
import '/../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loading = false;
  final EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // appTarget.name == "local"
      //     ? Navigator.of(context).pushAndRemoveUntil(
      //         MaterialPageRoute(
      //             builder: (BuildContext context) =>
      //                 const LocalSelectIPAddress()),
      //         (route) => false)
      //     :
      Future.delayed(const Duration(seconds: 1)).then((value) {
        setState(() => loading = true);
        Provider.of<AuthProvider>(context, listen: false).checkSplashScreen(context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: context.heightFull(),
      width: context.widthFull(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/${targetDetail.appname}.png", width: context.widthHalf(), fit: BoxFit.cover),
          const SizedBox(height: 32),
          loading ? loader35() : const SizedBox(height: 35)
        ],
      ),
    ));
  }
}
