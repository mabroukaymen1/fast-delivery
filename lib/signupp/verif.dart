import 'package:flutter/material.dart';
import 'package:fuck/signupp/verif_code.dart';

class VerificationMethodScreen extends StatefulWidget {
  @override
  _VerificationMethodScreenState createState() =>
      _VerificationMethodScreenState();
}

class _VerificationMethodScreenState extends State<VerificationMethodScreen> {
  String? _selectedMethod;

  void _selectMethod(String method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF212121),
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Verification\nMethod',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF212121),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose your preferred method for account verification.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOptionCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: 'amanda.samantha@gmail.com',
                    selected: _selectedMethod == 'Email',
                    onTap: () => _selectMethod('Email'),
                  ),
                  _buildOptionCard(
                    icon: Icons.phone_android,
                    title: 'Phone',
                    subtitle: '+62 9999 - 9991 - 432',
                    selected: _selectedMethod == 'Phone',
                    onTap: () => _selectMethod('Phone'),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedMethod != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneVerificationScreen(),
                            ),
                          ); // Handle next action
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFE53935),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE53935) : const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selected ? Colors.transparent : const Color(0xFFE0E0E0)),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? const Color(0xFFE53935).withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : const Color(0xFFE53935),
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: selected ? Colors.white : const Color(0xFF212121),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: selected
                    ? Colors.white.withOpacity(0.8)
                    : const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
