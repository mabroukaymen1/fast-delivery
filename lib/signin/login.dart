import 'package:flutter/material.dart';
import 'package:fuck/signupp/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login_Page> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPref();
  }

  Future<void> _initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString('email') ?? '';
    passwordController.text = prefs.getString('password') ?? '';
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a login process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (_rememberMe) {
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);
      await prefs.setBool('rememberMe', _rememberMe);
    }

    // Simulate login success or failure
    bool loginSuccess = true; // Change this based on actual login logic

    if (loginSuccess) {
      // Handle successful login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      // Navigate to another page or home screen
    } else {
      // Handle login failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed! Please try again.')),
      );
    }
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _loginUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                'Sign In',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF212121),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Hi! Welcome back, you’ve been missed.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: const Color(0xFFF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Implement Forgot Password
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: const Color(0xFFE53935),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFFE53935),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.black26,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Or continue with",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 50, // Adjust the width as needed
                          height: 50, // Adjust the height as needed
                          child: IconButton(
                            icon: Image.asset('assets/image/google.png'),
                            iconSize: 15,
                            onPressed: () {
                              // Implement Google Sign-In
                            },
                          ),
                        ),
                        SizedBox(
                          width: 50, // Adjust the width as needed
                          height: 50, // Adjust the height as needed
                          child: IconButton(
                            icon: Image.asset('assets/image/apple.png'),
                            iconSize: 15,
                            onPressed: () {
                              // Implement Apple Sign-In
                            },
                          ),
                        ),
                        SizedBox(
                          width: 50, // Adjust the width as needed
                          height: 50, // Adjust the height as needed
                          child: IconButton(
                            icon: Image.asset('assets/image/facebook.png'),
                            iconSize: 15,
                            onPressed: () {
                              // Implement Facebook Sign-In
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        ); // Implement Register navigation
                      },
                      child: const Text(
                        'Don’t have an account? Register',
                        style: TextStyle(
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
