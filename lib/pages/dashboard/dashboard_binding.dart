import 'package:get/get.dart';

import 'dashboard_controller.dart';
import 'package:dinar_ex/pages/trends/trend_controller.dart';
import 'package:dinar_ex/pages/currencies/currencies_controller.dart';
import 'package:dinar_ex/theme/controller/theme_controller.dart';
import 'package:dinar_ex/pages/settings/settings_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(() => ThemeController());
    //Get.lazyPut<SettignsController>(() => SettignsController());

    Get.lazyPut<DashboardController>(() => DashboardController());
    /*  Get.lazyPut<CurrenciesController>(() => CurrenciesController());
    Get.lazyPut<TrendsController>(() => TrendsController()); */
  }
}
