import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'currencies_list.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: MyHomePage(
          title: 'Flutter Demo Home Page',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('exchange-daily');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        // inside the <> you enter the type of your stream
        stream: FirebaseFirestore.instance
            .collection('exchange-daily')
            .doc('2022-07-07')
            .collection('prices')
            .doc('buy')
            .snapshots()
            .map((snapshot) => snapshot),

        builder: (context, snapshot) {
          var usdBuy = snapshot.data!.data()!.entries;

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.data()!.keys.toList().length,
              itemBuilder: (context, index) {
                // get the code for each counrty to set the image icon
                String icons =
                    snapshot.data!.data()!.keys.toList()[index].toString();
                String currency_code =
                    snapshot.data!.data()!.keys.toList()[index].toString();
                double buy_prices =
                    snapshot.data!.data()!.values.toList()[index];

                //our main list
                return Card(
                  elevation: 50,
                  child: ListTile(
                      leading: Image.asset(
                        'icons/currency/${icons}.png',
                        package: 'currency_icons',
                      ),
                      title: Text(
                        currency_code,
                      ),
                      trailing: Text(buy_prices.toString())),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return const Text('Error');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
