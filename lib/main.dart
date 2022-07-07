import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'convert_currencies.dart';
import 'package:get/get.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MyHomePage(),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var buy_price = 0.0.obs;
  var sellPrice = 0.0.obs;
  var currencyCode = "".obs;
  var isShow = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          // inside the <> you enter the type of your stream
          stream: FirebaseFirestore.instance
              .collection('exchange-daily')
              .doc('2022-07-07')
              .collection('prices')
              .snapshots()
              .map((snapshot) => snapshot),

          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(children: [
                ListView.builder(
                  itemCount: snapshot.data!.docs[0].data().length.obs(),
                  itemBuilder: (context, index) {
                    // get the code for each counrty to set the image icon
                    var icon1 = "".obs;
                    var currenecyCode1 = "".obs;
                    var buyPrices1 = 0.0.obs;
                    var sellPrices1 = 0.0.obs;

                    icon1.value =
                        snapshot.data!.docs[0].data().keys.toList()[index];

                    currenecyCode1.value =
                        snapshot.data!.docs[0].data().keys.toList()[index];

                    buyPrices1.value =
                        snapshot.data!.docs[0].data().values.toList()[index];

                    sellPrices1.value =
                        snapshot.data!.docs[1].data().values.toList()[index];

                    //our main list
                    return Card(
                      elevation: 50,
                      child: ListTile(
                          leading: Image.asset(
                            'icons/currency/${icon1.value}.png',
                            package: 'currency_icons',
                          ),
                          title: Text(
                            currenecyCode1.toString(),
                          ),
                          trailing: Text(buyPrices1.value.toString()),
                          onTap: () {
                            buy_price = buyPrices1;
                            sellPrice = sellPrices1;
                            currencyCode = currenecyCode1;

                            isShow.value = true;
                          }),
                    );
                  },
                ),
                Obx(
                  () => Visibility(
                    visible: isShow.value,
                    child: Align(
                      alignment: Alignment.center,
                      child: Card(
                        elevation: 100,
                        child: Container(
                          height: 300,
                          color: Color.fromARGB(83, 255, 7, 7),
                          child: Convert(
                            buyPrice: buy_price.value,
                            sellPrice: sellPrice.value,
                            currency: currencyCode.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ]);
            }
            if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
