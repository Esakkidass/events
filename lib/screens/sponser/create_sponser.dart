import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "../../api/sponser/create_sponser.dart"; // Import API Handler

class CreateSponsorPage extends StatefulWidget {
  const CreateSponsorPage({super.key});

  @override
  _CreateSponsorPageState createState() => _CreateSponsorPageState();
}

class _CreateSponsorPageState extends State<CreateSponsorPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  bool _isLoading = false;

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await OfficerApi.registerOfficer(
        sponsorEmail: _emailController.text,
        password: _passwordController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        city: _cityController.text,
        state: _stateController.text,
        zip: _zipController.text,
        isUserExist: false,
      );

      if (response["status"] == 200 || response["status"] == 201) {
        Fluttertoast.showToast(msg: "Sponsor Created Successfully", toastLength: Toast.LENGTH_SHORT);
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "Failed: ${response["error"]}", toastLength: Toast.LENGTH_LONG);
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "An error occurred: $error", toastLength: Toast.LENGTH_LONG);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Sponsor")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Email", _emailController, Icons.email, TextInputType.emailAddress),
              _buildTextField("Password", _passwordController, Icons.lock, TextInputType.visiblePassword, obscureText: true),
              _buildTextField("Address", _addressController, Icons.home, TextInputType.streetAddress),
              _buildTextField("Phone", _phoneController, Icons.phone, TextInputType.phone),
              _buildTextField("City", _cityController, Icons.location_city, TextInputType.text),
              _buildTextField("State", _stateController, Icons.map, TextInputType.text),
              _buildTextField("Zip Code", _zipController, Icons.pin_drop, TextInputType.number),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Create Sponsor", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, TextInputType keyboardType, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label, // Floating label
          prefixIcon: Icon(icon, color: Colors.blueAccent), // Icons for better UI
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
          focusedBorder: OutlineInputBorder( // Custom focus border
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? "$label is required" : null,
      ),
    );
  }
}
