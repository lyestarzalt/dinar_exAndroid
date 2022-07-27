import 'package:get/get.dart';
import "package:flutter/material.dart";

class CurrenciesController extends GetxController {

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
