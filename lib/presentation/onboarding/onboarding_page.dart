import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../login/pages/new_login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      title: 'Decentralized Content Subscriptions',
      description: 'Creators publish paid content, and users subscribe to unlock exclusive posts, built on the Nostr protocol.',
      illustration: 'introduction_01.png',
    ),
    OnboardingItem(
      title: 'Built-in Lightning Wallet',
      description: 'Includes a custodial Lightning wallet for fast, low-fee payments. Subscriptions are billed seamlessly via the Lightning Network with transaction history support.',
      illustration: 'introduction_02.png',
    ),
    OnboardingItem(
      title: 'Data Security & User Control',
      description: 'Built on a decentralized architecture where users own their keys and data. End-to-end encryption and local storage ensure privacy and security.',
      illustration: 'introduction_03.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _skip() {
    _goToLogin();
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => NewLoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
     
      color: kBgLight,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Skip button
          
            Container(
              color: kBgLight,
              child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: _skip,
                  child: ShaderMask(
                    shaderCallback: (bounds) => getBrandGradientHorizontal().createShader(bounds),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ),
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            // Bottom section with content card
            _buildBottomSection(),
            // Bottom safe area padding with white background
            Container(
              height: MediaQuery.of(context).padding.bottom,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
    return Container(
      color: kBgLight,
      width: double.infinity,
      child: Stack(
        children: [
          // Illustration background with gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                 color: kBgLight,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/${item.illustration}',
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    final currentItem = _pages[_currentPage];
    final isLastPage = _currentPage == _pages.length - 1;

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            currentItem.title,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          // Description
          Text(
            currentItem.description,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          // Pagination indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => _buildIndicator(index == _currentPage),
            ),
          ),
          SizedBox(height: 24),
          // Next/Get Started button
          Container(
            width: double.infinity,
            height: 50,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _nextPage,
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: getBrandGradientHorizontal(),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLastPage ? 'Get Started' : 'Next',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        gradient: isActive ? getBrandGradientHorizontal() : null,
        color: isActive ? null : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String illustration;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.illustration,
  });
}

