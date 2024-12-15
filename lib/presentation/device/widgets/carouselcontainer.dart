import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smart_dispencer/presentation/device/controllers/devicecontroller.dart';
import 'package:smart_dispencer/presentation/device/widgets/containercard.dart';

class CarouselContainer extends StatelessWidget {
  const CarouselContainer({
    super.key,
    required this.controller,
  });

  final Devicecontroller controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          CarouselSlider.builder(
            key: controller.carouselKey,
            carouselController: controller.carouselController,
            itemCount: controller.containers.length,
            itemBuilder: (context, index, realIndex) {
              return containerCard(
                onTap: () => controller.settingContainer(index),
                width: 300,
                id: index,
                medicine: controller.containers[index].medicine ?? '',
                quantity: controller.containers[index].quantity ?? 0,
              );
            },
            options: CarouselOptions(
              height: 150,
              aspectRatio: 16 / 9,
              viewportFraction: 0.4,
              initialPage: controller.currentValue.value,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                controller.updateCurrentIndex(index);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            // heightFactor: 3.5,
            child: Transform.translate(
              offset: const Offset(0, -22),
              child: const Icon(
                Icons.arrow_drop_up_sharp,
                size: 50,
                // color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            // heightFactor: 0,
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: const Icon(
                Icons.arrow_drop_down_sharp,
                size: 50,
                // color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
