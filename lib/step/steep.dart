import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuck/signin/login.dart';

class OnboardingScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final currentIndex = useState(0);

    // Onboarding data reflecting the images and titles from the screenshots
    final onboardingData = [
      OnboardingPageData(
        imagePath:
            'assets/image/image1.jpeg', // Replace with actual image paths
        title: 'Discover place near you',
        description:
            'We make food ordering fast, simple and free - no matter if you order online cash.',
        buttonText: 'Next',
        buttonAction: () => pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      ),
      OnboardingPageData(
        imagePath: 'assets/image/image2.jpg',
        title: 'Order your favorites',
        description:
            'We make food ordering fast, simple and free - no matter if you order online cash.',
        buttonText: 'Next',
        buttonAction: () => pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      ),
      OnboardingPageData(
        imagePath: 'assets/image/image3.jpg',
        title: 'Pick up or delivery',
        description:
            'We make food ordering fast, simple and free - no matter if you order online cash.',
        buttonText: 'Start Now',
        buttonAction: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Login_Page(),
            ),
          ); // Navigate to the main app
        },
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: (index) => currentIndex.value = index,
            itemCount: onboardingData.length,
            itemBuilder: (context, index) =>
                OnboardingPage(data: onboardingData[index]),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: PageIndicator(
              count: onboardingData.length,
              currentIndex: currentIndex.value,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPageData {
  final String imagePath;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback buttonAction;

  OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonAction,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(data.imagePath, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 40),
          Text(
            data.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            data.description,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          AnimatedButton(
            text: data.buttonText == 'Next' ? '' : data.buttonText,
            onPressed: data.buttonAction,
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  AnimatedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: text.isNotEmpty,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.red, // Set the button background color to red
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  PageIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? Colors.red // Use the same red color as the button
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
