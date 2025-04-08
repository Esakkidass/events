// ignore_for_file: avoid_print

import 'package:events/api/categoryMaster/category_Master.dart';
import 'package:events/api/events/create_event.dart';
// import 'package:events/api/category_api.dart'; // Import Category API service
import 'package:flutter/material.dart';

class EventCreationPage extends StatefulWidget {
  @override
  _EventCreationPageState createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedCategory;
  bool _isFree = false;
  bool _isLoading = false;

  // Function to select a date
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Function to select a time
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _createEvent() async {
    // Ensure all fields are filled
    if (_eventNameController.text.isEmpty ||
        _startDate == null ||
        _endDate == null ||
        _startTime == null ||
        _endTime == null || // Ensure end time is also filled
        _locationController.text.isEmpty ||
        _latitudeController.text.isEmpty ||
        _longitudeController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Format date and time for API
    String formattedStartDate = _startDate!.toLocal().toString().split(' ')[0];
    String formattedEndDate = _endDate!.toLocal().toString().split(' ')[0];
    String formattedStartTime =
        "${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}";
    String formattedEndTime =
        "${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}"; // Ensure end time is formatted

    // Print out the formatted event data to console
    print("Event Data: ");
    print("Event Name: ${_eventNameController.text}");
    print("Start Date: $formattedStartDate");
    print("End Date: $formattedEndDate");
    print("Start Time: $formattedStartTime");
    print("End Time: $formattedEndTime");
    print("Location: ${_locationController.text}");
    print("Latitude: ${_latitudeController.text}");
    print("Longitude: ${_longitudeController.text}");
    print("Description: ${_descriptionController.text}");
    print("Category: $_selectedCategory");

    // Call API to create event, ensure to pass eventCategoryIds as an array
    Map<String, dynamic> response = await EventApi.registerEvent(
      eventName: _eventNameController.text,
      eventStartDate: formattedStartDate,
      eventEndDate: formattedEndDate,
      eventStartTime: formattedStartTime,
      eventEndTime: formattedEndTime, // Ensure eventEndTime is passed
      eventLocation: _locationController.text,
      latitude: _latitudeController.text,
      longitude: _longitudeController.text,
      isFree: _isFree,
      eventDescription: _descriptionController.text,
      eventCategoryIds: [
        _selectedCategory!,
      ], // Wrap the selected category in an array
    );

    setState(() {
      _isLoading = false;
    });

    // Handle API Response
    if (response["status"] == 200 || response["status"] == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Event created successfully!")));
      Navigator.pop(context); // Navigate back
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${response["error"]}")));
    }
  }

  Future<List<Map<String, dynamic>>> _fetchCategories() async {
    Map<String, dynamic> response = await CategoryApi.getCategory();
    if (response["status"] == 200) {
      var categoryList = response["data"]["data"]?["category"];

      if (categoryList == null || categoryList is! List) {
        print("Category list is null or not a list!");
        return [];
      }
      return categoryList.map<Map<String, dynamic>>((category) {
        return {
          "id": category["id"], // Store category ID
          "name": category["categoryName"], // Store category Name
        };
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Event")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  labelText: "Event Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Start and End Date Pickers
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "Start Date",
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _startDate == null
                              ? "Select Date"
                              : _startDate!.toLocal().toString().split(' ')[0],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "End Date",
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _endDate == null
                              ? "Select Date"
                              : _endDate!.toLocal().toString().split(' ')[0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Start and End Time Pickers
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, true),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "Start Time",
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _startTime == null
                              ? "Select Time"
                              : _startTime!.format(context),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, false),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "End Time",
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _endTime == null
                              ? "Select Time"
                              : _endTime!.format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _latitudeController,
                      decoration: InputDecoration(
                        labelText: "Latitude",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _longitudeController,
                      decoration: InputDecoration(
                        labelText: "Longitude",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Event Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Checkbox(   
                    value: _isFree,
                    onChanged: (value) {
                      setState(() {
                        _isFree = value!;
                      });
                    },
                  ),
                  Text("Is Free?"),
                ],
              ),

              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No categories available"));
                  } else {
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                      ),
                      items:
                          snapshot.data!.map((category) {
                            return DropdownMenuItem(
                              value: category["id"].toString(),
                              child: Text(category["name"]),
                            );
                          }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCategory = value; // Store selected ID
                        });
                      },
                      value: _selectedCategory,
                    );
                  }
                },
              ),

             SizedBox(height: 20),

                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _createEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Create Event"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}