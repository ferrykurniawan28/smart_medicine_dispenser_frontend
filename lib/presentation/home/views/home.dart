import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/home/controllers/homecontroller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Medicine Dispenser'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 400,
            child: FortuneWheel(
              animateFirst: false,
              curve: Curves.easeIn,
              rotationCount: 1,
              duration: const Duration(milliseconds: 200),
              selected: controller.spinWheelController.stream,
              physics: CircularPanPhysics(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeIn,
                allowOppositeRotationFlung: false,
              ),
              items: [
                for (var i = 0; i < 8; i++)
                  FortuneItem(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text('${i + 1}'),
                    ),
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // rotate the wheel 1 step clockwise
              ElevatedButton(
                onPressed: controller.spinLeft,
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Left',
                ),
              ),

              // rotate the wheel 1 step counter-clockwise
              ElevatedButton(
                onPressed: controller.spinRight,
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Right'),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reminders'),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Reminder $index'),
                  subtitle: Text('Time: 8:00 AM'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.delete),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
