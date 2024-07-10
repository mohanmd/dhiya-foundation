import 'package:flutter/material.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:in4_solution/config/enums.dart';
import 'package:in4_solution/constants/keys.dart';
import 'package:in4_solution/providers/auth_provider.dart';
import 'package:provider/provider.dart';

// ignore: depend_on_referenced_packages
import 'api_helper.dart';

class ApiService {
  Map<String, String> headers = {};
  bool tokenUpdating = false;
  int timeoutDuration = 20;

  setHeaders(BuildContext context) async {
    String token =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    headers.addAll(
        {"Authorization": "Bearer $token", "Accept": "application/json"});
  }

  // post call
  Future post(BuildContext context, String url, {params}) async {
    await setHeaders(context);

    var response = await InterceptedHttp.build(interceptors: []).post(
        Uri.parse("${targetDetail.url}$url"),
        body: params,
        headers: headers);
    // ignore: use_build_context_synchronously
    return ApiHelper().helper(context, response);
  }

  //get call
  Future get(BuildContext context, String url, {params}) async {
    await setHeaders(context);
    logger.e("${targetDetail.url}$url" '\n$params');
    var response = await InterceptedHttp.build(interceptors: []).get(
        Uri.parse("${targetDetail.url}$url"),
        params: params,
        headers: headers);
    // ignore: use_build_context_synchronously
    return ApiHelper().helper(context, response);
  }

  //update call
  Future put(BuildContext context, String url, {params}) async {
    await setHeaders(context);
    var response = await InterceptedHttp.build(interceptors: []).put(
        Uri.parse("${targetDetail.url}$url"),
        params: params,
        headers: headers);
    // ignore: use_build_context_synchronously
    return ApiHelper().helper(context, response);
  }

  //delete call
  Future delete(BuildContext context, String url, {params}) async {
    await setHeaders(context);
    var response = await InterceptedHttp.build(interceptors: []).delete(
        Uri.parse("${targetDetail.url}$url"),
        params: params,
        headers: headers);
    // ignore: use_build_context_synchronously
    return ApiHelper().helper(context, response);
  }
}
