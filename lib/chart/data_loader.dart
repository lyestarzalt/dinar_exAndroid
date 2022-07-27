import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'datum.dart';

Future<dynamic> loadStockData() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('exchange-daily').get();
  List<dynamic> testing = querySnapshot.docs;
  final List<dynamic> finalList = [];

  for (var element in testing) {
    // anisoo.add(element.reference.id);
    Map<String, dynamic> prices = element.data();
    finalList
        .add({"date": element.reference.id, 'close': prices['anis'][0]['chf']});
  }


  List anis = finalList.map((json) => Value.fromfirebase(json)).toList();
  return anis;
}
