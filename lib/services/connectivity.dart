import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    // `checkConnectivity` returns a single `ConnectivityResult`, not a list
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result); // Pass the single result

    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result); // Each change provides a single result
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final lookupResult = await InternetAddress.lookup('example.com');
      isOnline = lookupResult.isNotEmpty && lookupResult[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline}); // Send status as a map
  }

  void disposeStream() => _controller.close();
}
