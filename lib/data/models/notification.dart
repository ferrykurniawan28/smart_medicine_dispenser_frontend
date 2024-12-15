class NotificationHistory {
  final int id;
  final int? medicineReminderId;
  final String message;
  final DateTime sentAt;

  NotificationHistory({
    required this.id,
    this.medicineReminderId,
    required this.message,
    required this.sentAt,
  });
  factory NotificationHistory.fromJson(Map<String, dynamic> json) =>
      NotificationHistory(
        id: json["id"],
        medicineReminderId: json["medicineReminderId"],
        message: json["message"],
        sentAt: DateTime.parse(json["sentAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "medicineReminderId": medicineReminderId,
        "message": message,
        "sentAt": sentAt.toIso8601String(),
      };
}
