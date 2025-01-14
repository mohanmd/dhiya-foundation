import 'app_config.dart';
import 'color_config.dart';

const AppTarget appTarget = AppTarget.gse;
final targetDetail = AppConfig(target: appTarget);
final targetDetailColor = ColorConfig(target: appTarget);

enum AppTarget { in4, dhiyafoundation, local, gse }
