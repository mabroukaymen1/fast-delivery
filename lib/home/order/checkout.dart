import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailCheckoutPage extends StatefulWidget {
  @override
  _DetailCheckoutPageState createState() => _DetailCheckoutPageState();
}

class _DetailCheckoutPageState extends State<DetailCheckoutPage> {
  final TextEditingController _promoCodeController = TextEditingController();
  bool _isProcessingPayment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Checkout",
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFFD72F2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD72F2F), Color(0xFFFF6B6B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CheckoutDetailRow(
              label: 'Name',
              value: 'Jonathan',
            ),
            SizedBox(height: 10),
            CheckoutDetailRow(
              label: 'Address',
              value: 'QRCH+G42, Monastir, Tunisia',
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Products',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '4 Items',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _promoCodeController,
              decoration: InputDecoration(
                prefixIcon: SvgPicture.asset(
                  'assets/image/cards/promo.svg',
                  height: 24,
                  width: 24,
                  fit: BoxFit.scaleDown,
                ),
                hintText: 'Enter your promo code',
                suffixIcon: IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Color(0xFFD72F2F)),
                  onPressed: _applyPromoCode,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14.0),
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Color(0xFFFFF4DD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/image/cards/diet.svg',
                      height: 24,
                      width: 24,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "You don't have enough balance\nplease top up first",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            CheckoutPaymentDetailRow(
              label: 'Payment',
              value: '\DT 56.45',
            ),
            CheckoutPaymentDetailRow(
              label: 'Fee Transaction',
              value: '\DT 2.5',
            ),
            SizedBox(height: 10),
            CheckoutPaymentDetailRow(
              label: 'Total Payment',
              value: '\DT 58.95',
              isBold: true,
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: Color(0xFFD72F2F)),
                SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      children: [
                        TextSpan(
                            text:
                                'All transactions are fast and safe. By continuing, '),
                        TextSpan(text: 'you agree to the '),
                        TextSpan(
                          text: 'terms and conditions',
                          style: TextStyle(
                            color: Color(0xFFD72F2F),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Additional spacing for better padding
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessingPayment ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD72F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isProcessingPayment
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'Pay Now',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20), // To prevent overflow
          ],
        ),
      ),
    );
  }

  void _applyPromoCode() {
    String promoCode = _promoCodeController.text;
    if (promoCode.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Promo code applied successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid promo code')),
      );
    }
  }

  void _processPayment() {
    setState(() {
      _isProcessingPayment = true;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isProcessingPayment = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment processed successfully!')),
      );
    });
  }
}

class CheckoutDetailRow extends StatelessWidget {
  final String label;
  final String value;

  CheckoutDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class CheckoutPaymentDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  CheckoutPaymentDetailRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: isBold ? Colors.black87 : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: isBold ? Colors.black87 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
