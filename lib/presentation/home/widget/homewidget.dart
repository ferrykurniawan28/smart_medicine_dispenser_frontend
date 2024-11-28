import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_dispencer/presentation/home/controller/homecontroller.dart';

Widget greatings(HomeController controller) {
  DateTime now = DateTime.now();
  int hour = now.hour;
  String greats;
  if (hour < 12) {
    greats = 'Good Morning';
  } else if (hour < 18) {
    greats = 'Good Afternoon';
  } else {
    greats = 'Good Evening';
  }
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            greats,
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          GetBuilder<HomeController>(builder: (context) {
            return Text(controller.user?.name ?? 'No user',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ));
          }),
        ],
      ),
      const Spacer(),
      Image.asset(
        'assets/images/3d/doctor.png',
        height: 70,
      ),
    ],
  );
}

Widget barChart() {
  DateTime now = DateTime.now();

  // get the last 7 days
  List<String> days = [];
  for (int i = 0; i < 7; i++) {
    DateTime day = now.subtract(Duration(days: i));
    String dayName = DateFormat('EEE').format(day);
    // reverse the order of the days
    days.insert(0, dayName);
  }

  // Widget

  // get the data for the last 7 days
  // TODO: get the data from the database

  Map<String, dynamic> dataMap = {
    days[0]: {
      'missed': 2,
      'taken': 8,
    },
    days[1]: {
      'missed': 1,
      'taken': 9,
    },
    days[2]: {
      'missed': 3,
      'taken': 7,
    },
    days[3]: {
      'missed': 4,
      'taken': 6,
    },
    days[4]: {
      'missed': 5,
      'taken': 5,
    },
    days[5]: {
      'missed': 6,
      'taken': 4,
    },
    days[6]: {
      'missed': 7,
      'taken': 3,
    },
  };

  return AspectRatio(
    aspectRatio: 1.5,
    child: Container(
      margin: const EdgeInsets.all(0),
      child: Card(
        child: BarChart(
          BarChartData(
            backgroundColor: Colors.transparent,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    rod.toY.round().toString(),
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            barGroups: [
              for (int i = 0; i < 7; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: dataMap[days[i]]['missed'].toDouble(),
                      color: Colors.red,
                    ),
                    BarChartRodData(
                      toY: dataMap[days[i]]['taken'].toDouble(),
                      color: Colors.green,
                    ),
                  ],
                ),
            ],
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                axisNameWidget: Text('Last 7 Days'),
                axisNameSize: 20,
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      days[value.toInt()],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// Widget userPerformance() {
//   return Card(
//     child: Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         // color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: const Column(
//         children: [
//           Text(
//             'Performance for the last 7 days',
//             style: TextStyle(
//               fontSize: 20,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Column(
//                 children: [
//                   const Text(
//                     'Missed',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.red,
//                     ),
//                   ),
//                   const Text(
//                     '2',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.red,
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   const Text(
//                     'Taken',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.green,
//                     ),
//                   ),
//                   const Text(
//                     '8',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.green,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

Widget motivation(int missed, int taken) {
  // calculate the percentage
  double percentage = (taken / (missed + taken)) * 100;

  // get the motivation message
  String message;

  if (percentage < 50) {
    message = 'You need to improve, keep it up!';
  } else if (percentage < 75) {
    message = 'You are doing good, keep it up!';
  } else {
    message = 'You are doing excellent, keep it up!';
  }

  return Card(
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}

Widget reminderList(
  String medicineName,
  String medicineDose,
  String time,
  String date,
) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.medication),
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medicineName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            medicineDose,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
      const Spacer(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    ],
  );
}
