import 'package:dinar_ex/pages/currencies/currencies_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dinar_ex/pages/trends/trends_page.dart';
import 'package:dinar_ex/pages/settings/settings_page.dart';

import 'dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Get.to(Settigns());
                },
              ),
            ],
          ),
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex.value,
              children: [CurrenciesList(), const Chart(), Settigns()],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              _bottomNavigationBarItem(
                icon: CupertinoIcons.money_dollar,
                label: 'Home',
              ),
              _bottomNavigationBarItem(
                icon: CupertinoIcons.chart_bar,
                label: 'News',
              ),
              _bottomNavigationBarItem(
                icon: CupertinoIcons.settings,
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }

  _bottomNavigationBarItem({required IconData icon, required String label}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
