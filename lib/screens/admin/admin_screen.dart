import 'package:flutter/material.dart';
import "../../api//getsponser/get_sponser.dart"; // Adjust this import based on your file structure
import '../../widgets/all_header.dart'; 

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Map<String, dynamic>> officerData = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchOfficerData();
  }

Future<void> fetchOfficerData() async {
  try {
    final response = await OfficerApi.getOfficer();
    if (response['status'] == 200) {
      final data = response['data'];

      if (data != null && data.containsKey('data') && data['data'].containsKey('sponsor')) {
        final extractedData = List<Map<String, dynamic>>.from(data['data']['sponsor'] ?? []);

        setState(() {
          officerData = extractedData;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Data format error: 'sponsor' key missing";
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = response['error'].toString();
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = "Failed to fetch data";
      isLoading = false;
    });
  }
}


  // Future<void> fetchOfficerData() async {
  //   try {
  //     final response = await OfficerApi.getOfficer();
  //     if (response['status'] == 200) {
  //       final data = response['data'];

  //       if (data != null && data.containsKey('data') && data['data'].containsKey('sponsor')) {
  //         final extractedData = List<Map<String, dynamic>>.from(data['data']['sponsor'] ?? []);

  //         setState(() {
  //           officerData = extractedData;
  //           isLoading = false;
  //         });
  //       } else {
  //         setState(() {
  //           errorMessage = "Data format error: 'sponsor' key missing";
  //           isLoading = false;
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         errorMessage = response['error'].toString();
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = "Failed to fetch data";
  //       isLoading = false;
  //     });
  //   }
  // }

  void editSponsor(int index) {
    print("Edit Sponsor: ${officerData[index]}");
  }

  void deleteSponsor(int index) {
    setState(() {
      officerData.removeAt(index);
    });
    print("Deleted Sponsor at index: $index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Details", style: TextStyle(color: Colors.white)),
        backgroundColor:  Colors.blue,
      ), 
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage != null
                ? Text(
                    "Error: $errorMessage",
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  )
                : officerData.isEmpty
                    ? const Text("No data available")
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildAdminCountCard(),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: officerData.length,
                                itemBuilder: (context, index) {
                                  final sponsor = officerData[index];
                                  return _buildSponsorCard(sponsor, index);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildAdminCountCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings, size: 30, color: Colors.red),
            const SizedBox(width: 10),
            Text(
              "Total Admins: ${officerData.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSponsorCard(Map<String, dynamic> sponsor, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(Icons.email, "Email", sponsor["email"] ?? "N/A"),
            _buildDetailItem(Icons.phone, "Phone", sponsor["phone"] ?? "N/A"),
            _buildDetailItem(Icons.location_city, "City", sponsor["city"] ?? "N/A"),
            _buildDetailItem(Icons.map, "State", sponsor["state"] ?? "N/A"),
            _buildDetailItem(Icons.pin_drop, "ZIP Code", sponsor["zip"] ?? "N/A"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => editSponsor(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteSponsor(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color:  Colors.blue,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
