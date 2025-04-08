// // import 'package:events/screens/sponser/create_sponser.dart';
// // import 'package:flutter/material.dart';
// // import 'package:fl_chart/fl_chart.dart'; // Import FL Chart
// // import 'package:events/widgets/header_widget.dart';
// // import '../../widgets/menu_drawer.dart';
// // import '../../api/getsponser/get_sponser.dart';

// // class AdminHomePage extends StatefulWidget {
// //   const AdminHomePage({super.key});

// //   @override
// //   _AdminHomePageState createState() => _AdminHomePageState();
// // }

// // class _AdminHomePageState extends State<AdminHomePage> {
// //   int sponsorCount = 0;
// //   int eventCount = 50;
// //   int adminCount = 5;
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchCounts();
// //   }

// //   Future<void> fetchCounts() async {
// //     try {
// //       final response = await OfficerApi.getOfficer();
// //       if (response['status'] == 200) {
// //         final data = response['data'];

// //         setState(() {
// //           sponsorCount = (data['data']['sponsor'] as List).length;
// //           adminCount = (data['data']['admins'] as List).length;
// //           eventCount = (data['data']['events'] as List).length;
// //           isLoading = false;
// //         });
// //       } else {
// //         setState(() {
// //           isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: const Header(showBackButton: false, showMenuButton: true),
// //       drawer: const MenuDrawer(),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             isLoading ? const CircularProgressIndicator() : _buildInfoRow(),
// //             const SizedBox(height: 16),
// //             Expanded(child: _buildChart()), // Add the chart here
// //           ],
// //         ),
// //       ),

// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (context) => const CreateSponsorPage()),
// //           );
// //         },
// //         backgroundColor: Colors.blue,
// //         child: const Icon(Icons.add, color: Colors.white),
// //       ),
// //     );
// //   }

// //   Widget _buildInfoRow() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Expanded(child: _buildCategoryCard("Sponsors", sponsorCount, Colors.blue, Icons.business)),
// //         const SizedBox(width: 10),
// //         // Expanded(child: _buildCategoryCard("Events", eventCount, Colors.green, Icons.event)),
// //         // const SizedBox(width: 10),
// //         // Expanded(child: _buildCategoryCard("User", adminCount, Colors.red, Icons.admin_panel_settings)),
// //       ],
// //     );
// //   }

// //   Widget _buildCategoryCard(String title, int count, Color color, IconData icon) {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Icon(icon, size: 30, color: color),
// //             const SizedBox(height: 8),
// //             Text(
// //               "$count",
// //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
// //             ),
// //             Text(title, style: const TextStyle(fontSize: 16, color: Colors.black54)),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   /// 📊 **Bar Chart Widget**
// //   Widget _buildChart() {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 10),
// //       child: BarChart(
// //         BarChartData(
// //           barGroups: [
// //             _barGroup(0, sponsorCount.toDouble(), Colors.blue),
// //             _barGroup(1, eventCount.toDouble(), Colors.green),
// //             _barGroup(2, adminCount.toDouble(), Colors.red),
// //           ],
// //           titlesData: FlTitlesData(
// //             leftTitles: AxisTitles(
// //               sideTitles: SideTitles(showTitles: true, reservedSize: 40),
// //             ),
// //             bottomTitles: AxisTitles(
// //               sideTitles: SideTitles(
// //                 showTitles: true,
// //                 getTitlesWidget: (value, meta) {
// //                   switch (value.toInt()) {
// //                     case 0:
// //                       return const Text("Sponsors", style: TextStyle(fontSize: 12));
// //                     // case 1:
// //                     //   return const Text("Events", style: TextStyle(fontSize: 12));
// //                     // case 2:
// //                     //   return const Text("Users", style: TextStyle(fontSize: 12));
// //                     default:
// //                       return const Text("");
// //                   }
// //                 },
// //               ),
// //             ),
// //           ),
// //           borderData: FlBorderData(show: false),
// //           gridData: FlGridData(show: false),
// //           barTouchData: BarTouchData(enabled: true),
// //         ),
// //       ),
// //     );
// //   }
// //   BarChartGroupData _barGroup(int x, double y, Color color) {
// //     return BarChartGroupData(
// //       x: x,
// //       barRods: [
// //         BarChartRodData(
// //           toY: y,
// //           color: color,
// //           width: 20,
// //           borderRadius: BorderRadius.circular(4),
// //         ),
// //       ],
// //     );
// //   }
// // }

// import 'package:events/screens/sponser/create_sponser.dart';
// import 'package:events/widgets/admin_home.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart'; // Import FL Chart
// import 'package:events/widgets/header_widget.dart';
// import '../../widgets/menu_drawer.dart';
// import '../../api/getsponser/get_sponser.dart';

// class AdminHomePage extends StatefulWidget {
//   const AdminHomePage({super.key});

//   @override
//   _AdminHomePageState createState() => _AdminHomePageState();
// }

// class _AdminHomePageState extends State<AdminHomePage> {
//   int sponsorCount = 0;
//   int eventCount = 10;
//   int adminCount = 5;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchCounts();
//   }

//   Future<void> fetchCounts() async {
//     try {
//       final response = await OfficerApi.getOfficer();
//       if (response['status'] == 200) {
//         final data = response['data'];

//         setState(() {
//           sponsorCount = (data['data']['sponsor'] as List).length;
//           adminCount = (data['data']['admins'] as List).length;
//           eventCount = (data['data']['events'] as List).length;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const Header(showBackButton: false, showMenuButton: true),
//       drawer: const AdminMenuDrawer(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             isLoading ? const CircularProgressIndicator() : _buildInfoRow(),
//             const SizedBox(height: 16),
//             Expanded(child: _buildChart()), // Add the chart here
//           ],
//         ),
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const CreateSponsorPage()),
//           );
//         },
//         backgroundColor: Colors.blue,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildInfoRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(child: _buildCategoryCard("Sponsors", sponsorCount, Colors.blue, Icons.business)),
//         const SizedBox(width: 10),
//         Expanded(child: _buildCategoryCard("Events", eventCount, Colors.green, Icons.event)),
//         const SizedBox(width: 10),
//         Expanded(child: _buildCategoryCard("User", adminCount, Colors.red, Icons.admin_panel_settings)),
        
//       ],
//     );
//   }

//   Widget _buildCategoryCard(String title, int count, Color color, IconData icon) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 30, color: color),
//             const SizedBox(height: 8),
//             Text(
//               "$count",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
//             ),
//             Text(title, style: const TextStyle(fontSize: 16, color: Colors.black54)),
//           ],
//         ),
//       ),
//     );
//   }

// /// 📊 **Pie Chart Widget**
// Widget _buildChart() {
//   return Center(
//     child: PieChart(
//       PieChartData(
//         sections: _getSections(),
//         centerSpaceRadius: 40, // Adjust size of inner space
//         borderData: FlBorderData(show: false),
//         sectionsSpace: 2, // Space between segments
//       ),
//     ),
//   );
// }

// /// 🎨 **Helper Function for Pie Chart Sections**
// List<PieChartSectionData> _getSections() {
//   return [
//     PieChartSectionData(
//       value: sponsorCount.toDouble(),
//       title: "$sponsorCount\nSponsors",
//       color: Colors.blue,
//       radius: 50,
//       titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
//     ),
//     PieChartSectionData(
//       value: eventCount.toDouble(),
//       title: "$eventCount\nEvents",
//       color: Colors.green,
//       radius: 50,
//       titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
//     ),
//     PieChartSectionData(
//       value: adminCount.toDouble(),
//       title: "$adminCount\nUsers",
//       color: Colors.red,
//       radius: 50,
//       titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
//     ),
    
//   ];
// }
// }

import 'package:events/screens/sponser/create_sponser.dart';
import 'package:events/widgets/admin_home.dart' show AdminMenuDrawer;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import FL Chart
import 'package:events/widgets/header_widget.dart';
import '../../widgets/menu_drawer.dart';
import '../../api/getsponser/get_sponser.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int sponsorCount = 0;
  int eventCount = 10;
  int adminCount = 5;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    try {
      final response = await OfficerApi.getOfficer();
      if (response['status'] == 200) {
        final data = response['data'];

        setState(() {
          sponsorCount = (data['data']['sponsor'] as List).length;
          adminCount = (data['data']['admins'] as List).length;
          eventCount = (data['data']['events'] as List).length;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(showBackButton: false, showMenuButton: true),
      drawer: const AdminMenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            isLoading ? const CircularProgressIndicator() : _buildInfoRow(),
            const SizedBox(height: 16),
            Expanded(child: _buildChart()), // Add the chart here
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateSponsorPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildCategoryCard("Sponsors", sponsorCount, Colors.blue, Icons.business)),
        const SizedBox(width: 10),
        Expanded(child: _buildCategoryCard("Events", eventCount, Colors.green, Icons.event)),
        const SizedBox(width: 10),
        Expanded(child: _buildCategoryCard("User", adminCount, Colors.red, Icons.admin_panel_settings)),
        
      ],
    );
  }

  Widget _buildCategoryCard(String title, int count, Color color, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              "$count",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            Text(title, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

/// 📊 **Pie Chart Widget**
Widget _buildChart() {
  return Center(
    child: PieChart(
      PieChartData(
        sections: _getSections(),
        centerSpaceRadius: 40, // Adjust size of inner space
        borderData: FlBorderData(show: false),
        sectionsSpace: 2, // Space between segments
      ),
    ),
  );
}

/// 🎨 **Helper Function for Pie Chart Sections**
List<PieChartSectionData> _getSections() {
  return [
    PieChartSectionData(
      value: sponsorCount.toDouble(),
      title: "$sponsorCount\nSponsors",
      color: Colors.blue,
      radius: 50,
      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    PieChartSectionData(
      value: eventCount.toDouble(),
      title: "$eventCount\nEvents",
      color: Colors.green,
      radius: 50,
      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    PieChartSectionData(
      value: adminCount.toDouble(),
      title: "$adminCount\nUsers",
      color: Colors.red,
      radius: 50,
      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    
  ];
}
}
