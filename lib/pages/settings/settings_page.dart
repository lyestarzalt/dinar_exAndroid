import 'package:dinar_ex/pages/settings/settings_controller.dart';
import 'package:get/get.dart';
import "package:flutter/material.dart";

class Settigns extends StatelessWidget {
  //
  SettignsController controller =
      Get.put(SettignsController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    printError(info: "page");
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
          Text(
            ' Dark mode',
            style: TextStyle(fontSize: 15),
          ),
          Divider(
            thickness: 2,
          ),
          Obx(() => Switch(
              value: controller.isDarkMode.value,
              onChanged: (val) {
                controller.changeAppTheme();
                //print(val);
              })),
          SizedBox(
            height: 50,
          ),
          Text(' General', style: TextStyle(fontSize: 15)),
          Divider(
            thickness: 2,
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.emoji_emotions)),
              Text(
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
                icon: Icon(
                  Icons.info,
                )),
            Text(
              'About us',
              style: TextStyle(fontSize: 15),
            ),
          ])
        ],
      ),
    );
  }
}
