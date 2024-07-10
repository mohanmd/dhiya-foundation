import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in4_solution/constants/keys.dart';
import 'package:provider/provider.dart';

import '/../providers/auth_provider.dart';
import '../constants/notifications.dart';

class ApiHelper {
  helper(BuildContext context, final response) {
    logger.e(response.body);
    logger.e(response.statusCode);

    final message = response.body.isEmpty ? '' : jsonDecode(response.body);
    // logger.e(message);
    try {
      if (response.statusCode == 200) {
        return message;
      }
      if (response.statusCode == 201) {
        return message;
      }
      if (response.statusCode == 202) {
        return message;
      }
      if (response.statusCode == 400) {
        // return notif(message['head'], message['message']);
      }
      if (response.statusCode == 401 || response.statusCode == 403) {
        // notif('data', message['error']);
        return Provider.of<AuthProvider>(context, listen: false).clearData(context);
      }
    } on SocketException {
      notif("ERROR!", 'Socket Exception');
      return;
    } on HttpException {
      notif("ERROR!", 'HTTP Exception');
      return;
    } on FormatException {
      notif("ERROR!", 'Format Exception');
      return;
    }
  }
}
