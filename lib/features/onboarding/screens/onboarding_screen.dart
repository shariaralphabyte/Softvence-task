import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:softvence_app/common_widgets/custom_button.dart';
import 'package:softvence_app/constants/app_colors.dart';
import 'package:softvence_app/features/location/screens/location_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "Discover the world, one journey at a time.",
      "description":
          "From hidden gems to iconic destinations, we make travel simple, inspiring, and unforgettable. Start your next adventure today.",
      "image": "assets/images/1.png" 
    },
    {
      "title": "Effortless and automatic syncing",
      "description":
          "Sync your alarms with your location automatically as you travel across timezones.",
      "image": "assets/images/2.png" 
    },
     {
      "title": "Relaxation and unwinding",
      "description":
          "Enjoy your trip without worrying about missing important alarms or events.",
      "image": "assets/images/3.png" 
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    final box = Hive.box<String>('alarms');
    await box.put('onboarding_seen', 'true');

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LocationScreen()),
      );
    }
  }
  
  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  // For now, use a colored container placeholder if image missing,
                  // or a network image if we had one.
                  // The distinct top section suggests image takes up top half.
                  return Stack(
                    children: [
                      // Top Image Area
                      Positioned.fill(
                        bottom: 50, // Leave overlap room
                        child: Container(
                           decoration: BoxDecoration(
                             image: DecorationImage(
                               image: AssetImage(_pages[index]['image']!),
                               fit: BoxFit.cover,
                             ),
                           ),
                        ),
                      ),
                      // Gradient Overlay for text readability if needed
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.gradientEnd.withOpacity(0.0),
                                AppColors.gradientEnd, // Merge into dark background
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Skip Button
                      Positioned(
                        top: 50,
                        right: 20,
                        child: TextButton(
                          onPressed: _completeOnboarding,
                          child: const Text("Skip", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _pages[_currentPage]['title']!,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _pages[_currentPage]['description']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(),

                    // Dots Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 8 : 8, // Both circles
                          decoration: BoxDecoration(
                            color: _currentPage == index ? AppColors.primaryPurple : Colors.white24,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Button
                    CustomButton(
                      text: _currentPage == _pages.length - 1 ? "Get Started" : "Next",
                      onPressed: _nextPage,
                      backgroundColor: AppColors.primaryPurple,
                      height: 56,
                    ),
                     const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
