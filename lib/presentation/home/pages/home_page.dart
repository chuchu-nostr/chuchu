import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:chuchu/presentation/drawerMenu/follows/pages/follows_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../feed/pages/create_feed_page.dart';
import '../../feed/pages/feed_notifications_page.dart';

import '../widgets/drawer_menu.dart';
import '../../feed/pages/feed_page.dart';
import '../../../core/manager/chuchu_feed_manager.dart';
import '../../../core/feed/model/notificationDB_isar.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import 'search_page.dart';
import 'messages_page.dart';
import 'profile_page.dart';


enum BottomNavItem {
  home(
    selectedAsset: 'home_select_icon.png',
    unselectedAsset: 'home_icon.png',
  ),
  search(
    selectedAsset: 'search_select_icon.png',
    unselectedAsset: 'search_icon.png',
  ),
  add(
    selectedAsset: 'reply_select_icon.png',
    unselectedAsset: 'reply.png',
  ),
  messages(
    selectedAsset: 'reply_select_icon.png',
    unselectedAsset: 'reply.png',
  ),
  profile(
    selectedAsset: 'user_icon.png',
    unselectedAsset: 'user_icon.png',
  );

  final String? selectedAsset;
  final String? unselectedAsset;

  const BottomNavItem({
    this.selectedAsset,
    this.unselectedAsset,
  });
}

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
  int _currentIndex = 0;

  BottomNavItem _currentTab = BottomNavItem.home;

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
                            body: _buildCurrentPage(),
                            bottomNavigationBar: _buildBottomNavigationBar(),
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

  Widget _buildBottomNavigationBar() {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).padding.bottom;
    const gap = 10.0;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset + gap),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 66,
            decoration: _glassDecoration(theme),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final item in [
                  BottomNavItem.home,
                  BottomNavItem.search,
                ]) _buildTabItem(item),
                _buildAddButton(),
                for (final item in [
                  BottomNavItem.messages,
                  BottomNavItem.profile,
                ]) _buildTabItem(item),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _glassDecoration(ThemeData theme) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        theme.colorScheme.primary.withOpacity(0.25),
        Colors.white.withOpacity(0.80),
        Colors.white.withOpacity(0.60),
      ],
      stops: const [0.0, 0.55, 1.0],
    ),
    border: Border(
      top: BorderSide(
        color: Colors.white.withOpacity(0.30),
        width: 0.5,
      ),
    ),
  );




  Widget _buildTabItem(BottomNavItem item) {
    final bool isSelected = _currentTab == item;
    final theme = Theme.of(context);

    Widget iconWidget;
    if (item.unselectedAsset != null && item.selectedAsset != null) {
      final asset = isSelected ? item.selectedAsset! : item.unselectedAsset!;
      iconWidget = CommonImage(iconName: asset,size: 32,);
    } else {
      iconWidget = Icon(
        Icons.add,
        size: 32,
        color: isSelected ? theme.colorScheme.primary : Colors.grey[600],
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _currentTab = item),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
          ],
        ),
      ),
    );
  }

    Widget _buildCurrentPage() {
    switch (_currentTab) {
      case BottomNavItem.home:
        return FeedPage(scrollController: _scrollController);
      case BottomNavItem.search:
        return FollowsPages();
      case BottomNavItem.messages:
        return FollowsPages();
      case BottomNavItem.profile:
        return FollowsPages();
      case BottomNavItem.add:
        return CreateFeedPage();
    }
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
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
      },
      child: Container(
        width: 40,
        height: 30,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8), // 添加圆角
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
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
