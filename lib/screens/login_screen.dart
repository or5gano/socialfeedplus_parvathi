import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialfeedplus_parvathi/components/login_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();

    // Step 2: Extract username using regex (everything before '@')
    RegExp regex = RegExp(r'^[^@]+');
    String? username = regex.stringMatch(email);

    if (username != null && username.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      debugPrint("✅ Username saved: $username");

      if (mounted) {
        Navigator.pushNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(top: 0.04 * MediaQuery.of(context).size.height),
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 20),
                      width: 0.85 * MediaQuery.of(context).size.width,
                      child: const Text(
                        'Login',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Raleway-Regular',
                          color: Colors.black87,
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 345,
                        height: 335,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/Login.png'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 14),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                                labelStyle: TextStyle(color: Color(0xFF2B4F70)),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }

                                // Basic email format validation using regex
                                final emailRegex =
                                    RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }

                                return null; // means valid
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 14),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Color(0xFF2B4F70)),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          LoginButton(
                            text: "Login",
                            onPress: () {
                              _handleLogin();
                              Navigator.pushNamed(context, '/home');
                            },
                            w: MediaQuery.of(context).size.width - 30,
                            color: 0xff6F8EFC,
                            textColor: 0xFFffffff,
                            highlight: 0xff451EB7,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
