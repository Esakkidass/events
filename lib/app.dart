import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:events/router.dart';
import 'package:events/providers/auth_provider.dart';
import 'package:events/screens/login/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Management',
      onGenerateRoute: AppRouter.generateRoute,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return authProvider.isLoggedIn ? AppRouter.redirectHome(authProvider.userType) : const LoginPage();
        },
      ),
    );
  }
}
