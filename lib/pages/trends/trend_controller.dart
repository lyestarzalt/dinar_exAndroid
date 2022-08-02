import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrendsController extends GetxController {
  Future fetchTrends() async {

  var allRecords =
       await FirebaseFirestore.instance.collection('exchange-daily').get();
  var allRecordsList = allRecords.docs;



  }


}
