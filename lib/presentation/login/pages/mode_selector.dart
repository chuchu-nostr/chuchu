import 'package:flutter/material.dart';

class ModeSelector extends StatefulWidget {
  final bool isLoginMode;
  final Function(bool) onModeChanged;

  const ModeSelector({
    super.key,
    required this.isLoginMode,
    required this.onModeChanged,
  });

  @override
  _ModeSelectorState createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // Set initial animation state
    if (!widget.isLoginMode) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ModeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoginMode != oldWidget.isLoginMode) {
      if (widget.isLoginMode) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Sliding background
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Positioned(
                left: _slideAnimation.value * (MediaQuery.of(context).size.width - 48) / 2,
                top: 2,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 48) / 2,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Text buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!widget.isLoginMode) {
                      widget.onModeChanged(true);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Log in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: widget.isLoginMode ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (widget.isLoginMode) {
                      widget.onModeChanged(false);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Register',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: !widget.isLoginMode ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 