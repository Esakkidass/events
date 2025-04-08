import 'package:events/screens/event/view_event.dart';
import 'package:flutter/material.dart';
import 'package:events/screens/admin/admin_screen.dart';

class SponserMenuDrawer extends StatelessWidget {
  const SponserMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.people, "Admin", context, Colors.deepOrange, null),
                _buildDrawerItem(Icons.event, "Events", context, Colors.green, EventDetailsPage()),
                _buildDrawerItem(Icons.business, "Sponsors", context, Colors.blue, AdminScreen()),
                _buildDivider(),
                _buildDrawerItem(Icons.help, "Help & Support", context, Colors.indigo, null),
                _buildDrawerItem(Icons.logout, "Log Out", context, Colors.red, null),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: Colors.blue),
      accountName: Text("Esakki"),
      accountEmail: Text("esakki@vivid.com"),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context, Color color, Widget? screen) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        Navigator.pop(context); // Close drawer first
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
    );
  }

  Widget _buildDivider() {
    return const Divider(
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Colors.grey,
    );
  }
}
