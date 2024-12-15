import 'dart:convert';

import 'package:sqflite/sqflite.dart';

const String tableReminder = 'medicineReminder';
const String medicineReminderId = 'id';
const String medicineReminderDeviceId = 'deviceId';
const String medicineReminderTime = 'medicineTime';
const String medicineReminderDosage = 'medicineDosage';
const String medicineReminderStartDate = 'medicineStartDate';
const String medicineReminderEndDate = 'medicineEndDate';

class MedicineReminder {
  int? id;
  int? deviceId;
  String medicineTime;
  Map<String, int> medicineDosage;
  DateTime medicineStartDate;
  DateTime medicineEndDate;

  MedicineReminder({
    this.id,
    this.deviceId,
    required this.medicineTime,
    required this.medicineDosage,
    required this.medicineStartDate,
    required this.medicineEndDate,
  });

  Map<String, Object?> toMap() {
    final map = {
      medicineReminderDeviceId: deviceId,
      medicineReminderTime: medicineTime,
      medicineReminderDosage: jsonEncode(medicineDosage),
      medicineReminderStartDate: medicineStartDate.toIso8601String(),
      medicineReminderEndDate: medicineEndDate.toIso8601String(),
    };

    if (id != null) {
      map[medicineReminderId] = id;
    }

    return map;
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'medicine_time': medicineTime,
      'dosage': medicineDosage,
      'start_date': medicineStartDate.toIso8601String(),
      'end_date': medicineEndDate.toIso8601String(),
    };
  }

  factory MedicineReminder.fromMap(Map<String, Object?> map) {
    return MedicineReminder(
      id: map[medicineReminderId] as int?,
      deviceId: map[medicineReminderDeviceId] as int?,
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
      deviceId: json['device_id'],
      medicineTime: json['time'],
      medicineDosage: (jsonDecode(json['dosage']) as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as int),
      ),
      medicineStartDate: DateTime.parse(json['start_date']),
      medicineEndDate: DateTime.parse(json['end_date']),
    );
  }

  static List<MedicineReminder> fromJsonList(List<dynamic> json) {
    List<MedicineReminder> reminders = [];
    for (var reminder in json) {
      reminders.add(MedicineReminder.fromJson(reminder));
    }
    return reminders;
  }
}

class ProviderMedicineReminder {
  late Database localdb;

  Future open(String path) async {
    localdb = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('DROP TABLE IF EXISTS $tableReminder');
        await db.execute('''
          create table $tableReminder ( 
            $medicineReminderId integer primary key autoincrement, 
            $medicineReminderDeviceId integer,
            $medicineReminderTime text not null,
            $medicineReminderDosage text not null,
            $medicineReminderStartDate text not null,
            $medicineReminderEndDate text not null)
          ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute('DROP TABLE IF EXISTS $tableReminder');
          await db.execute('''
            create table $tableReminder ( 
              $medicineReminderId integer primary key autoincrement, 
              $medicineReminderDeviceId integer,
              $medicineReminderTime text not null,
              $medicineReminderDosage text not null,
              $medicineReminderStartDate text not null,
              $medicineReminderEndDate text not null)
            ''');
        }
      },
    );
  }

  Future<MedicineReminder> insert(MedicineReminder reminder) async {
    final id = await localdb.insert(tableReminder, reminder.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return reminder..id = id;
  }

  Future<List<MedicineReminder>> getReminder() async {
    List<Map<String, Object?>> maps =
        await localdb.query(tableReminder, columns: [
      medicineReminderId,
      medicineReminderTime,
      medicineReminderDosage,
      medicineReminderStartDate,
      medicineReminderEndDate
    ]);
    if (maps.isNotEmpty) {
      print(maps);
      return MedicineReminder.fromJsonList(maps);
    } else {
      return [];
    }
  }

  Future<bool> exists(int id) async {
    final result = await localdb.query(
      tableReminder,
      columns: [medicineReminderId],
      where: '$medicineReminderId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
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
