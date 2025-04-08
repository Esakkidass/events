import 'package:events/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:events/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/auth_service.dart';
import '../../api/signup/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    final response = await AuthService.login(email, password);

    setState(() => _isLoading = false);

    if (response["status"] == 200 && response["body"] != null) {
      final body = response["body"];

      if (body is Map<String, dynamic> && body.containsKey("data")) {
        final data = body["data"];

        if (data is Map<String, dynamic> &&
            data.containsKey("session") &&
            data.containsKey("userDetails")) {

          await SecureStorage.saveUserData(body);
          await SecureStorage.saveUserDataa(body);

          // ✅ Update AuthProvider
          if (mounted) {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            await authProvider.checkLoginStatus();

            // ✅ Redirect based on userType
            Navigator.pushReplacementNamed(context, authProvider.userType == "USER" ? '/user_home' : '/');
          }
          return;
        }
      }
    }

    // ❌ Show error if login fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response["body"]?["message"] ?? "Invalid email or password")),
    );
  }

  void _showSignUpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController firstNameController =
            TextEditingController();
        final TextEditingController lastNameController =
            TextEditingController();
        final TextEditingController emailController = TextEditingController();
        final TextEditingController passwordController =
            TextEditingController();
        final _signUpFormKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text("Sign Up"),
          content: SingleChildScrollView(
            child: Form(
              key: _signUpFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: firstNameController,
                    decoration: _inputDecoration("First Name", Icons.person),
                    validator:
                        (value) =>
                            value!.isEmpty ? "Enter your first name" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastNameController,
                    decoration: _inputDecoration("Last Name", Icons.person),
                    validator:
                        (value) =>
                            value!.isEmpty ? "Enter your last name" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration("Email", Icons.email),
                    keyboardType: TextInputType.emailAddress,
                    validator:
                        (value) => value!.isEmpty ? "Enter your email" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    decoration: _inputDecoration("Password", Icons.lock),
                    obscureText: true,
                    validator:
                        (value) =>
                            value!.length < 6
                                ? "Password must be at least 6 characters"
                                : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_signUpFormKey.currentState!.validate()) {
                  // Call sign-up API
                  final response = await AuthServiceRegister.register(
                    firstNameController.text.trim(),
                    lastNameController.text.trim(),
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );

                  if (response["status"] == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Sign Up Successful! Please log in."),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          response["body"]?["message"] ?? "Sign Up Failed",
                        ),
                      ),
                    );
                  }
                }
              },
              child: const Text("Sign Up"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/part.png",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint("Failed to load image: $error");
              return const Text(
                "Image not found",
                style: TextStyle(color: Colors.red),
              );
            },
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 100,
                            child: Image.asset("assets/images/events.png"),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            decoration: _inputDecoration("Email", Icons.person),
                            keyboardType: TextInputType.emailAddress,
                            validator:
                                (value) =>
                                    value!.isEmpty ? "Enter your email" : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: _inputDecoration(
                              "Password",
                              Icons.lock,
                            ),
                            obscureText: true,
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? "Enter your password"
                                        : null,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                backgroundColor: const Color(0xFFd84e55),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text(
                                        "LOGIN",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                              const Text(" | "),
                              TextButton(
                                onPressed: _showSignUpDialog,
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      prefixIcon: Icon(icon, color: Colors.redAccent),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:events/providers/auth_provider.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "Password"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 authProvider.login(emailController.text, passwordController.text, context);
//               },
//               child: const Text("Login"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
