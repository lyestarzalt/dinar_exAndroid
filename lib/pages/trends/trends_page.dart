import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'line_chart.dart';
import 'datum.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final List<charts.Series<dynamic, DateTime>> seriesList = [];

  List<String> currecies = [];
  RxList anis = [].obs;
  var templist = [];
  var dropdownvalue = 'gbp';
  var anisoo = FirebaseFirestore.instance.collection('exchange-daily').get();
  // List of items in our dropdown menu
  var items = [
    "chf",
    "aed",
    "mad",
    "eur",
    "gbp",
    "sar",
    "cad",
    "usd",
    "try",
    "tnd",
    "cny"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //Initialize the chart widget
      FutureBuilder<QuerySnapshot>(
        future: anisoo,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
            ;
          }

          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Object?>> value = snapshot.data!.docs;

            final List<dynamic> finalList = [];

            for (var document in value) {
              Map<String, dynamic> prices =
                  document.data() as Map<String, dynamic>;
              finalList.add({
                "date": document.id,
                'close': prices['anis'][0][dropdownvalue]
              });
            }
            List<ValueDinar> anis =
                finalList.map((json) => ValueDinar.fromfirebase(json)).toList();

            print(anis.first.price);
            return StockChartExample(data: anis);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),

      DropdownButton(
        // Initial Value
        value: dropdownvalue,

        // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),

        // Array list of items
        items: items.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) {
          setState(() {
            dropdownvalue = newValue!;
            anisoo =
                FirebaseFirestore.instance.collection('exchange-daily').get();
            printError();
          });
        },
      ),
    ]);
  }
}
