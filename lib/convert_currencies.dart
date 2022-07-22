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

class _ConvertState extends State<Convert> with TickerProviderStateMixin {
  final double widgetATop = 20;
  final double widgetBTop = 110;
  bool swapped = false;

  late AnimationController animateController;
  late Animation<double> addressAnimation;
  animationListener() => setState(() {});

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // Initialize animations
    animateController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    addressAnimation = Tween(
      begin: 0.0,
      end: widgetBTop - widgetATop,
    ).animate(CurvedAnimation(
      parent: animateController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ))
      ..addListener(animationListener);
  }

  @override
  dispose() {
    // Dispose of animation controller
    animateController.dispose();
    super.dispose();
  }

  //
  var controller = Get.put(Controller());
  var todinar = true.obs;

  // func to convert from and to algerian dinar deprending on a state
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
    var tweenValue = addressAnimation.value;

    return Stack(children: [
      Row(
        children: [
          Obx(
            () => Text(todinar.value == true
                ? "Convert from ${widget.currency} to Dinar"
                : 'Convert from Dinar to ${widget.currency}'),
          )
        ],
      ),
      Positioned(
        top: widgetATop + tweenValue,
        child: Card(
          color: Colors.white,
          elevation: 50,
          child: SizedBox(
            height: 50,
            width: 280,
            child: Row(children: [
              Image.asset(
                'icons/currency/${widget.currency.toLowerCase()}.png',
                package: 'currency_icons',
              ),
              Flexible(
                child: todinar == true
                    ? TextFormField(
                        keyboardType: TextInputType.number,
                        controller: controller.txtList,
                      )
                    : Obx(
                        () => Text(value(
                            todinar.value, widget.sellPrice, widget.buyPrice)),
                      ),
              ),
            ]),
          ),
        ),
      ),
      Positioned(
        right: 50,
        top: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
                onTap: () {
                  //from stackoverlow
                  //That is value xor-equals true, which will flip it every time,
                  //and without any branching or temporary variables.
                  //todinar.value ^= true;

                  //or this
                  todinar.value = !todinar.value;
                  setState(() {
                    swapped
                        ? animateController.reverse()
                        : animateController.forward();
                    swapped = !swapped;
                  });
                },
                child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.compare_arrows_outlined))),
          ],
        ),
      ),
      Positioned(
        top: widgetBTop - tweenValue,
        child: Card(
          color: Colors.white,
          elevation: 50,
          child: SizedBox(
              height: 50,
              width: 280,
              //check if the value of the input text is not an empty string
              //to avoid invalid double when the user removes values

              child: Row(
                children: [
                  Image.asset(
                    'icons/currency/dzd.png',
                    package: 'currency_icons',
                  ),
                  todinar == true
                      ? Obx(
                          () => Text(value(todinar.value, widget.sellPrice,
                              widget.buyPrice)),
                        )
                      : Flexible(
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: controller.txtList,
                              decoration: const InputDecoration(
                                hintText: 'Enter amount',
                                border: InputBorder.none,
                              ),
                              textAlign: TextAlign.right),
                        ),
                ],
              )),
        ),
      ),
    ]);
  }
}
