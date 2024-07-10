import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/screens/auth_screens/splash_screen.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'constants/keys.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
      (_) =>
          runApp(MultiProvider(providers: providersAll, child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppUpdateInfo? _updateInfo;
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((e) {
          return AppUpdateResult.inAppUpdateFailed;
        });
      }
    }).catchError((e) {});
  }

  @override
  void initState() {
    checkForUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: GetMaterialApp(
          key: materialKey,
          scaffoldMessengerKey: snackbarKey,
          title: targetDetail.appname,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch}),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'inter',
              useMaterial3: true,
              primarySwatch: Colors.blue,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              textTheme:
                  Theme.of(context).textTheme.apply(fontFamily: 'poppins')),
          home: const SplashScreen()),
    );
  }
}
