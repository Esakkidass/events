// import 'package:flutter/material.dart';
// import './screens/login/login.dart';
// import './screens/home/home.dart'; 
// import "./screens/sponser/create_sponser.dart";
// import "./screens/event/event_screen.dart";
//  // Updated import

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Login Demo',
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const LoginPage(),
//         '/home': (context) => const HomePage(),
//         '/create_sponsor': (context) => const CreateSponsorPage(),
//         './event_screen': (context)=> const EventScreen()
//           // Updated route
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:events/app.dart';
import 'package:events/providers/auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider()..checkLoginStatus(),
      child: const MyApp(),
    ),
  );
}
