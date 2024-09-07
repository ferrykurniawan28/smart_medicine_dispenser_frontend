class Devices {
  final String id;
  final String name;
  final String uid;
  int? userId;
  int? adminId;
  final String status;

  Devices({
    required this.id,
    required this.name,
    required this.uid,
    this.userId,
    this.adminId,
    required this.status,
  });

  factory Devices.fromJson(Map<String, dynamic> json) {
    return Devices(
      id: json['id'],
      name: json['name'],
      uid: json['uid'],
      userId: json['userId'],
      adminId: json['adminId'],
      status: json['status'],
    );
  }
}
