import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'datum.dart';
import 'package:logger/logger.dart';

Future<dynamic> loadStockData() async {
  var logger = Logger();

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('exchange-daily').get();
  List<dynamic> testing = querySnapshot.docs;
  final List<dynamic> finalList = [];

  for (var element in testing) {
    logger.wtf(element);
    // anisoo.add(element.reference.id);
    Map<String, dynamic> prices = element.data();
    finalList
        .add({"date": element.reference.id, 'close': prices['anis'][0]['chf']});
  }

  List anis = finalList.map((json) => ValueDinar.fromfirebase(json)).toList();
  return anis;
}
