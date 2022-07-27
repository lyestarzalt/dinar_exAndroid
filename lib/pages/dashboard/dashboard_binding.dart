import 'package:get/get.dart';

import 'dashboard_controller.dart';
import 'package:dinar_ex/pages/trends/trend_controller.dart';
import 'package:dinar_ex/pages/currencies/currencies_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<CurrenciesController>(() => CurrenciesController());
    Get.lazyPut<TrendsController>(() => TrendsController());
  }
}
