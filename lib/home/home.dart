import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuck/home/resto.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _currentPromoIndex = 0;
  late PageController _promoPageController;
  late Timer _promoTimer;
  late AnimationController _animationController;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _promoPageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPromoTimer();
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _simulateLoading();
  }

  void _simulateLoading() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _startPromoTimer() {
    _promoTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!_promoPageController.hasClients) return;

      if (_currentPromoIndex < 2) {
        _currentPromoIndex++;
      } else {
        _currentPromoIndex = 0;
      }

      if (_promoPageController.hasClients) {
        _promoPageController.animateToPage(
          _currentPromoIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _promoTimer.cancel();
    _promoPageController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isLoading
            ? _buildShimmerLoading()
            : _getSelectedPage(_currentIndex),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(5, (index) => _buildShimmerItem()),
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 20,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFD72F2F),
      elevation: 0,
      title: _buildAppBarTitle(),
      actions: [
        _buildSearchIcon(), // Add search icon here
        _buildNotificationIcon(),
      ],
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

  Widget _buildAppBarTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning, Enzo!',
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'It\'s lunch time!',
          style: GoogleFonts.lato(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchIcon() {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/image/icons/home/serch.svg', // Your search bar SVG file
        color: Colors.white,
        width: 24,
      ),
      onPressed: () {
        // Add search functionality logic
      },
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/image/icons/home/bell.svg',
            color: Colors.white,
            width: 24,
          ),
          onPressed: () {
            // Add notification logic
          },
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: const BoxConstraints(
              minWidth: 14,
              minHeight: 14,
            ),
            child: Text(
              '3',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: const Color(0xFFD72F2F),
      buttonBackgroundColor: const Color(0xFFFF6B6B),
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      index: _currentIndex,
      items: <Widget>[
        _buildBottomNavItem('assets/image/icons/home/home.svg'),
        _buildBottomNavItem('assets/image/order.svg'),
        _buildBottomNavItem('assets/image/icons/home/gift.svg'),
        _buildBottomNavItem('assets/image/icons/home/user.svg'),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        _animationController.forward(from: 0.0);
      },
    );
  }

  Widget _buildBottomNavItem(String assetPath) {
    return SvgPicture.asset(
      assetPath,
      width: 30,
      color: Colors.white,
    );
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildorderPage();
      case 2:
        return _buildRewardsPage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return AnimationLimiter(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              _buildCardBalanceSection(),
              const SizedBox(height: 16),
              _buildPromoSection(),
              const SizedBox(height: 16),
              _buildCardRewardsSection(),
              const SizedBox(height: 16),
              _buildRecommendedPlaceSection(),
              const SizedBox(height: 16),
              _buildPopularPlaceSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildorderPage() {
    return const Center(child: Text('order Page'));
  }

  Widget _buildRewardsPage() {
    return const Center(child: Text('Rewards Page'));
  }

  Widget _buildProfilePage() {
    return const Center(child: Text('Profile Page'));
  }

  Widget _buildPromoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Promo Today'),
          const SizedBox(height: 8),
          SizedBox(
            height: 180, // Increased height to accommodate content
            child: PageView(
              controller: _promoPageController,
              children: [
                _buildPromoCard(
                  title: '#PromoToday',
                  description: 'Buy 2 Get 1 Free, for Mizara Iced Coffee',
                  buttonText: 'Buy Coffee',
                  imagePath: 'assets/image/icons/home/coffee.png',
                ),
                _buildPromoCard(
                  title: '#PromoToday',
                  description: '50% Off on All Beverages',
                  buttonText: 'Order Now',
                  imagePath: 'assets/image/icons/home/pizza.png',
                ),
                _buildPromoCard(
                  title: '#PromoToday',
                  description: 'Free Dessert with Main Course',
                  buttonText: 'Get Dessert',
                  imagePath: 'assets/image/icons/home/gelato.png',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: SmoothPageIndicator(
              controller: _promoPageController,
              count: 3,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Color(0xFFD72F2F),
                dotColor: Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard({
    required String title,
    required String description,
    required String buttonText,
    required String imagePath,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFD72F2F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          description,
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            buttonText,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardBalanceSection() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE53935),
        image: DecorationImage(
          image: AssetImage("assets/image/bac1.png"),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your card balance',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        '\$',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '125.00',
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Add recharge functionality
                    },
                    child: const Text(
                      'Recharge',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardRewardsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        shadowColor: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/image/icons/home/soda.svg', // Update this path

                width: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rewards Earned',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '2 Drinks',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.card_giftcard, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Redeem',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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

  Widget _buildRecommendedPlaceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Recommended Places'),
          const SizedBox(height: 8),
          SizedBox(
            height: 240, // Increased height to accommodate content
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildPlaceCard(
                  title: 'Burger Place',
                  description: 'Best burgers in town!',
                  imagePath: 'assets/image/burgr.png',
                ),
                _buildPlaceCard(
                  title: 'Coffee House',
                  description: 'Cozy place for coffee lovers!',
                  imagePath: 'assets/image/coffeee.png',
                ),
                _buildPlaceCard(
                  title: 'Pizza Corner',
                  description: 'Delicious pizza varieties!',
                  imagePath: 'assets/image/pizzaa.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularPlaceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Popular Places'),
          const SizedBox(height: 8),
          SizedBox(
            height: 240, // Increased height to accommodate content
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildPlaceCard(
                  title: 'Pizza World',
                  description: 'Cheesiest pizza in town!',
                  imagePath: 'assets/image/pizzaa.png',
                ),
                _buildPlaceCard(
                  title: 'Cafe Aroma',
                  description: 'Relax and enjoy your coffee!',
                  imagePath: 'assets/image/coffeee.png',
                ),
                _buildPlaceCard(
                  title: 'Burger King',
                  description: 'King of all burgers!',
                  imagePath: 'assets/image/burgr.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(
              title: title,
              imagePath: imagePath,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Open',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '4.5',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(120+)',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
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

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () {
            // Add view all functionality
          },
          child: Text(
            'View All',
            style: GoogleFonts.lato(
              color: const Color(0xFFD72F2F),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
