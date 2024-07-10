import 'enums.dart';

class AppConfig {
  final AppTarget target;
  late final String appname;
  late final String url;

  AppConfig({required this.target}) {
    switch (target) {
      case AppTarget.local:
        appname = "local";
        // url = "http://192.168.1.48:8074/in4solution/api/mobile/";
        // url = "http://192.168.4.24/in4solution/api/mobile/";
        url = "http://192.168.1.3/in4solution/api/mobile/";
        // url = "http://172.24.208.1/in4solution/api/mobile/";
        break;
      case AppTarget.in4:
        appname = "In4 Solution";
        url = "https://ipro-people.com/in4solution/api/mobile/";
        break;
    }
  }
}

// Potrait Only
// Show status based on the login in leave application
