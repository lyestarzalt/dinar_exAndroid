import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:logger/logger.dart';

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
            for (var anis in value) {
              Map<String, dynamic> lol = anis.data() as Map<String, dynamic>;
              logger.i(lol['anis'][0]['chf']);
              String date = anis.id;
              var parsedDate = DateTime.parse(date);
              data.add(_SalesData(
                  parsedDate.day.toString(), lol['anis'][0]['chf'].toDouble()));
              logger.wtf(parsedDate);
            }

            return SfCartesianChart(
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
                ]);
          } else {
            return const Text('no data or erro');
          }
        },
      ),
    ]));
  }
}
