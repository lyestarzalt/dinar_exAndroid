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
    }, time: Duration(seconds: 1));
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Text("Convert"),
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
                  print('Button tapped');
                },
                child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.compare_arrows_outlined))),
          ],
        ),
        Obx(
          () => Card(
            color: Colors.white,
            elevation: 50,
            child: Container(
              height: 120,
              width: 400,
              //check if the value of the input text is not an empty string
              //to avoid invalid double when the user removes values

              child: Text(
                (double.parse(controller.controllerText.value.isNotEmpty
                            ? controller.controllerText.value
                            : "0") *
                        widget.buyPrice)
                    .toString(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
