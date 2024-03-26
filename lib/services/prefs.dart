import 'package:extensionresoft/extensionresoft.dart';

import '../utils/routes.dart';

/// Page
String get page => SharedPreferencesService.getString('page') ?? RouteConstants.home;

set page(String value) => SharedPreferencesService.setString('page', value);
