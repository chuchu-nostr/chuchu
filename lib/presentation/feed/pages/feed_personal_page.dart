import 'package:cached_network_image/cached_network_image.dart';
import 'package:chuchu/core/feed/feed+load.dart';
import 'package:chuchu/core/relayGroups/relayGroup+note.dart';
import 'package:chuchu/data/models/feed_extension_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/feed/feed.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import '../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../core/widgets/chuchu_smart_refresher.dart';
import '../../../core/widgets/common_image.dart';
import '../../../data/models/noted_ui_model.dart';
import '../../profile/pages/profile_edit_page.dart';
import '../widgets/feed_widget.dart';
import '../widgets/unsubscribed_ui_widget.dart';
import 'feed_info_page.dart';

/// Personal feed page for displaying user's profile and content
class FeedPersonalPage extends StatefulWidget {
  final RelayGroupDBISAR relayGroupDB;

  const FeedPersonalPage({super.key, required this.relayGroupDB});

  @override
  State<FeedPersonalPage> createState() => _FeedPersonalPageState();
}

class _FeedPersonalPageState extends State<FeedPersonalPage> {
  // Controllers
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController();

  // State variables
  bool _isInitialLoading = true;
  bool _isSubscribed = false;
  bool _showAppBar = false;

  // Data
  List<NotedUIModel?> notesList = [];
  int? _allNotesFromDBLastTimestamp;

  // Constants
  static const int _limit = 1000;
  static const double _triggerOffset = 100;

  @override
  void initState() {
    super.initState();
    _initializePageData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  // Initialization methods

  /// Initialize page data and setup listeners
  void _initializePageData() {
    _setStatusBarStyle();
    _setupScrollListener();
    updateNotesList(true);
  }

  /// Setup scroll listener for app bar visibility
  void _setupScrollListener() {
    _scrollController.addListener(_handleScroll);
  }

  /// Handle scroll events for app bar visibility
  void _handleScroll() {
    final shouldShowAppBar = _scrollController.offset > _triggerOffset;
    if (shouldShowAppBar != _showAppBar) {
      setState(() => _showAppBar = shouldShowAppBar);
    }
  }

  /// Set status bar style
  void _setStatusBarStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  // Build methods

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppBar ? _buildAppBar() : null,
      body: _buildBody(),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar() {
    final top = MediaQuery.of(context).padding.top;
    final name = Account.sharedInstance.getUserNotifier(widget.relayGroupDB.author).value.name;
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
        height: kToolbarHeight + top,
        padding: EdgeInsets.only(top: top),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                name ?? '--',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  /// Build main body with smart refresher
  Widget _buildBody() {
    return ChuChuSmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: () => updateNotesList(true),
      onLoading: () => updateNotesList(false),
      child: _buildListView(),
    );
  }

  /// Build main list view
  Widget _buildListView() {
    // if(_isInitialLoading){
    //   return SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         _buildHeaderSection(),
    //         FeedSkeletonWidget()
    //       ],
    //     ),
    //   );
    // }
    //
    // if(notesList.isEmpty){
    //   return _buildEmptyListItem();
    // }
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: _calculateItemCount(),
      itemBuilder: _buildListItem,
    );
  }

  // List item building methods

  /// Calculate total item count for ListView
  int _calculateItemCount() {
    if (notesList.isEmpty) return 3; // Header + Empty state + Extra space
    return _isSubscribed ? notesList.length + 2 : 3;
  }

  /// Build individual list items
  Widget _buildListItem(BuildContext context, int index) {

    final adjustedIndex = index - 1;

    // Handle non-empty notes list
    return _buildContentListItem(adjustedIndex);
  }

  /// Build list item when notes list is empty
  Widget _buildEmptyListItem() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderSection(),
          _buildEmptyState()
        ],
      ),
    );
  }

  /// Build list item when notes list has content
  Widget _buildContentListItem(int adjustedIndex) {
    if (adjustedIndex == 0) {
      return _buildHeaderSection();
    }

    if (adjustedIndex == 1) {
      print('===asd');
      return subscriptionWidget();
    }

    // Build feed item
    final noteIndex = adjustedIndex - 2;
    if (noteIndex >= 0 && noteIndex < notesList.length) {
      return _buildFeedItem(notesList[noteIndex]);
    }

    return const SizedBox.shrink();
  }

  /// Build empty state widget
  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 100),
        CommonImage(iconName: 'no_feed.png', size: 150),
        Text('No Content', style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }

  /// Build header_isInitialLoading section with user profile
  Widget _buildHeaderSection() {
    return ValueListenableBuilder<UserDBISAR>(
      valueListenable: Account.sharedInstance.getUserNotifier(widget.relayGroupDB.author),
      builder: (context, user, child) {
        return Column(
          children: [
            _PersonalPageHeader(
              userPubkey: widget.relayGroupDB.author,
              isShowAppBar: _showAppBar,
              userName: user.name ?? '--',
              onBackPressed: () => ChuChuNavigator.pop(context),
              onMorePressed: () {
                ChuChuNavigator.pushPage(
                  context,
                  (context) => const ProfileEditPage(),
                );
              },
            ),
            _PersonalPageStats(
              userPubkey: widget.relayGroupDB.author,
              stats: const _PersonalStats(
                images: '1.4K',
                videos: '334',
                likes: '621K',
              ),
            ),
            _PersonalPageProfile(
              userName: user.name ?? '--',
              userHandle: '@${user.dns}',
            ),
          ],
        );
      },
    );
  }

  Widget subscriptionWidget(){
    print('=asdf');
    return Column(
      children: [
        _buildAboutSection('-----'),
        if (!_isSubscribed) _buildSubscriptionSection(),
        _buildTestToggleButton(),
      ],
    );
  }

  /// Build about section
  Widget _buildAboutSection(String about) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 20),
      padding: const EdgeInsets.only(bottom: 20, left: 18),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 10, color: Color(0xFFF7F7F7)),
        ),
      ),
      width: double.infinity,
      child: Text(
        about,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }

  /// Build subscription section
  Widget _buildSubscriptionSection() {
    return UnsubscribedUIWidget(
      onSubscribe: _toggleSubscription,
      onBundle3Months: _toggleSubscription,
      onBundle6Months: _toggleSubscription,
      onBundle12Months: _toggleSubscription,
      onSubscribeToSeeContent: _toggleSubscription,
    );
  }

  /// Build test toggle button for subscription state
  Widget _buildTestToggleButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ElevatedButton(
        onPressed: _toggleSubscription,
        child: Text(_isSubscribed ? 'Switch to Unsubscribed' : 'Switch to Subscribed'),
      ),
    );
  }

  /// Build individual feed item
  Widget _buildFeedItem(NotedUIModel? notedUIModel) {
    if (notedUIModel == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: FeedWidget(
        isShowReplyWidget: true,
        feedWidgetLayout: EFeedWidgetLayout.fullScreen,
        notedUIModel: notedUIModel,
        clickMomentCallback: (m) => ChuChuNavigator.pushPage(
          context,
          (_) => FeedInfoPage(notedUIModel: m),
        ),
      ),
    );
  }

  // Data loading methods

  /// Update notes list from database and relay
  Future<void> updateNotesList(bool isInit) async {
    if (isInit) {
      setState(() => _isInitialLoading = true);
    }

    try {
      final notesFromDB = await _loadNotesFromDatabase(isInit);

      if (notesFromDB.isEmpty) {
        await _handleEmptyNotesFromDB(isInit);
        return;
      }

      final filteredNotes = _filterNotes(notesFromDB);
      _updateUIWithNotes(filteredNotes, isInit, notesFromDB.length);

      // Load from relay if needed
      if (notesFromDB.length < _limit) {
        if (!isInit) {
          await _loadNotesFromRelay();
        } else {
          _refreshController.loadNoData();
        }
      }
    } catch (e) {
      _handleLoadingError(e);
    }
  }

  /// Load notes from database
  Future<List<NoteDBISAR>> _loadNotesFromDatabase(bool isInit) async {
    try {
      final until = isInit ? null : _allNotesFromDBLastTimestamp;
      final result = await RelayGroup.sharedInstance.loadGroupNotesFromDB(
        widget.relayGroupDB.author,
        until: until,
        limit: _limit,
      );
      return result ?? [];
    } catch (e) {
      debugPrint('Error loading notes from DB: $e');
      return [];
    }
  }

  /// Load notes from relay
  Future<List<NoteDBISAR>> _loadNotesFromRelay() async {
    try {
      final result = await Feed.sharedInstance.loadNewNotesFromRelay(
        authors: [widget.relayGroupDB.author],
        until: _allNotesFromDBLastTimestamp,
        limit: _limit,
      );
      return result ?? [];
    } catch (e) {
      debugPrint('Error loading notes from relay: $e');
      return [];
    }
  }

  /// Handle empty notes from database
  Future<void> _handleEmptyNotesFromDB(bool isInit) async {
    if (isInit) {
      _refreshController.refreshCompleted();
      setState(() {
        _isInitialLoading = false;
        notesList = [];
      });
    } else {
      _refreshController.loadNoData();
    }

    if (!isInit) {
      final relayNotes = await _loadNotesFromRelay();
      if (relayNotes.isNotEmpty) {
        final filteredNotes = _filterNotes(relayNotes);
        _updateUIWithNotes(filteredNotes, false, relayNotes.length);
      }
    }
  }

  /// Filter notes based on criteria
  List<NoteDBISAR> _filterNotes(List<NoteDBISAR> notes) {
    if (notes.isEmpty) return [];

    return notes
        .where((note) => !note.isReaction && note.getReplyLevel(null) < 2)
        .toList();
  }

  /// Update UI with loaded notes
  void _updateUIWithNotes(List<NoteDBISAR> filteredNotes, bool isInit, int fetchedCount) {
    if (filteredNotes.isEmpty) {
      _handleEmptyFilteredNotes(isInit);
      return;
    }

    final uiModels = filteredNotes.map((item) => NotedUIModel(noteDB: item)).toList();

    if (isInit) {
      notesList = uiModels;
    } else {
      notesList.addAll(uiModels);
    }

    // Update timestamp for pagination
    if (filteredNotes.isNotEmpty) {
      _allNotesFromDBLastTimestamp = filteredNotes.last.createAt;
    }

    // Update refresh controllers
    if (isInit) {
      _refreshController.refreshCompleted();
    } else {
      fetchedCount < _limit
          ? _refreshController.loadNoData()
          : _refreshController.loadComplete();
    }

    if (_isInitialLoading) {
      _isInitialLoading = false;
    }

    setState(() {});
  }

  /// Handle empty filtered notes
  void _handleEmptyFilteredNotes(bool isInit) {
    if (isInit) {
      notesList = [];
    }

    _refreshController.refreshCompleted();

    if (_isInitialLoading) {
      _isInitialLoading = false;
    }

    setState(() {});
  }

  /// Handle loading errors
  void _handleLoadingError(dynamic error) {
    debugPrint('Error loading notes: $error');
    _refreshController.loadFailed();
    setState(() => _isInitialLoading = false);
  }


  /// Toggle subscription state (for testing)
  void _toggleSubscription() {
    setState(() => _isSubscribed = !_isSubscribed);
  }
}

// Data models

/// Personal statistics data model
class _PersonalStats {
  final String images;
  final String videos;
  final String likes;

  const _PersonalStats({
    required this.images,
    required this.videos,
    required this.likes,
  });
}

// UI widgets

/// Personal page header with background and navigation
class _PersonalPageHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onBackPressed;
  final VoidCallback onMorePressed;
  final bool isShowAppBar;
  final String userPubkey;

  const _PersonalPageHeader({
    required this.userName,
    required this.onBackPressed,
    required this.onMorePressed,
    required this.isShowAppBar,
    required this.userPubkey,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserDBISAR>(
      valueListenable: Account.sharedInstance.getUserNotifier(userPubkey),
      builder: (context, user, _) {
        final badgeUrl = user.badges ?? '';

        return Container(
          width: double.infinity,
          height: isShowAppBar ? 150 : 220,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            image: badgeUrl.isNotEmpty
                ? DecorationImage(
                    image: CachedNetworkImageProvider(badgeUrl),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  )
                : null,
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildNavigationBar(),
                _buildStatsRow(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build navigation bar with back and more buttons
  Widget _buildNavigationBar() {
    return Row(
      children: [
        IconButton(
          onPressed: onBackPressed,
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.verified, color: Colors.white, size: 20),
            ],
          ),
        ),
        IconButton(
          onPressed: onMorePressed,
          icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
        ),
      ],
    );
  }

  /// Build stats row with images, videos, and likes count
  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.only(left: 50),
      child: Row(
        children: [
          _buildStatItem(icon: Icons.landscape, value: '1.4K'),
          const SizedBox(width: 16),
          _buildDot(),
          const SizedBox(width: 16),
          _buildStatItem(icon: Icons.videocam, value: '334'),
          const SizedBox(width: 16),
          _buildDot(),
          const SizedBox(width: 16),
          _buildStatItem(icon: Icons.favorite, value: '621K'),
        ],
      ),
    );
  }

  /// Build individual stat item
  Widget _buildStatItem({required IconData icon, required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Build dot separator
  Widget _buildDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Personal page stats section with profile image and actions
class _PersonalPageStats extends StatelessWidget {
  final _PersonalStats stats;
  final String userPubkey;

  const _PersonalPageStats({required this.stats, required this.userPubkey});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildProfileImage(),
          _buildActionsRow(),
        ],
      ),
    );
  }

  /// Build profile image with border
  Widget _buildProfileImage() {
    return Positioned(
      top: -35,
      left: 18,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: ValueListenableBuilder<UserDBISAR>(
          valueListenable: Account.sharedInstance.getUserNotifier(userPubkey),
          builder: (context, user, child) {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: GestureDetector(
                onTap: () {},
                child: FeedWidgetsUtils.clipImage(
                  borderRadius: 100,
                  imageSize: 100,
                  child: ChuChuCachedNetworkImage(
                    imageUrl: user.picture ?? '',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
                    errorWidget: (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(),
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build actions row
  Widget _buildActionsRow() {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 8),
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          _PersonalPageActions(),
        ],
      ),
    );
  }
}

/// Personal page action buttons
class _PersonalPageActions extends StatelessWidget {
  const _PersonalPageActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildIconButton(
          iconName: 'zaps_blue_icon.png',
          onTap: () {},
        ),
        _buildIconButton(
          iconName: 'favorite_blue_icon.png',
          onTap: () {},
        ),
        _buildIconButton(
          iconName: 'share_blue_icon.png',
          onTap: () {},
        ),
      ],
    );
  }

  /// Build individual icon button
  Widget _buildIconButton({
    required String iconName,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: KBorderColor, width: 1),
        ),
        child: Center(
          child: CommonImage(iconName: iconName, size: 24),
        ),
      ),
    );
  }
}

/// Personal page profile information
class _PersonalPageProfile extends StatelessWidget {
  final String userName;
  final String userHandle;

  const _PersonalPageProfile({
    required this.userName,
    required this.userHandle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 18, top: 8),
          child: Text(
            userName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 18),
          child: Text(
            userHandle,
            style: const TextStyle(color: kIconState, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
