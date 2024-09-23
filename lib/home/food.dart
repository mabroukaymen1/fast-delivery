import 'package:flutter/material.dart';
import 'package:fuck/home/carte.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodOrderPage extends StatefulWidget {
  final String title;
  final double price;
  final String imagePath;

  const FoodOrderPage({
    Key? key,
    required this.title,
    required this.price,
    required this.imagePath,
  }) : super(key: key);

  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage>
    with SingleTickerProviderStateMixin {
  List<String> selectedExtras = [];
  List<String> selectedSidekicks = [];
  List<String> selectedSauces = [];
  int quantity = 1;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late double basePrice;
  final Map<String, int> extraPrices = {
    'Gruyere': 3,
    'Cheddar': 3,
    'Camembert': 3,
  };

  double get totalPrice {
    double extrasCost = selectedExtras.fold(
      0,
      (sum, item) => sum + extraPrices[item]!,
    );
    return (basePrice + extrasCost) * quantity;
  }

  @override
  void initState() {
    super.initState();
    basePrice = widget.price;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.deepOrangeAccent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'food_image',
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleSection(),
                    SizedBox(height: 20),
                    _buildSauceOptions(),
                    _buildSidekickOptions(),
                    _buildExtraOptions(),
                    SizedBox(height: 20),
                    _buildQuantitySelector(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(
                          title: widget.title,
                          price: totalPrice,
                          quantity: quantity,
                          extras: selectedExtras,
                          sauces: selectedSauces,
                          sidekicks: selectedSidekicks,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 20),
                      SizedBox(width: 12),
                      Text(
                        'Add $quantity for',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        '${totalPrice.toStringAsFixed(3)} DT',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD72F2F),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Makloub Papadam',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${basePrice.toStringAsFixed(3)} DT',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Color(0xFFD72F2F),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Choice of sauce, lettuce, onion, sautéed vegetables, fries',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSauceOptions() {
    return _buildOptionsSection('Choose your sauces',
        ['Mayonnaise', 'Barbecue sauce', 'Ketchup'], 'sauces');
  }

  Widget _buildSidekickOptions() {
    return _buildOptionsSection(
        'Choose your sidekick', ['Lettuce', 'Tomatoes', 'Onion'], 'sidekicks');
  }

  Widget _buildExtraOptions() {
    return _buildOptionsSection(
        'Choose your extras',
        {
          'Gruyere': 3,
          'Cheddar': 3,
          'Camembert': 3,
        },
        'extras');
  }

  Widget _buildOptionsSection(String title, dynamic options, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        if (options is List<String>)
          ...options.map((option) => _buildOptionTile(option, type)).toList(),
        if (options is Map<String, int>)
          ...options.entries
              .map((entry) =>
                  _buildOptionTile(entry.key, type, price: entry.value))
              .toList(),
      ],
    );
  }

  Widget _buildOptionTile(String title, String type, {int price = 0}) {
    bool isSelected = false;
    switch (type) {
      case 'sauces':
        isSelected = selectedSauces.contains(title);
        break;
      case 'sidekicks':
        isSelected = selectedSidekicks.contains(title);
        break;
      case 'extras':
        isSelected = selectedExtras.contains(title);
        break;
    }

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: isSelected ? Color(0xFFD72F2F) : Colors.black,
        ),
      ),
      trailing: price > 0
          ? Text(
              '+${price.toStringAsFixed(3)} DT',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isSelected ? Color(0xFFD72F2F) : Colors.grey[600],
              ),
            )
          : Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? Color(0xFFD72F2F) : Colors.grey,
            ),
      onTap: () {
        setState(() {
          switch (type) {
            case 'sauces':
              _updateSelection(selectedSauces, title);
              break;
            case 'sidekicks':
              _updateSelection(selectedSidekicks, title);
              break;
            case 'extras':
              _updateSelection(selectedExtras, title);
              break;
          }
        });
      },
    );
  }

  void _updateSelection(List<String> list, String title) {
    setState(() {
      if (list.contains(title)) {
        list.remove(title);
      } else {
        list.add(title);
      }
    });
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quantity',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (quantity > 1) {
                  setState(() {
                    quantity--;
                  });
                }
              },
              icon: Icon(Icons.remove_circle_outline, color: Color(0xFFD72F2F)),
            ),
            Text(
              '$quantity',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  quantity++;
                });
              },
              icon: Icon(Icons.add_circle_outline, color: Color(0xFFD72F2F)),
            ),
          ],
        ),
      ],
    );
  }
}
