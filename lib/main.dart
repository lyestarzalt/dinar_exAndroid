import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'currencies_list.dart';
import 'package:get/get.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
   const MyHomePage(),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 
  var selectedIndex = 0.obs;

  void _onItemTapped(index) {
    selectedIndex.value = index;
  }

  static const List<Widget> _widgetOptions = <Widget>[
    CurrenciesList(),
    Text(
      'Index 2: School',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
          bottomNavigationBar: Obx(() => BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.attach_money_sharp),
                    label: 'List',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.trending_up_rounded),
                    label: 'chart',
                  ),
                ],
                currentIndex: selectedIndex.value,
                selectedItemColor: Colors.amber[800],
                onTap: (_onItemTapped),
              )),
          body: Obx(
            () => _widgetOptions.elementAt(selectedIndex.value),
            // This trailing comma makes auto-formatting nicer for build methods.
          )),
    );
  }
}
