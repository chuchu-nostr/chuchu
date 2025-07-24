import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../feed/pages/create_feed_page.dart';
import '../../feed/pages/feed_notifications_page.dart';

import '../widgets/drawer_menu.dart';
import '../../feed/pages/feed_page.dart';
import '../../../core/manager/chuchu_feed_manager.dart';
import '../../../core/feed/model/notificationDB_isar.dart';
import '../../../core/feed/model/noteDB_isar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, ChuChuFeedObserver {
  final double maxSlide = 0.75;
  late final AnimationController _controller;
  late final ScrollController _scrollController;
  bool _isScrolled = false;
  bool _hasNotifications = false;

  bool get isOpen => _controller.value == 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    ChuChuFeedManager.sharedInstance.addObserver(this);
  }

  void _scrollListener() {
    final isScrolled =
        _scrollController.hasClients && _scrollController.offset > 0;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
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
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    ChuChuFeedManager.sharedInstance.removeObserver(this);
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
                                  color: theme.shadowColor.withValues(
                                    alpha: 0.15 * _controller.value,
                                  ),
                                  blurRadius: 16,
                                ),
                            ],
                          ),
                          child: Scaffold(
                            appBar: AppBar(
                              backgroundColor:
                              theme.colorScheme.surface,
                              foregroundColor:
                              theme.colorScheme.primary,
                              elevation: _isScrolled ? 4 : 0,
                              surfaceTintColor: Colors.transparent,
                              leadingWidth: 164.px,
                              leading: GestureDetector(
                                onTap: toggle,
                                child: CommonImage(
                                  iconName: 'logo_text_primary.png',
                                  width: 140,
                                ),
                              ).setPaddingOnly(left: 18.px),
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(12.px),
                                child: const SizedBox(),
                              ),
                              actions: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Stack(
                                    key: ValueKey(_isScrolled),
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            _hasNotifications = false;
                                          });
                                          ChuChuNavigator.pushPage(
                                            context,
                                                (context) =>
                                                FeedNotificationsPage(),
                                          );
                                        },
                                        child: CommonImage(
                                          iconName: 'notification.png',
                                          size: 24,
                                        ),
                                      ).setPaddingOnly(right: 12.0),
                                      if (_hasNotifications)
                                        Positioned(
                                          right: 8,
                                          top: 8,
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color:
                                                    _isScrolled
                                                        ? theme
                                                            .colorScheme
                                                            .primary
                                                        : theme
                                                            .colorScheme
                                                            .surface,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                              systemOverlayStyle:
                                  _isScrolled
                                      ? SystemUiOverlayStyle.light
                                      : SystemUiOverlayStyle.dark,
                            ),
                            body: FeedPage(scrollController: _scrollController),
                            floatingActionButton: FloatingActionButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => CreateFeedPage(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;
                                      
                                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                      var offsetAnimation = animation.drive(tween);
                                      
                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                    transitionDuration: const Duration(milliseconds: 300),
                                    reverseTransitionDuration: const Duration(milliseconds: 250),
                                  ),
                                );
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

  @override
  didNewNotesCallBackCallBack(List<NoteDBISAR> notes) {}

  @override
  didNewNotificationCallBack(List<NotificationDBISAR> notifications) {
    if (notifications.isNotEmpty && mounted) {
      setState(() {
        _hasNotifications = true;
      });
    }
  }
}
