import 'dart:convert';

import 'package:sqflite/sqflite.dart';

const String tableReminder = 'medicineReminder';
const String medicineReminderId = 'id';
const String medicineReminderTime = 'medicineTime';
const String medicineReminderDosage = 'medicineDosage';
const String medicineReminderStartDate = 'medicineStartDate';
const String medicineReminderEndDate = 'medicineEndDate';

class MedicineReminder {
  int? id;
  String medicineTime;
  Map<String, int> medicineDosage;
  DateTime medicineStartDate;
  DateTime medicineEndDate;

  MedicineReminder({
    this.id,
    required this.medicineTime,
    required this.medicineDosage,
    required this.medicineStartDate,
    required this.medicineEndDate,
  });

  Map<String, Object?> toMap() {
    return {
      medicineReminderId: id,
      medicineReminderTime: medicineTime,
      medicineReminderDosage: jsonEncode(medicineDosage),
      medicineReminderStartDate: medicineStartDate.toIso8601String(),
      medicineReminderEndDate: medicineEndDate.toIso8601String(),
    };
  }

  factory MedicineReminder.fromMap(Map<String, Object?> map) {
    return MedicineReminder(
      id: map[medicineReminderId] as int?,
      medicineTime: map[medicineReminderTime] as String,
      medicineDosage:
          jsonDecode(map[medicineReminderDosage] as String) as Map<String, int>,
      medicineStartDate:
          DateTime.parse(map[medicineReminderStartDate] as String),
      medicineEndDate: DateTime.parse(map[medicineReminderEndDate] as String),
    );
  }

  factory MedicineReminder.fromJson(Map<String, dynamic> json) {
    return MedicineReminder(
      id: json['id'],
      medicineTime: json['medicineTime'],
      medicineDosage: json['medicineDosage'],
      medicineStartDate: json['medicineStartDate'],
      medicineEndDate: json['medicineEndDate'],
    );
  }
}

class ProviderMedicineReminder {
  late Database localdb;

  Future open(String path) async {
    localdb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          create table $tableReminder ( 
            $medicineReminderId integer primary key autoincrement, 
            $medicineReminderTime text not null,
            $medicineReminderDosage text not null,
            $medicineReminderStartDate text not null,
            $medicineReminderEndDate text not null)
          ''');
    });
  }

  Future<MedicineReminder> insert(MedicineReminder reminder) async {
    final id = await localdb.insert(tableReminder, reminder.toMap());
    return reminder..id = id;
  }

  Future<MedicineReminder> getReminder(int id) async {
    List<Map<String, Object?>> maps = await localdb.query(tableReminder,
        columns: [
          medicineReminderId,
          medicineReminderTime,
          medicineReminderDosage,
          medicineReminderStartDate,
          medicineReminderEndDate
        ],
        where: '$medicineReminderId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return MedicineReminder.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> delete(int id) async {
    return await localdb.delete(tableReminder,
        where: '$medicineReminderId = ?', whereArgs: [id]);
  }

  Future<int> update(MedicineReminder reminder) async {
    return await localdb.update(tableReminder, reminder.toMap(),
        where: '$medicineReminderId = ?', whereArgs: [reminder.id]);
  }

  Future<List<MedicineReminder>> getAllReminders() async {
    List<Map<String, Object?>> maps = await localdb.query(tableReminder);
    return List.generate(maps.length, (i) {
      return MedicineReminder.fromMap(maps[i]);
    });
  }

  Future close() async => localdb.close();

  Future<void> reset() async {
    await localdb.delete(tableReminder);
  }
}
