import 'app_config.dart';
import 'color_config.dart';

const AppTarget appTarget = AppTarget.in4;
final targetDetail = AppConfig(target: appTarget);
final targetDetailColor = ColorConfig(target: appTarget);

enum AppTarget {
  in4,

  local
}
