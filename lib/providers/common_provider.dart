import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in4_solution/constants/keys.dart';
import 'package:in4_solution/providers/all_providers.dart';

import '/../services/api_services.dart';

class CommonProvider extends ChangeNotifier {
  bool loadingCommon = false;
  List sideBarList = [];

  setCommonLoadingOn() {
    loadingCommon = true;
    notifyListeners();
  }

  setCommonLoadingOff() {
    loadingCommon = false;
    notifyListeners();
  }

  Future getSideBarList() async {
    setCommonLoadingOn();
    Map<String, String> params = {'user_id': provdAuth.userData['user_id'].toString()};
    dynamic response = await ApiService().get(Get.context!, 'role/list', params: params);
    setCommonLoadingOff();
    logger.w("sidebar response : $response");
    if (response['status']) {
      sideBarList = response['data'] ?? [];
      // if (sideBarList.isNotEmpty) {
      //   List temp = [];
      //   for (var data in sideBarList) {
      //     temp.add(data['id']);
      //   }
      //   this.sideBarList = temp;
      // }
      notifyListeners();
    }
  }

  void clearData() {
    sideBarList = [];
    notifyListeners();
  }
}
