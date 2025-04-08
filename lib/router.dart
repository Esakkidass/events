import 'package:events/screens/admin/admin_home_screen.dart';
import 'package:events/screens/home/home.dart';
import 'package:events/screens/login/login.dart';
import 'package:events/screens/sponser/sponser_home.dart';
import 'package:events/widgets/admin_home.dart';
import 'package:flutter/material.dart';
import 'package:events/screens/event/event_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Correct route name for admin home page
      case '/admin_home':
        return MaterialPageRoute(builder: (_) => const AdminHomePage());
      
      // User home page
      case '/user_home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      
      // Default case for the initial route
      case '/':
        return MaterialPageRoute(builder: (_) => const AdminHomePage());
      
      // Sponsor home page
      case '/sponsor_home':
        return MaterialPageRoute(builder: (_) => const SponserHome());
      
      // Event screen
      // case '/event_screen':
      //   return MaterialPageRoute(builder: (_) => const EventScreen());
      
      // Fallback to login if route doesn't exist
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }

  // Redirect function based on userType
  static Widget redirectHome(String userType) {
    switch (userType) {
      case 'ADMIN':
        return const AdminHomePage();
      case 'USER':
        return const HomePage();
      case 'SPONSOR':
        return const SponserHome();
      default:
        return const LoginPage();
    }
  }
}
