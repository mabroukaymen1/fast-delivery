import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fuck/home/home.dart';

class PreferenceScreen extends StatefulWidget {
  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  int currentStep = 0;
  List<String> selectedCountries = [];
  List<String> selectedCuisines = [];
  List<String> selectedDislikes = [];

  final List<PreferenceOption> countryOptions = [
    PreferenceOption(label: 'France', iconPath: 'assets/image/icons/fr.svg'),
    PreferenceOption(label: 'Russia', iconPath: 'assets/image/icons/ru.svg'),
    PreferenceOption(label: 'China', iconPath: 'assets/image/icons/cn.svg'),
    PreferenceOption(label: 'Taiwan', iconPath: 'assets/image/icons/tw.svg'),
    PreferenceOption(label: 'Brazil', iconPath: 'assets/image/icons/br.svg'),
    PreferenceOption(label: 'Norway', iconPath: 'assets/image/icons/no.svg'),
    PreferenceOption(label: 'America', iconPath: 'assets/image/icons/us.svg'),
    PreferenceOption(label: 'Australia', iconPath: 'assets/image/icons/au.svg'),
    PreferenceOption(label: 'Indonesia', iconPath: 'assets/image/icons/id.svg'),
  ];

  final List<PreferenceOption> cuisineOptions = [
    PreferenceOption(label: 'Sushi', iconPath: 'assets/image/icons/su.svg'),
    PreferenceOption(label: 'Curry', iconPath: 'assets/image/icons/cu.svg'),
    PreferenceOption(label: 'Salad', iconPath: 'assets/image/icons/sa.svg'),
    PreferenceOption(label: 'Seafood', iconPath: 'assets/image/icons/fru.svg'),
    PreferenceOption(label: 'Chicken', iconPath: 'assets/image/icons/po.svg'),
    PreferenceOption(label: 'Noodles', iconPath: 'assets/image/icons/nou.svg'),
    PreferenceOption(label: 'Soup', iconPath: 'assets/image/icons/sop.svg'),
    PreferenceOption(label: 'Meat', iconPath: 'assets/image/icons/vi.svg'),
    PreferenceOption(label: 'Spaghetti', iconPath: 'assets/image/icons/pa.svg'),
  ];

  final List<PreferenceOption> dislikeOptions = [
    PreferenceOption(label: 'Veggies', iconPath: 'assets/image/icons/leg.svg'),
    PreferenceOption(label: 'Egg', iconPath: 'assets/image/icons/oe.svg'),
    PreferenceOption(label: 'Sushi', iconPath: 'assets/image/icons/su.svg'),
    PreferenceOption(label: 'Bacon', iconPath: 'assets/image/icons/ba.svg'),
    PreferenceOption(label: 'Chicken', iconPath: 'assets/image/icons/po.svg'),
    PreferenceOption(label: 'Octopus', iconPath: 'assets/image/icons/cal.svg'),
    PreferenceOption(label: 'Bread', iconPath: 'assets/image/icons/bag.svg'),
    PreferenceOption(label: 'Seafood', iconPath: 'assets/image/icons/fru.svg'),
  ];

  void toggleOption(String option, List<String> selectedList) {
    setState(() {
      if (selectedList.contains(option)) {
        selectedList.remove(option);
      } else {
        selectedList.add(option);
      }
    });
  }

  void nextStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    } else {
      // Handle completion of all steps and navigate to the next screen
      print('Preferences completed!');
      print('Selected Countries: $selectedCountries');
      print('Selected Cuisines: $selectedCuisines');
      print('Selected Dislikes: $selectedDislikes');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(),
            Expanded(
              child: IndexedStack(
                index: currentStep,
                children: [
                  PreferenceStep(
                    title: 'Your preferred country food?',
                    options: countryOptions,
                    selectedOptions: selectedCountries,
                    onOptionToggle: (country) =>
                        toggleOption(country, selectedCountries),
                    onContinue: nextStep,
                  ),
                  PreferenceStep(
                    title: 'Your preferred cuisines?',
                    options: cuisineOptions,
                    selectedOptions: selectedCuisines,
                    onOptionToggle: (cuisine) =>
                        toggleOption(cuisine, selectedCuisines),
                    onContinue: nextStep,
                  ),
                  PreferenceStep(
                    title: 'Any Dislikes?',
                    options: dislikeOptions,
                    selectedOptions: selectedDislikes,
                    onOptionToggle: (dislike) =>
                        toggleOption(dislike, selectedDislikes),
                    onContinue: nextStep,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Row(
        children: [
          if (currentStep > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
              onPressed: previousStep,
            ),
          Expanded(
            child: StepProgressIndicator(currentStep: currentStep),
          ),
          TextButton(
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.black54),
            ),
            onPressed: () {/* Handle skip */},
          ),
        ],
      ),
    );
  }
}

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;

  StepProgressIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: 8.0,
            decoration: BoxDecoration(
              color: index <= currentStep
                  ? const Color(0xFFE53935)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        );
      }),
    );
  }
}

class PreferenceStep extends StatelessWidget {
  final String title;
  final List<PreferenceOption> options;
  final List<String> selectedOptions;
  final ValueChanged<String> onOptionToggle;
  final VoidCallback onContinue;

  PreferenceStep({
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onOptionToggle,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF212121),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: options.map((option) {
                final isSelected = selectedOptions.contains(option.label);
                return GestureDetector(
                  onTap: () => onOptionToggle(option.label),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFFE53935) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.2)
                                : const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(
                              option.iconPath,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          option.label,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF212121),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PreferenceOption {
  final String label;
  final String iconPath;

  PreferenceOption({required this.label, required this.iconPath});
}
