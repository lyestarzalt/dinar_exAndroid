import 'package:get/get.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrenciesController extends GetxController with StateMixin {
  var collection =
      FirebaseFirestore.instance.collection('exchange-daily').snapshots();

/*   void getdata() async {
    var lol = collection.value.get().then((value) {
      value.docs.forEach((element) {
        Map<String, dynamic> todayPrices = element as Map<String, dynamic>;

        print(todayPrices);
      });
    });
  } */

  var testing = [].obs;

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    var data = collection;

    return data;
  }

  //!/////////////////////////////////////////////////////

  RxBool isShow = false.obs;

  final txtList = TextEditingController();

  RxString controllerText = '0.0'.obs;
  @override
  void onInit() {
    txtList.addListener(() {
      controllerText.value = txtList.text;
    });

    super.onInit();
  }
}
