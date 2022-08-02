import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'line_chart.dart';
import 'datum.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  var dropdownvalue = 'gbp';
  var collection =
      FirebaseFirestore.instance.collection('exchange-daily').get();

  // List of items in our dropdown menu
  List<String> itemss = [];
  var _collection;
  @override
  void initState() {
    _collection = collection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //Initialize the chart widget
      FutureBuilder<QuerySnapshot>(
        future: _collection,
        builder: (BuildContext context, snapshot) {
          print('trend page rebuild');

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Object?>> value = snapshot.data!.docs;
            print('trends list rebuild2');

            final List<dynamic> tempList = [];
            final List<List<String>> currencyCode = [];
            Map<dynamic, dynamic> test =
                value.last.data() as Map<dynamic, dynamic>;
            Map<String, dynamic> lol = test['anis'][0];
            itemss = lol.keys.toList();
            print(itemss);
            for (var document in value) {
              Map<String, dynamic> prices =
                  document.data() as Map<String, dynamic>;
              tempList.add({
                "date": document.id,
                'price': prices['anis'][0][dropdownvalue]
              });
              List<String> code = prices['anis'][0].keys.toList();

              currencyCode.add(code);

              // currencyCode.add(prices['anis'][0].keys);
            }
            List<ValueDinar> anis =
                tempList.map((json) => ValueDinar.fromfirebase(json)).toList();

            return Column(
              children: [
                StockChartExample(data: anis),
                DropdownButton(
                  // Initial Value
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: itemss.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              'icons/currency/$item.png',
                              package: 'currency_icons',
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                      _collection = FirebaseFirestore.instance
                          .collection('exchange-daily')
                          .get();
                    });
                  },
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    ]);
  }
}
