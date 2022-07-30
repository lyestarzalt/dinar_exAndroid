import 'package:get/get.dart';
import "package:flutter/material.dart";

class CurrenciesController extends GetxController {
  RxBool isShow = false.obs;
  RxBool todinar = true.obs;

  final txtList = TextEditingController();

  RxString controllerText = '0.0'.obs;
  void flip() {
    todinar.toggle();
  }

  @override
  void onInit() {
    txtList.addListener(() {
      controllerText.value = txtList.text;
    });

    super.onInit();
  }
}
