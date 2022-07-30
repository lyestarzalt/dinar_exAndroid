import 'package:get/get.dart';
import 'package:dinar_ex/pages/dashboard/dashboard_binding.dart';
import 'package:dinar_ex/pages/dashboard/dashboard_page.dart';

import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
  ];
}
