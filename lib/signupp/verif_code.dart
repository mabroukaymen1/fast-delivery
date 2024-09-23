import 'package:flutter/material.dart';
import 'package:fuck/signupp/preference.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  static const int _codeLength = 6;
  final List<FocusNode> _focusNodes =
      List.generate(_codeLength, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(_codeLength, (_) => TextEditingController());

  void _verifyCode() {
    String _code = _controllers.map((controller) => controller.text).join();
    // Implement your verification logic here
    print('Verifying code: $_code');
    if (_code.length == _codeLength) {
      _showSnackBar('Verification successful');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreferenceScreen()),
      );
    } else {
      _showSnackBar('Verification failed. Please enter the complete code.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget _buildCodeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_codeLength, (index) {
        return Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            maxLength: 1,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey[400]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF212121),
                ),
              ),
              fillColor: const Color(0xFFF6F6F6),
              filled: true,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < _codeLength - 1) {
                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                } else {
                  FocusScope.of(context).unfocus();
                }
              } else if (index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
            },
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Verify Phone',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF212121),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Enter the verification code sent to your phone.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildCodeInput(),
            const Spacer(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _verifyCode,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFE53935),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text(
                  'Verify and continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
