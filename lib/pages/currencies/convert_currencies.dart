import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'currencies_controller.dart';


// ignore: must_be_immutable
class Convert extends StatefulWidget {
  double buyPrice = 0.0;
  double sellPrice = 0.0;
  String currency = "";

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
  final double widgetATop = 25;
  final double widgetBTop = 115;
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
  CurrenciesController controller = Get.put(CurrenciesController());

  RxBool todinar = true.obs;
  NumberFormat f = NumberFormat("#,###,###.########", "en_US");

  // func to convert from and to algerian dinar deprending on a state
  String convertedValue(istrue, sell, buy) {
    String input = controller.controllerText.value;
    if (istrue) {
      return f.format(double.parse(input.isNotEmpty ? input : "0") * buy);
    } else {
      return f.format(double.parse(input.isNotEmpty ? input : "0") / sell);
    }
  }

  @override
  Widget build(BuildContext context) {
    double tweenValue = addressAnimation.value;

    return Stack(children: [
      Positioned(
        top: widgetATop + tweenValue,
        child: Card(
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.blueGrey, //<-- SEE HERE
            ),
          ),
          color: Colors.white,
          elevation: 50,
          child: SizedBox(
            height: 50,
            width: 280,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    child: Container(
                      color: Colors.blueGrey,
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 15,
                            child: Image.asset(
                              'icons/currency/${widget.currency.toLowerCase()}.png',
                              package: 'currency_icons',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.currency.toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        )
                      ]),
                    ),
                  ),
                  Flexible(
                    child: todinar.value
                        ? TextFormField(
                            inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    (RegExp('[0-9.]')))
                              ],
                            keyboardType: TextInputType.number,
                            controller: controller.txtList,
                            decoration: const InputDecoration(
                              hintText: 'Enter amount',
                              border: InputBorder.none,
                            ),
                            textAlign: TextAlign.right,
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black))
                        : Obx(
                            () => SelectableText(
                                convertedValue(todinar.value, widget.sellPrice,
                                    widget.buyPrice),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black)),
                          ),
                  ),
                ]),
          ),
        ),
      ),
      Positioned(
        right: 50,
        top: 85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
                onTap: () {
                  //from stackoverflow
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
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.blueGrey, //<-- SEE HERE
            ),
          ),
          child: SizedBox(
              height: 50,
              width: 280,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    child: Container(
                      color: Colors.blueGrey,
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 15,
                            child: Image.asset(
                              'icons/currency/dzd.png',
                              package: 'currency_icons',
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'DZD',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        )
                      ]),
                    ),
                  ),
                  todinar.isTrue
                      ? Flexible(
                          child: Obx(
                            () => SelectableText(
                                convertedValue(todinar.value, widget.sellPrice,
                                    widget.buyPrice),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black)),
                          ),
                        )
                      : Flexible(
                          child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    (RegExp('[0-9.]')))
                              ],
                              keyboardType: TextInputType.number,
                              controller: controller.txtList,
                              decoration: const InputDecoration(
                                hintText: 'Enter amount',
                                border: InputBorder.none,
                              ),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black)),
                        ),
                ],
              )),
        ),
      ),
      Positioned(
          bottom: 5,
          right: 10,
          left: 10,
          child: Center(
            child: Card(
                child: AnimatedSwitcher(
              reverseDuration: const Duration(seconds: 1),
              duration: const Duration(seconds: 3),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              child: todinar.isTrue
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          '1 ${widget.currency.toUpperCase()} = ${1 * widget.buyPrice} DZD',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '1 DZD  = ${f.format(1 / widget.buyPrice)} ${widget.currency.toUpperCase()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold), // give any color here
                      ),
                    ),
            )),
          ))
    ]);
  }
}
