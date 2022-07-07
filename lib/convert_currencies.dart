import "package:flutter/material.dart";

class Convert extends StatefulWidget {
  var buyPrice = 0.0;
  var sellPrice = 0.0;
  var currency = "";
  Convert(
      {Key? key,
      required this.buyPrice,
      required this.sellPrice,
      required this.currency})
      : super(key: key);

  @override
  State<Convert> createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Convert"),
        Row(
          children: <Widget>[
            Text("buy"),
            Text(widget.buyPrice.toString()),
            Text(widget.currency.toString()),
            Text(widget.sellPrice.toString())
          ],
        )
      ],
    );
  }
}
