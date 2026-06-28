import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'emoji': '🗺️',
      'title': 'Capture Your Journey',
      'subtitle':
          'Document every adventure with stories, photos, and memories that last forever.',
      'color': AppColors.primary,
    },
    {
      'emoji': '📸',
      'title': 'Every Photo Tells a Story',
      'subtitle':
          'Snap moments with your camera and attach them to your travel memories.',
      'color': AppColors.olive,
    },
    {
      'emoji': '✨',
      'title': 'Preserved Forever',
      'subtitle':
          'Your journals are saved locally — private, secure, and always accessible offline.',
      'color': AppColors.accent,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Mark onboarding as seen
      await context.read<AuthProvider>().markOnboardingSeen();
      if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void _skip() async {
    await context.read<AuthProvider>().markOnboardingSeen();
    if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _currentPage < _pages.length - 1
                    ? TextButton(
                        onPressed: _skip,
                        child: Text(
                          'Skip',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : const SizedBox(height: 40),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _OnboardingPage(
                    emoji: page['emoji'],
                    title: page['title'],
                    subtitle: page['subtitle'],
                    color: page['color'],
                  );
                },
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.textMuted.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder - big emoji in a circle
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.2), width: 2),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 72)),
            ),
          ),

          const SizedBox(height: 48),

          Text(
            title,
            style: AppTextStyles.displayMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            subtitle,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
