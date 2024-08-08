
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/controllers/homecontroller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Widget'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 400,
            child: FortuneWheel(
            animateFirst: false,
            curve: Curves.decelerate,
            rotationCount: 0,
            selected: controller.spinWheelController.stream,
            physics: CircularPanPhysics(
              duration: const Duration(seconds: 1),
              curve: Curves.decelerate,
            ),
            // onFling: () {
            //   controller.spinWheelController.add(1);
            // },
            // onFocusItemChanged: (value) {
            //   print(value);
            //   // set the value to the controller
            //   controller.spinWheelController.add(value+1);
            // },

            indicators: const [
              FortuneIndicator(
                alignment: Alignment.topCenter,
                // child: Icon(Icons.arrow_drop_down, size: 40,),
                child: TriangleIndicator(
                  color: Colors.green,
                ),
              ),
              FortuneIndicator(
                alignment: Alignment.bottomCenter,
                // child: Icon(Icons.arrow_drop_down, size: 40,),
                child: TriangleIndicator(
                  color: Colors.black,
                ),
              ),
            ],
            items: [
              for (var i = 0; i < 8; i++)
                FortuneItem(
                  child: RotatedBox(quarterTurns: 1,
                   child: Text('${i+1}'),),
                  style: const FortuneItemStyle(
                    color: Colors.white,
                    borderColor: Colors.black,
                    borderWidth: 2,
                    textStyle: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // rotate the wheel 1 step clockwise
              ElevatedButton(
                onPressed: () {
                  // current value
                  StreamSubscription<int> subscription = controller.spinWheelController.stream.listen((event) {
                    int value = event;
                    controller.spinWheelController.add(value+1);
                  });
                },
                child: const Text('Left'),
              ),

              // rotate the wheel 1 step counter-clockwise
              ElevatedButton(
                onPressed: controller.spinRight,
                child: const Text('Right'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}