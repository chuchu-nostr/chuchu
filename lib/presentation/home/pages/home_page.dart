import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:chuchu/presentation/drawerMenu/follows/pages/follows_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../core/account/account.dart';
import '../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../drawerMenu/subscription/pages/subscription_settings_page.dart';
import '../../feed/pages/create_feed_page.dart';
import '../../feed/pages/feed_notifications_page.dart';

import '../widgets/drawer_menu.dart';
import '../../feed/pages/feed_page.dart';
import '../../../core/manager/chuchu_feed_manager.dart';
import '../../../core/feed/model/notificationDB_isar.dart';
import '../../../core/feed/model/noteDB_isar.dart';


enum BottomNavItem {
  home(
    selectedAsset: 'home_select_icon.png',
    unselectedAsset: 'home_icon.png',
  ),
  // search(
  //   selectedAsset: 'search_select_icon.png',
  //   unselectedAsset: 'search_icon.png',
  // ),
  add(
    selectedAsset: 'reply_select_icon.png',
    unselectedAsset: 'reply.png',
  ),
  // messages(
  //   selectedAsset: 'reply_select_icon.png',
  //   unselectedAsset: 'reply.png',
  // ),
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



  void _showProfileDrawer() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation1,
            curve: Curves.easeInOut,
          )),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height,
              child: DrawerMenu(),
            ),
          ),
        );
      },
    );
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
    return Scaffold(
      appBar: _buildAppBar(context),

      body: Stack(
        children: [
          _buildCurrentPage(),

          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomNavigationBar(context),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (_currentTab) {
      case BottomNavItem.home:
        return AppBar(
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.primary,
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
                        (context) => FeedNotificationsPage(),
                      );
                    },
                    child: CommonImage(
                      iconName: 'notification.png',
                      size: 24,
                    ),
                  ).setPaddingOnly(right: 12.0),
                ],
              ),
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        );
        
      // case BottomNavItem.search:
      //   return null;
        
      // case BottomNavItem.messages:
      //   return AppBar(
      //     backgroundColor: theme.colorScheme.surface,
      //     elevation: 0,
      //     title: Text(
      //       'Messages',
      //       style: theme.textTheme.headlineMedium?.copyWith(
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //     actions: [
      //       IconButton(
      //         icon: Icon(Icons.edit, color: theme.colorScheme.onSurface),
      //         onPressed: () {
      //           // Handle new message
      //         },
      //       ),
      //     ],
      //   );
      //
      case BottomNavItem.profile:
        return AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          title: Text(
            'Profile',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: theme.colorScheme.onSurface),
              onPressed: () {
                // Handle settings
              },
            ),
          ],
        );
        
      case BottomNavItem.add:
        return AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          title: Text(
            'Create Post',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
            onPressed: () {
              setState(() {
                _currentTab = BottomNavItem.home;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle post creation
              },
              child: Text(
                'Post',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme       = Theme.of(context);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    const double barHeight  = 66;
    const double floatGap   = 24;
    const double sideMargin = 0;

    return Padding(
      padding: EdgeInsets.only(
        left   : sideMargin,
        right  : sideMargin,
        bottom : bottomInset + floatGap,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Container(
            height: barHeight,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.20),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final item in [BottomNavItem.home])
                  _buildTabItem(item),
                _buildAddButton(),
                for (final item in [BottomNavItem.profile])
                  _buildTabItem(item),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildTabItem(BottomNavItem item) {
    final bool isSelected = _currentTab == item && item != BottomNavItem.profile;
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
      onTap: () {
        if (item == BottomNavItem.profile) {
          // Show drawer menu from right side for profile tab
          _showProfileDrawer();
        } else {
          setState(() => _currentTab = item);
        }
      },
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
    return IndexedStack(
      index: _currentTab.index,
      children: [
        FeedPage(scrollController: _scrollController),
        FollowsPages(),
        FollowsPages(),
        Container(), // Placeholder for profile - will show drawer instead
        CreateFeedPage(),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        Map<String, ValueNotifier<RelayGroupDBISAR>>? groups = RelayGroup.sharedInstance.myGroups;

        bool isCreate = groups[Account.sharedInstance.currentPubkey] != null;
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => isCreate ? CreateFeedPage() : SubscriptionSettingsPage(),
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
          borderRadius: BorderRadius.circular(8),
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
