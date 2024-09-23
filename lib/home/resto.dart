import 'package:flutter/material.dart';
import 'package:fuck/home/food.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String title;
  final String imagePath;

  const RestaurantDetailScreen({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFavorite = false;
  double _cartTotal = 0;
  late Map<String, int> _itemCounts;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _itemCounts = {};
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _updateCart(String itemTitle, double priceChange, int newCount) {
    setState(() {
      _itemCounts[itemTitle] = newCount;
      _cartTotal += priceChange;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            priceChange > 0 ? 'Item added to cart' : 'Item removed from cart'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        backgroundColor: priceChange > 0
            ? const Color.fromARGB(255, 23, 227, 129)
            : Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
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
                    tag: 'restaurant_image',
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
            actions: [
              IconButton(
                icon: Icon(Icons.translate, color: Colors.white),
                onPressed: () {
                  // Implement translation functionality
                },
              ),
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _animation,
              child: RestaurantInfoWidget(title: widget.title),
            ),
          ),
          SliverToBoxAdapter(
            child: SearchBarWidget(),
          ),
          SliverToBoxAdapter(
            child: TopSellersWidget(
              updateCart: _updateCart,
              itemCounts: _itemCounts,
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 60 * (1 - _animation.value)),
            child: Opacity(
              opacity: _animation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${_cartTotal.toStringAsFixed(2)} DT',
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: ElevatedButton(
                            onPressed: _cartTotal > 0
                                ? () {
                                    // Implement checkout functionality
                                  }
                                : null,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Checkout',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: _cartTotal > 0
                                  ? Color(0xFFD72F2F)
                                  : Colors.grey.shade400,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RestaurantInfoWidget extends StatelessWidget {
  final String title;

  const RestaurantInfoWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/image/resto.jpg'),
                radius: 28,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.deepOrange],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Free delivery on orders over 8 DT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(color: Colors.grey[300]),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(Icons.thumb_up, '85%'),
              _buildInfoItem(Icons.access_time, '25-35 min'),
              _buildInfoItem(Icons.delivery_dining, '1,000 DT'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFFD72F2F), size: 28),
        SizedBox(height: 4),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'What can we get you?',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (value) {
          // Implement search functionality
        },
      ),
    );
  }
}

class TopSellersWidget extends StatelessWidget {
  final Function(String, double, int) updateCart;
  final Map<String, int> itemCounts;

  const TopSellersWidget({
    Key? key,
    required this.updateCart,
    required this.itemCounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Sellers',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 15),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey[300]),
            itemBuilder: (context, index) {
              String itemName = 'Seller Item $index';
              double itemPrice = (index + 1) * 2.5;
              int itemCount = itemCounts[itemName] ?? 0;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodOrderPage(
                            title: itemName,
                            price: itemPrice,
                            imagePath: 'assets/image/burg.png',
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/image/burg.png',
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  title: Text(
                    itemName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '$itemPrice DT',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: AnimatedCounterButton(
                    count: itemCount,
                    onCountChanged: (newCount) {
                      updateCart(
                        itemName,
                        (newCount - itemCount) * itemPrice,
                        newCount,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AnimatedCounterButton extends StatefulWidget {
  final int count;
  final Function(int) onCountChanged;

  const AnimatedCounterButton({
    Key? key,
    required this.count,
    required this.onCountChanged,
  }) : super(key: key);

  @override
  _AnimatedCounterButtonState createState() => _AnimatedCounterButtonState();
}

class _AnimatedCounterButtonState extends State<AnimatedCounterButton>
    with SingleTickerProviderStateMixin {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.count;
  }

  @override
  void didUpdateWidget(covariant AnimatedCounterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _count = widget.count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            if (_count > 0) {
              setState(() {
                _count--;
              });
              widget.onCountChanged(_count);
            }
          },
          icon: Icon(Icons.remove_circle_outline, color: Colors.redAccent),
        ),
        Text(
          '$_count',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _count++;
            });
            widget.onCountChanged(_count);
          },
          icon: Icon(Icons.add_circle_outline, color: Colors.green),
        ),
      ],
    );
  }
}
