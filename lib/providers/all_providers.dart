import 'package:in4_solution/providers/attendance_provider.dart';
import 'package:in4_solution/providers/common_provider.dart';
import 'package:in4_solution/providers/employee_provider.dart';
import 'package:in4_solution/providers/leave_provider.dart';
import 'package:in4_solution/providers/location_internet.dart';
import 'package:in4_solution/providers/permission_provider.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import '../constants/keys.dart';
import 'auth_provider.dart';
import 'layout_provider.dart';

List<SingleChildWidget> providersAll = [
  ChangeNotifierProvider<CommonProvider>(create: (context) => CommonProvider()),
  ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
  ChangeNotifierProvider<LayoutProvider>(create: (context) => LayoutProvider()),
  ChangeNotifierProvider<LeaveProvider>(create: (context) => LeaveProvider()),
  ChangeNotifierProvider<AttendanceProvider>(create: (context) => AttendanceProvider()),
  ChangeNotifierProvider<LocationProvider>(create: (context) => LocationProvider()),
  ChangeNotifierProvider<PermissionProvider>(create: (context) => PermissionProvider()),
  ChangeNotifierProvider<CommonProvider>(create: (context) => CommonProvider()),
  ChangeNotifierProvider<EmployeeProvider>(create: (context) => EmployeeProvider()),
];

var provdLayout = Provider.of<LayoutProvider>(materialKey.currentContext!, listen: false);
var provdLeave = Provider.of<LeaveProvider>(materialKey.currentContext!, listen: false);
var provdLocation = Provider.of<LocationProvider>(materialKey.currentContext!, listen: false);
var provdAuth = Provider.of<AuthProvider>(materialKey.currentContext!, listen: false);
var provdPermission = Provider.of<PermissionProvider>(materialKey.currentContext!, listen: false);

var provdAttendance = Provider.of<AttendanceProvider>(materialKey.currentContext!, listen: false);
var provdCommon = Provider.of<CommonProvider>(materialKey.currentContext!, listen: false);
var provdEmployee = Provider.of<EmployeeProvider>(materialKey.currentContext!, listen: false);
