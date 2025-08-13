import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/material.dart';
import 'package:chuchu/core/utils/adapt.dart';

class CarouselWidget extends StatefulWidget {
  final List<String> items;

  const CarouselWidget({
    super.key,
    required this.items,
  });

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  late PageController _pageController;
  int _currentIndex = 0;
  Map<int, bool> _imageLoadErrors = {}; // Track image loading errors
  Map<int, int> _imageRetryCount = {}; // Track retry count

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }



  // Add image retry method
  void _retryImageLoad(int index) {
    if (_imageRetryCount[index] == null) {
      _imageRetryCount[index] = 0;
    }
    
    if (_imageRetryCount[index]! < 3) { // Max 3 retries
      _imageRetryCount[index] = _imageRetryCount[index]! + 1;
      setState(() {
        _imageLoadErrors[index] = false;
      });
      // Retry image loading
    } else {
      // Max retry attempts reached
    }
  }

  // Build image widget
  Widget _buildImageWidget(String imageUrl, int index) {
    if (_imageLoadErrors[index] == true) {
      // Show retry button
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                color: Colors.white.withOpacity(0.7),
                size: 48.px,
              ),
              SizedBox(height: 16.px),
              Text(
                'Image Load Failed',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16.px,
                ),
              ),
              SizedBox(height: 8.px),
              ElevatedButton(
                onPressed: () => _retryImageLoad(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                ),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return SizedBox(height: 200);
    }

    return Column(
      children: [
        // Carousel content
        Container(
          height: 200,
          child: Stack(
            children: [
              GestureDetector(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final imageUrl = widget.items[index];
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.px),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.px),
                          child: Stack(
                            children: [
                              // Background image
                              Positioned.fill(
                                child: Container(
                                  child: _buildImageWidget(imageUrl, index),
                                ),
                              ),
                              
                              // Content overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.3),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Image counter
                              Positioned(
                                bottom: 16.px,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.px,
                                      vertical: 8.px,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(20.px),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.photo_library,
                                          color: Colors.white,
                                          size: 18.px,
                                        ),
                                        SizedBox(width: 8.px),
                                        Text(
                                          '${_currentIndex + 1}/${widget.items.length}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.px,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              

                              

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Navigation buttons
              if (widget.items.length > 1) ...[
                // Left button
                Positioned(
                  left: 8.px,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_currentIndex > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _pageController.animateToPage(
                            widget.items.length - 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        width: 40.px,
                        height: 40.px,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.black87,
                          size: 24.px,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Right button
                Positioned(
                  right: 8.px,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_currentIndex < widget.items.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        width: 40.px,
                        height: 40.px,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.black87,
                          size: 24.px,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ).setPaddingOnly(bottom: 16.0);
  }
}

 