import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrendsController extends GetxController {
  final productList = [].obs;
  QuerySnapshot<Map<String, dynamic>> anissss =
      {}.obs as QuerySnapshot<Map<String, dynamic>>;
  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {}

  var futurefire =
      FirebaseFirestore.instance.collection('exchange-daily').get().obs;

  void updateChart(var futurefire) {}

  var dropdownvalue = 'gbp'.obs;
  void setSelected(String value) async {
    dropdownvalue.value = value;
    var products =
        await FirebaseFirestore.instance.collection('exchange-daily').get();
    if (products != null) {
      anissss = products;
    }
  }
}
