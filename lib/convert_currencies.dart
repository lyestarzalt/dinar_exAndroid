import "package:flutter/material.dart";
import 'package:get/get.dart';

class Controller extends GetxController {
  final txtList = TextEditingController();

  RxString controllerText = '0.0'.obs;

  @override
  void onInit() {
    txtList.addListener(() {
      controllerText.value = txtList.text;
    });

    debounce(controllerText, (_) {
      print("debouce$_");
    }, time: Duration(microseconds: 10));
    super.onInit();
  }
}

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
  var controller = Get.put(Controller());
  var todinar = true.obs;

  String value(istrue, sell, buy) {
    if (istrue) {
      return (double.parse(controller.controllerText.value.isNotEmpty
                  ? controller.controllerText.value
                  : "0") *
              buy)
          .toStringAsFixed(2);
    } else {
      return (double.parse(controller.controllerText.value.isNotEmpty
                  ? controller.controllerText.value
                  : "0") /
              sell)
          .toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Obx(
              () => Text(todinar.value == true
                  ? "Convert from ${widget.currency} to Dinar"
                  : 'Convert from Dinar to ${widget.currency}'),
            )
          ],
        ),
        Card(
          color: Colors.white,
          elevation: 50,
          child: Container(
            height: 100,
            width: 400,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: controller.txtList,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: const Divider(
                thickness: 2,
                color: Colors.white,
                indent: 5,
                endIndent: 0,
              ),
            ),
            GestureDetector(
                onTap: () {
                  //from stackoverlow
                  //That is value xor-equals true, which will flip it every time,
                  //and without any branching or temporary variables.
                  todinar.value ^= true;

                  //or this
                  //todinar.value = !todinar.value;
                },
                child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.compare_arrows_outlined))),
          ],
        ),
        Card(
          color: Colors.white,
          elevation: 50,
          child: Container(
            height: 120,
            width: 400,
            //check if the value of the input text is not an empty string
            //to avoid invalid double when the user removes values

            child: Obx(
              () =>
                  Text(value(todinar.value, widget.sellPrice, widget.buyPrice)),
            ),
          ),
        )
      ],
    );
  }
}
