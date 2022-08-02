import 'package:dinar_ex/pages/settings/settings_controller.dart';
import 'package:get/get.dart';
import "package:flutter/material.dart";

class Settigns extends StatelessWidget {
  //
  SettignsController controller =
      Get.put(SettignsController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          const Text(
            " Settings",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          const Text(
            ' Dark mode',
            style: TextStyle(fontSize: 15),
          ),
          const Divider(
            thickness: 2,
          ),
          Obx(() => Switch(
              value: controller.isDarkMode.value,
              onChanged: (val) {
                controller.changeAppTheme();
              })),
          const SizedBox(
            height: 50,
          ),
          const Text(' General', style: TextStyle(fontSize: 15)),
          const Divider(
            thickness: 2,
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.emoji_emotions)),
              const Text(
                'Rate us',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
          Row(children: [
            IconButton(
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationIcon: const FlutterLogo(),
                    applicationName: 'Exchange Rate',
                    applicationVersion: '0.0.1',
                    applicationLegalese: '©2022 Lyes Tarzalt',
                    children: <Widget>[
                      const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text('to add'))
                    ],
                  );
                },
                icon: const Icon(
                  Icons.info,
                )),
            const Text(
              'About us',
              style: TextStyle(fontSize: 15),
            ),
          ])
        ],
      ),
    );
  }
}
