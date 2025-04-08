// ignore_for_file: unused_local_variable

import 'package:events/api/events/edit_event.dart';
import 'package:flutter/material.dart';

class EventEditPage extends StatefulWidget {
  final Map<String, dynamic> eventData;

  EventEditPage({required this.eventData});

  @override
  _EventEditPageState createState() => _EventEditPageState();
}

class _EventEditPageState extends State<EventEditPage> {
  late TextEditingController _eventNameController;
  late TextEditingController _locationController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _descriptionController;

  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedCategory;
  bool _isFree = false;
  bool _isLoading = false;

  List<String> _categories = ["Conference", "Workshop", "Meetup", "Webinar"]; 

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController(text: widget.eventData["eventName"]);
    _locationController = TextEditingController(text: widget.eventData["eventLocation"]);
    _latitudeController = TextEditingController(text: widget.eventData["latitude"].toString());
    _longitudeController = TextEditingController(text: widget.eventData["longitude"].toString());
    _descriptionController = TextEditingController(text: widget.eventData["eventDescription"]);

    _startDate = DateTime.tryParse(widget.eventData["eventStartDate"]);
    _endDate = DateTime.tryParse(widget.eventData["eventEndDate"]);
    _startTime = _parseTime(widget.eventData["eventStartTime"]);
    _endTime = _parseTime(widget.eventData["eventEndTime"]);

    // _selectedCategory = widget.eventData["eventCategoryIds"]?.isNotEmpty == true
    //     ? widget.eventData["eventCategoryIds"][0].toString()
    //     : _categories.first;

    _isFree = widget.eventData["isFree"] ?? false;
  }

  TimeOfDay _parseTime(String time) {
    List<String> parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) _startDate = picked;
        else _endDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime ?? TimeOfDay.now() : _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) _startTime = picked;
        else _endTime = picked;
      });
    }
  }

 void _editEvent() async {
  if (_eventNameController.text.isEmpty ||
      _startDate == null || _endDate == null ||
      _startTime == null || _endTime == null ||
      _locationController.text.isEmpty ||
      _latitudeController.text.isEmpty || _longitudeController.text.isEmpty ||
      _descriptionController.text.isEmpty || _selectedCategory == null) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please fill in all fields"))
    );
    return;
  }

  setState(() => _isLoading = true);

  // Formatting Dates & Times
  String formattedStartDate = _startDate!.toLocal().toString().split(' ')[0];
  String formattedEndDate = _endDate!.toLocal().toString().split(' ')[0];
  String formattedStartTime = "${_startTime!.hour}:${_startTime!.minute}";
  String formattedEndTime = "${_endTime!.hour}:${_endTime!.minute}";

  // Call API
  var response = await EditEventApi.editEvent(
    eventId: widget.eventData["id"].toString(),
    eventName: _eventNameController.text,
    eventStartDate: formattedStartDate,
    eventEndDate: formattedEndDate,
    eventStartTime: formattedStartTime,
    eventEndTime: formattedEndTime,
    eventLocation: _locationController.text,
    latitude: _latitudeController.text,
    longitude: _longitudeController.text,
    isFree: _isFree,
    eventDescription: _descriptionController.text,
    // eventCategoryIds: [_selectedCategory!],
  );

  setState(() => _isLoading = false);

  if (response["status"] == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Event updated successfully!"))
    );
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${response["error"]}"))
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Event")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_eventNameController, "Event Name"),
            _buildTextField(_locationController, "Location"),
            _buildTextField(_latitudeController, "Latitude"),
            _buildTextField(_longitudeController, "Longitude"),
            _buildTextField(_descriptionController, "Description", maxLines: 3),
            _buildDateTimeField("Start Date", _startDate?.toString().split(' ')[0] ?? "Select", () => _selectDate(context, true)),
            _buildDateTimeField("End Date", _endDate?.toString().split(' ')[0] ?? "Select", () => _selectDate(context, false)),
            _buildDateTimeField("Start Time", _startTime?.format(context) ?? "Select", () => _selectTime(context, true)),
            _buildDateTimeField("End Time", _endTime?.format(context) ?? "Select", () => _selectTime(context, false)),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(labelText: "Event Category"),
              items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
              onChanged: (newValue) => setState(() => _selectedCategory = newValue),
            ),
            CheckboxListTile(
              title: Text("Is Free"),
              value: _isFree,
              onChanged: (value) => setState(() => _isFree = value ?? false),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: _isLoading ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Icon(Icons.save),
                label: Text("Update Event"),
                onPressed: _isLoading ? null : _editEvent,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(controller: controller, decoration: InputDecoration(labelText: label), maxLines: maxLines),
    );
  }

  Widget _buildDateTimeField(String label, String value, VoidCallback onTap) {
    return ListTile(title: Text(label), subtitle: Text(value), trailing: Icon(Icons.calendar_today), onTap: onTap);
  }
}
