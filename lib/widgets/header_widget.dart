import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showMenuButton; // Add this parameter

  const Header({super.key, this.showBackButton = false, this.showMenuButton = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Event",
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.black,
      elevation: 2,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : (showMenuButton
              ? Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer(); // Opens the drawer
                      },
                    );
                  },
                )
              : null), // If both are false, no leading icon
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
