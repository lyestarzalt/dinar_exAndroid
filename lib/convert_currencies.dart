import "package:flutter/material.dart";

class Convert extends StatefulWidget {
  var sell_price = '';
  var buy_price = '';
  var currency = '';

  Convert({Key? key, required this.sell_price, required this.buy_price, required this.currency})
      : super(key: key);

  @override
  State<Convert> createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Card(
        elevation: 50,
        child: Column(
          children: <Widget>[
            Text("Convert"),
            Row(
              children: <Widget>[
                Text("Sell"),
                Text(widget.buy_price.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
