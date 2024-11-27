import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/device/controllers/devicecontroller.dart';

class ListContainer extends StatelessWidget {
  const ListContainer({
    super.key,
    required this.controller,
  });

  final Devicecontroller controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Devicecontroller>(
      builder: (_) {
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _.containers.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () => controller.settingContainer(index),
                title: Text(
                  'Container ${_.containers[index].id + 1}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                    (_.containers[index].medicine.isNotEmpty)
                        ? controller.containers[index].medicine
                        : 'Empty',
                    style: const TextStyle(
                      color: Colors.black,
                    )),
                trailing: Text(
                  _.containers[index].quantity.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              );
            });
      },
    );
  }
}
