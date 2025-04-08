import 'package:events/api/events/delete_event.dart';
import 'package:events/api/events/get_event.dart';
import 'package:events/screens/event/edit_event.dart';
import 'package:events/screens/event/event_screen.dart';
import 'package:flutter/material.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key});

  @override
  _GetEventPageState createState() => _GetEventPageState();
}

class _GetEventPageState extends State<EventDetailsPage> {
  List<dynamic> events = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API delay
      final response = await GetEventApi.getEvent();

      if (response != null && response['status'] == 200) {
        final eventData = response['data'];

        if (eventData != null && eventData.containsKey('data')) {
          final actualData = eventData['data'];
          if (actualData.containsKey('event')) {
            setState(() {
              events = List<Map<String, dynamic>>.from(actualData['event']);
              isLoading = false;
            });
          } else {
            setState(() {
              errorMessage = "No events available.";
              events = [];
              isLoading = false;
            });
          }
        } else {
          setState(() {
            errorMessage = "No events data available.";
            events = [];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = response?['error'] ?? "Failed to load events.";
          events = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        events = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Fixed "Add Event" button at the top
  Container(
  width: double.infinity,
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  color: Colors.blueAccent.withOpacity(0.1), // Light background
  child: Row(
    mainAxisAlignment: MainAxisAlignment.end, // Align button to the right
    children: [
      SizedBox(
        height: 36, // Smaller button height
        width: 120, // Smaller button width
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // Smaller border radius
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10), // Smaller padding
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventCreationPage(),
              ),
            );
          },
          child: const Text("Add Event", style: TextStyle(fontSize: 12)), // Smaller font size
        ),
      ),
    ],
  ),
),



  // Scrollable event list below
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      )
                    : events.isEmpty
                        ? const Center(
                            child: Text("No events found.", style: TextStyle(fontSize: 16)),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              print("Rendering event: ${events[index]}"); // Debugging
                              return _buildEventCard(events[index]);
                            },
                          ),
          ),
        ],
      ),
    );
  }

Widget _buildEventCard(Map<String, dynamic> event) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event["eventName"] ?? "No Event Name",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert), // Three-dot menu icon
                onSelected: (value) {
                  if (value == 'view') {
                    _showEventDetailsDialog(event);
                  } else if (value == 'edit') {
                    _editEvent(event);
                  } else if (value == 'delete') {
                    _deleteEvent(event);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("View"),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("Edit"),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Delete"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("📅 Date: ${event["eventStartDate"] ?? "N/A"}"),
          Text("⏰ Time: ${event["eventStartTime"] ?? "N/A"} - ${event["eventEndTime"] ?? "N/A"}"),
          Text("📍 Location: ${event["eventLocation"] ?? "N/A"}"),
        ],
      ),
    ),
  );
}

// Function to handle event editing
void _editEvent(Map<String, dynamic> event) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EventEditPage(eventData: event),
    ),
  ).then((_) {
    fetchEvents(); // Refresh events after returning
  });
}


// Function to handle event deletion
void _deleteEvent(Map<String, dynamic> event) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Event"),
      content: Text("Are you sure you want to delete '${event["eventName"]}'?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
      ],
    ),
  );

  if (confirm == true) {
    final eventId = event["id"];
    if (eventId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event ID not found.")),
      );
      return;
    }

    final response = await DeleteEventApi.deleteEvent(eventId);

    if (response['status'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event deleted successfully")),
      );
      fetchEvents(); // Refresh list
    } else {
      final error = response['error'].toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete event: $error")),
      );
    }
  }
}


  void _showEventDetailsDialog(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event["eventName"] ?? "Event Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📅 Start Date: ${event["eventStartDate"] ?? "N/A"}"),
              Text("📅 End Date: ${event["eventEndDate"] ?? "N/A"}"),
              Text("⏰ Start Time: ${event["eventStartTime"] ?? "N/A"}"),
              Text("⏰ End Time: ${event["eventEndTime"] ?? "N/A"}"),
              Text("📍 Location: ${event["eventLocation"] ?? "N/A"}"),
              Text("🌍 Latitude: ${event["latitude"] ?? "N/A"}"),
              Text("🌎 Longitude: ${event["longitude"] ?? "N/A"}"),
              Text("📝 Description: ${event["eventDescription"] ?? "No description"}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
