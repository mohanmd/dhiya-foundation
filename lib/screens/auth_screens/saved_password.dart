import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/buttons.dart';
import 'package:in4_solution/constants/contexts.dart';
import 'package:in4_solution/constants/fonts.dart';
import 'package:in4_solution/constants/loaders.dart';
import 'package:in4_solution/providers/all_providers.dart';
import 'package:in4_solution/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SavedPasswordScreen extends StatelessWidget {
  const SavedPasswordScreen(
      {super.key, required this.creds, required this.onTap});
  final VoidCallback onTap;
  final Map creds;
  @override
  Widget build(BuildContext context) {
    String pass = '';
    for (var i = 0; i < creds['password'].toString().length; i++) {
      pass += '*';
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: const EdgeInsets.all(16),
            // height: context.heightHalf(),
            child: Column(children: [
              Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                      color: targetDetailColor.brand.withOpacity(.4),
                      borderRadius: BorderRadius.circular(12))),
              const SizedBox(height: 12),
              Icon(Icons.key, color: targetDetailColor.brand, size: 34),
              const SizedBox(height: 8),
              textCustom('Use saved password?', size: 18),
              const SizedBox(height: 12),
              textCustom("You'll login in to ${targetDetail.appname}",
                  size: 12, weight: FontWeight.w500),
              const SizedBox(height: 24),
              InkWell(
                onTap: onTap,
                child: Row(children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: targetDetailColor.brand.withOpacity(.4),
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textCustom(creds['user_name'] ?? '',
                                color: Colors.white),
                            const SizedBox(height: 4),
                            textCustom(pass, color: Colors.white),
                          ]),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 24),
              Consumer<AuthProvider>(
                  builder: (context, value, child) => value.authLoading
                      ? loader35()
                      : buttonPrimary(
                          context.widthFull(), 0, 'Log in', () => login())),
              const SizedBox(height: 12),
            ])),
      ],
    );
  }

  void login() {
    provdAuth.login(Get.context!, creds['user_name'], creds['password'], true);
  }
}
