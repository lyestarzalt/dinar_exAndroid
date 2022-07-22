import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _SalesData {
  _SalesData(this.day, this.price);

  final String day;
  final double price;
}

class _ChartState extends State<Chart> {
  List<_SalesData> data = [];
  List<String> currecies = [];

  var templist = [];
  String dropdownvalue = 'chf';

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
    return Container(
        child: Column(children: [
      //Initialize the chart widget
      FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('exchange-daily').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var logger = Logger();

            var value = snapshot.data!.docs;

            for (var document in value) {
              Map<String, dynamic> oneDay =
                  document.data() as Map<String, dynamic>;
              //logger.i(lol['anis'][1]['cad']);
              Map<String, dynamic> codeCurrency =
                  oneDay['anis'][0] as Map<String, dynamic>;
              codeCurrency[0];
              templist.add(codeCurrency.keys.toList());

              DateTime parsedDate = DateTime.parse(document.id);
              data.add(_SalesData(parsedDate.day.toString(),
                  oneDay['anis'][0][dropdownvalue].toDouble()));
            }
            currecies = templist[0];
            logger.wtf(currecies);
            return Column(
              children: [
                SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: 'price analysis'),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_SalesData, String>>[
                    LineSeries<_SalesData, String>(
                        dataSource: data,
                        xValueMapper: (_SalesData price, _) => price.day,
                        yValueMapper: (_SalesData price, _) => price.price,
                        name: 'price',

                        // Enable data label

                        dataLabelSettings: DataLabelSettings(isVisible: true))
                  ],
                ),
                DropdownButton(
                  // Initial Value
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: currecies.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      data.clear();

                      dropdownvalue = newValue!;
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
    ]));
  }
}
