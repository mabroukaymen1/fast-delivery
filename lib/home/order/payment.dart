import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fuck/home/creditcards..dart';
import 'package:fuck/home/order/checkout.dart';
import 'package:fuck/home/order/location.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckoutPage extends StatefulWidget {
  final String title;
  final double totalPrice;
  final int quantity;
  final List<String> extras;
  final List<String> sauces;
  final List<String> sidekicks;

  const CheckoutPage({
    Key? key,
    required this.title,
    required this.totalPrice,
    required this.quantity,
    required this.extras,
    required this.sauces,
    required this.sidekicks,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  GoogleMapController? _mapController;
  final LatLng _initialPosition =
      LatLng(35.7643, 10.8113); // Monastir coordinates
  LatLng _currentPosition = LatLng(35.7643, 10.8113);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _locateMe() async {
    // Simulate moving to a new location
    setState(() {
      _currentPosition = LatLng(35.7671, 10.8168); // Simulated new location
    });
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_currentPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OrderSection(
              title: widget.title,
              quantity: widget.quantity,
              extras: widget.extras,
              sauces: widget.sauces,
            ),
            const SizedBox(height: 16),
            _DeliveryDetailsSection(
              initialPosition: _initialPosition,
              onMapCreated: _onMapCreated,
              locateMe: _locateMe,
            ),
            const SizedBox(height: 16),
            const _PaymentMethodSection(),
            const SizedBox(height: 16),
            _SummarySection(totalPrice: widget.totalPrice),
          ],
        ),
      ),
      bottomNavigationBar: _CheckoutBottomBar(totalPrice: widget.totalPrice),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Checkout",
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
    );
  }
}

class _OrderSection extends StatelessWidget {
  final String title;
  final int quantity;
  final List<String> extras;
  final List<String> sauces;

  const _OrderSection({
    required this.title,
    required this.quantity,
    required this.extras,
    required this.sauces,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Your Order", icon: 'assets/image/cards/order.svg'),
        const SizedBox(height: 8),
        Text(
          "$quantity item${quantity > 1 ? 's' : ''} from Papadam Food Monastir",
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
        _buildCustomCard(
          child: Column(
            children: [
              _buildCustomListTile(
                context: context,
                icon: 'assets/image/cards/diet.svg',
                title: title,
                subtitle: "${sauces.join(', ')}, ${extras.join(', ')}",
                onTap: () {},
              ),
              _buildDivider(),
              _buildCustomListTile(
                context: context,
                icon: 'assets/image/cards/diet.svg',
                title: "Any allergies?",
                onTap: () => _showAllergiesDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAllergiesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Allergies"),
          content: const TextField(
            decoration: InputDecoration(
              hintText: "Enter any allergies",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                // Save allergies logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }

  Widget _buildCustomListTile({
    required BuildContext context,
    required String icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: SvgPicture.asset(icon, height: 32, width: 32),
      title: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            )
          : null,
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      thickness: 1,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildSectionTitle(String title, {required String icon}) {
    return Row(
      children: [
        SvgPicture.asset(icon, height: 24, width: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _DeliveryDetailsSection extends StatelessWidget {
  final LatLng initialPosition;
  final Function(GoogleMapController) onMapCreated;
  final VoidCallback locateMe;

  const _DeliveryDetailsSection({
    required this.initialPosition,
    required this.onMapCreated,
    required this.locateMe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          "Delivery Details",
          icon: 'assets/image/cards/delivery.svg',
        ),
        const SizedBox(height: 16),
        _buildMapCard(context),
        const SizedBox(height: 16),
        _buildCustomCard(
          child: Column(
            children: [
              _buildCustomListTile(
                context: context,
                icon: 'assets/image/cards/place.svg',
                title: "QRCH+G42, Monastir, Tunisia",
                subtitle: "Far from current location",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressSelectionPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildCustomListTile(
                context: context,
                icon: 'assets/image/icons/home/gift.svg',
                title: "Sending to someone else?",
                subtitle: "Add their details to help the courier",
                onTap: () => _showRecipientDetailsDialog(context),
              ),
              _buildDivider(),
              _buildCustomListTile(
                context: context,
                icon: 'assets/image/cards/time.svg',
                title: "25-35 min",
                subtitle: "As soon as possible",
                onTap: () => _showDeliveryTimeDialog(context),
              ),
              _buildDivider(),
              _buildCustomListTile(
                context: context,
                icon: 'assets/image/cards/promo.svg',
                title: "Add Promo Code",
                onTap: () => _showPromoCodeDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapCard(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: initialPosition, zoom: 15),
              onMapCreated: onMapCreated,
              markers: {
                Marker(
                  markerId: MarkerId("current_position"),
                  position: initialPosition,
                ),
              },
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                mini: true,
                onPressed: locateMe,
                child: const Icon(Icons.my_location, color: Colors.white),
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddressChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Change Address"),
          content: Text("Address change functionality to be implemented."),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showRecipientDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Recipient Details"),
          content: Text("Recipient details functionality to be implemented."),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showDeliveryTimeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delivery Time"),
          content:
              Text("Delivery time selection functionality to be implemented."),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showPromoCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Promo Code"),
          content: Text("Promo code entry functionality to be implemented."),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }

  Widget _buildCustomListTile({
    required BuildContext context,
    required String icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: SvgPicture.asset(icon, height: 32, width: 32),
      title: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            )
          : null,
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      thickness: 1,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildSectionTitle(String title, {required String icon}) {
    return Row(
      children: [
        SvgPicture.asset(icon, height: 24, width: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.lato(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    );
  }
}

class _PaymentMethodSection extends StatelessWidget {
  const _PaymentMethodSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Payment Method",
            icon: 'assets/image/cards/credit.svg'),
        const SizedBox(height: 8),
        _buildPaymentMethods(context),
      ],
    );
  }

  Widget _buildPaymentMethods(BuildContext context) {
    return Column(
      children: [
        _buildCustomCard(
          child: Column(
            children: [
              _buildCustomListTile(
                context: context,
                icon: 'assets/image/cards/visa.svg',
                title: "Credit/Debit Card",
                subtitle: "**** **** **** 1234",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentCardForm(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildCustomListTile(
                context: context,
                icon: 'assets/image/cards/cash.svg',
                title: "Cash on Delivery",
                subtitle: "Pay in cash when delivered",
                onTap: () {
                  // Handle payment method change
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }

  Widget _buildCustomListTile({
    required BuildContext context,
    required String icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: SvgPicture.asset(icon, height: 32, width: 32),
      title: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            )
          : null,
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      thickness: 1,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildSectionTitle(String title, {required String icon}) {
    return Row(
      children: [
        SvgPicture.asset(icon, height: 24, width: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _SummarySection extends StatelessWidget {
  final double totalPrice;

  const _SummarySection({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Summary", icon: 'assets/image/cards/contract.svg'),
        const SizedBox(height: 8),
        _buildSummaryCard(),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return _buildCustomCard(
      child: Column(
        children: [
          _buildSummaryRow("Subtotal", "\DT ${totalPrice.toStringAsFixed(2)}"),
          _buildDivider(),
          _buildSummaryRow("Delivery Fee", "\DT 2.50"),
          _buildDivider(),
          _buildSummaryRow(
              "Total", "\DT ${(totalPrice + 2.50).toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      thickness: 1,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildSectionTitle(String title, {required String icon}) {
    return Row(
      children: [
        SvgPicture.asset(icon, height: 24, width: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _CheckoutBottomBar extends StatelessWidget {
  final double totalPrice;

  const _CheckoutBottomBar({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total: \DT ${totalPrice.toStringAsFixed(2)}",
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailCheckoutPage(),
                ),
              ); // Handle checkout button press
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD72F2F), // Button color
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              "Checkout",
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
