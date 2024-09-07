class DeviceContent {
  int id;
  int deviceId;
  int currentState;
  List<Container> containers;

  DeviceContent({
    required this.id,
    required this.deviceId,
    required this.currentState,
    required this.containers,
  });

  // Factory constructor to create an instance from JSON
  factory DeviceContent.fromJson(Map<String, dynamic> json) {
    var containerList = json['containers'] as Map<String, dynamic>;
    List<Container> containers = containerList.entries.map((entry) {
      return Container.fromJson(entry.value);
    }).toList();

    return DeviceContent(
      id: json['id'],
      deviceId: json['device_id'],
      currentState: json['current_state'],
      containers: containers,
    );
  }

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'current_state': currentState,
      'containers': {
        for (var container in containers) container.name: container.toJson()
      },
    };
  }
}

class Container {
  String name;
  int total;

  Container({
    required this.name,
    required this.total,
  });

  // Factory constructor to create an instance from JSON
  factory Container.fromJson(Map<String, dynamic> json) {
    return Container(
      name: json['name'],
      total: json['total'],
    );
  }

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'total': total,
    };
  }
}
