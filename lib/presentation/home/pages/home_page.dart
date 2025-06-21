import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:flutter/material.dart';
import '../../feed/pages/create_feed_page.dart';
import '../../login/pages/login_page.dart';
import '../widgets/drawer_menu.dart';
import '../../feed/pages/feed_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final double maxSlide = 0.75;
  late final AnimationController _controller;

  bool get isOpen => _controller.value == 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void open() => _controller.forward();
  void close() => _controller.reverse();
  void toggle() => isOpen ? close() : open();

  Future<void> _onProfileTap() async {
    await _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final drawerWidth = MediaQuery.of(context).size.width * maxSlide;
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          double delta = details.primaryDelta! / drawerWidth;
          _controller.value += delta;
        },
        onHorizontalDragEnd: (details) {
          if (_controller.value >= 0.5) {
            open();
          } else {
            close();
          }
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final slide = drawerWidth * _controller.value;
            final menuSlide = -drawerWidth * (1 - _controller.value);

            return Stack(
              children: [
                Transform.translate(
                  offset: Offset(menuSlide, 0),
                  child: SizedBox(
                    width: drawerWidth,
                    child: DrawerMenu(onProfileTap: _onProfileTap),
                  ),
                ),
                Transform.translate(
                  offset: Offset(slide, 0),
                  child: Stack(
                    children: [
                      AbsorbPointer(
                        absorbing: isOpen,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              if (_controller.value > 0)
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(
                                    0.15 * _controller.value,
                                  ),
                                  blurRadius: 16,
                                ),
                            ],
                          ),
                          child: Scaffold(
                            appBar: AppBar(
                              backgroundColor: theme.colorScheme.surface,
                              foregroundColor: theme.colorScheme.onSurface,
                              elevation: 0,
                              leading: IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: theme.colorScheme.onSurface,
                                ),
                                onPressed: toggle,
                              ),
                              actions: [
                                IconButton(
                                  icon: Icon(
                                    Icons.settings,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            body: const FeedPage(),
                            floatingActionButton: FloatingActionButton(
                              onPressed: () {
                                ChuChuNavigator.pushPage(context, (context) => CreateFeedPage());
                                // ChuChuNavigator.pushPage(context, (context) => LoginPage());
                              },
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              elevation: 0,
                              mini: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ),
                      ),
                      if (_controller.value > 0)
                        Positioned.fill(
                          child: IgnorePointer(
                            ignoring: !isOpen,
                            child: Opacity(
                              opacity: 0.5 * _controller.value,
                              child: GestureDetector(
                                onTap: close,
                                child: Container(
                                  color: theme.colorScheme.scrim,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
