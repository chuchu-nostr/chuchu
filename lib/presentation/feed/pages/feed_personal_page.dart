import 'package:cached_network_image/cached_network_image.dart';
import 'package:chuchu/core/account/account+follows.dart';
import 'package:chuchu/core/feed/feed+load.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/data/models/feed_extension_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/feed/feed.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../core/widgets/chuchu_smart_refresher.dart';
import '../../../core/widgets/common_image.dart';
import '../../../data/models/noted_ui_model.dart';
import '../widgets/feed_skeleton_widget.dart';
import '../widgets/feed_widget.dart';
import 'feed_info_page.dart';

class FeedPersonalPage extends StatefulWidget {
  final String userPubkey;
  const FeedPersonalPage({super.key, required this.userPubkey});

  @override
  State<FeedPersonalPage> createState() => _FeedPersonalPageState();
}

class _FeedPersonalPageState extends State<FeedPersonalPage> {
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController();
  bool _isInitialLoading = true;
  List<NotedUIModel?> notesList = [];
  final int _limit = 1000;
  int? _allNotesFromDBLastTimestamp;
  bool _isFollowing = false;

  bool _showAppBar = false;
  static const double _triggerOffset = 100;

  @override
  void initState() {
    super.initState();
    _setStatusBarStyle();
    updateNotesList(true);
    _checkFollowing();

    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.offset > _triggerOffset && !_showAppBar) {
      setState(() => _showAppBar = true);
    } else if (_scrollController.offset <= _triggerOffset && _showAppBar) {
      setState(() => _showAppBar = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _setStatusBarStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _showAppBar
              ? PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: _PinnedNavBar(
                  userName: Account.sharedInstance.getUserNotifier(
                    widget.userPubkey,
                  ).value.name ?? '--',
                  onBack: () => Navigator.of(context).pop(),
                  onMore: () {},
                ),
              )
              : null,
      body: _buildSmartRefresher(),
    );
  }

  Widget _buildSmartRefresher() {
    return ChuChuSmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: () => updateNotesList(true),
      onLoading: () => updateNotesList(false),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount:
            _isInitialLoading
                ? 8
                : (notesList.isEmpty ? 1 : notesList.length + 2),
        itemBuilder: _buildListItem,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    // Placeholder to push content down and avoid overlap with status bar
    if (index == 0) return const SizedBox.shrink();

    // Original logic, remember to subtract 1 from all indices
    final adj = index - 1;

    // Skeleton
    if (_isInitialLoading) {
      return adj < 8 ? const FeedSkeletonWidget() : const SizedBox.shrink();
    }

    // Empty data
    if (notesList.isEmpty) {
      return adj == 0
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              CommonImage(iconName: 'no_feed.png', size: 350),
              Text('No Content', style: Theme.of(context).textTheme.titleLarge),
            ],
          )
          : const SizedBox.shrink();
    }

    // First item: Header + Stats + Profile
    if (adj == 0) {
      return ValueListenableBuilder<UserDBISAR>(
        valueListenable: Account.sharedInstance.getUserNotifier(
          widget.userPubkey,
        ),
        builder: (context, user, child) {
          return         Column(
            children: [
              _PersonalPageHeader(
                userPubkey: widget.userPubkey,
                isShowAppBar:_showAppBar,
                userName: user.name ?? '--',
                onBackPressed: () => ChuChuNavigator.pop(context),
                onMorePressed: () {},
              ),
              _PersonalPageStats(
                userPubkey: widget.userPubkey,
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
              Container(
                margin: EdgeInsets.only(top: 12,bottom: 20),
                padding: EdgeInsets.only(
                  bottom: 20,
                  left: 18,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 10,
                      color: Color(0xFFF7F7F7),
                    )
                  ),
                ),
                width: double.infinity,
                child: Text(
                    user.about ?? '',
                  style: TextStyle(

                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    // Feed Item (index - 1)
    final notedUIModel = notesList[adj - 1];
    return FeedWidget(
      isShowReplyWidget: true,
      feedWidgetLayout: EFeedWidgetLayout.fullScreen,
      notedUIModel: notedUIModel,
      clickMomentCallback:
          (m) => ChuChuNavigator.pushPage(
            context,
            (_) => FeedInfoPage(notedUIModel: m),
          ),
    ).setPadding(const EdgeInsets.only(left: 16, right: 16, bottom: 12));
  }

  Future<void> updateNotesList(bool isInit) async {
    if (isInit && notesList.isEmpty) {
      setState(() {
        _isInitialLoading = true;
      });
    }

    try {
      List<NoteDBISAR> list = await _getNoteTypeToDB(isInit);
      if (list.isEmpty) {
        if (isInit) {
          _refreshController.refreshCompleted();
          setState(() {
            _isInitialLoading = false;
            notesList = [];
          });
        } else {
          _refreshController.loadNoData();
        }

        if (!isInit) await _getNotesFromRelay();
        return;
      }

      List<NoteDBISAR> showList = _filterNotes(list);
      _updateUI(showList, isInit, list.length);

      if (list.length < _limit) {
        if (!isInit) {
          await _getNotesFromRelay();
        } else {
          _refreshController.loadNoData();
        }
      }
    } catch (e) {
      debugPrint('Error loading notes: $e');
      _refreshController.loadFailed();
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  Future<List<NoteDBISAR>> _getNoteTypeToDB(bool isInit) async {
    try {
      int? until = isInit ? null : _allNotesFromDBLastTimestamp;
      List<NoteDBISAR>? result = await Feed.sharedInstance.loadUserNotesFromDB(
        [widget.userPubkey],
        until: until,
        limit: _limit,
      );
      return result ?? [];
    } catch (e) {
      debugPrint('Error loading notes from DB: $e');
      return [];
    }
  }

  Future<List<NoteDBISAR>> _getNoteTypeToRelay() async {
    try {
      List<NoteDBISAR>? result = await Feed.sharedInstance
          .loadNewNotesFromRelay(
            authors: [widget.userPubkey],
            until: _allNotesFromDBLastTimestamp,
            limit: _limit,
          );
      return result ?? [];
    } catch (e) {
      debugPrint('Error loading notes from relay: $e');
      return [];
    }
  }

  Future<void> _getNotesFromRelay() async {
    try {
      List<NoteDBISAR> list = await _getNoteTypeToRelay();

      if (list.isEmpty) {
        _refreshController.loadNoData();
        if (_isInitialLoading) {
          setState(() {
            _isInitialLoading = false;
          });
        }
        return;
      }

      List<NoteDBISAR> showList = _filterNotes(list);
      _updateUI(showList, false, list.length);
    } catch (e) {
      debugPrint('Error loading notes from relay: $e');
      _refreshController.loadFailed();
      if (_isInitialLoading) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  List<NoteDBISAR> _filterNotes(List<NoteDBISAR> list) {
    if (list.isEmpty) return [];

    return list
        .where(
          (NoteDBISAR note) => !note.isReaction && note.getReplyLevel(null) < 2,
        )
        .toList();
  }

  void _updateUI(List<NoteDBISAR> showList, bool isInit, int fetchedCount) {
    if (showList.isEmpty) {
      if (isInit) {
        notesList = [];
      }
      _refreshController.refreshCompleted();
      if (_isInitialLoading) {
        _isInitialLoading = false;
      }
      setState(() {});
      return;
    }

    List<NotedUIModel?> list =
        showList.map((item) => NotedUIModel(noteDB: item)).toList();

    if (isInit) {
      notesList = list;
    } else {
      notesList.addAll(list);
    }

    if (showList.isNotEmpty) {
      _allNotesFromDBLastTimestamp = showList.last.createAt;
    }

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

  Future<void> _checkFollowing() async {
    try {
      bool f = await Account.sharedInstance.onFollowingList(widget.userPubkey);
      if (mounted) {
        setState(() {
          _isFollowing = f;
        });
      }
    } catch (e) {
      debugPrint('Error checking following status: $e');
    }
  }


}

// Internal data model for personal statistics
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

// Internal header widget
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
            image: (badgeUrl.isNotEmpty)
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

  Widget _buildNavigationBar() {
    return Container(
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: onBackPressed,
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 8),
          // User name and verified badge
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
          // More options button
          IconButton(
            onPressed: onMorePressed,
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.only(left: 50),
      child: Row(
        children: [
          // Images/Views stat
          _buildStatItem(icon: Icons.landscape, value: '1.4K'),
          const SizedBox(width: 16),
          _buildDot(),
          const SizedBox(width: 16),

          // Videos stat
          _buildStatItem(icon: Icons.videocam, value: '334'),
          const SizedBox(width: 16),
          _buildDot(),
          const SizedBox(width: 16),

          // Likes stat
          _buildStatItem(icon: Icons.favorite, value: '621K'),
        ],
      ),
    );
  }

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

// Internal stats widget
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
        children: [_buildProfileImage(), _buildActionsRow()],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Positioned(
      top: -35,
      left: 18,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: ValueListenableBuilder<UserDBISAR>(
          valueListenable: Account.sharedInstance.getUserNotifier(userPubkey),
          builder: (context, user, child) {
            return Container(
              width: 80,
              height: 80,
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
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionsRow() {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 8),
      child: Row(
        children: [const Expanded(child: SizedBox()), const _PersonalPageActions()],
      ),
    );
  }
}

// Internal actions widget
class _PersonalPageActions extends StatelessWidget {
  const _PersonalPageActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Dollar sign icon
        _buildIconButton(
          iconName: 'zaps_blue_icon.png',
          onTap: () {
            // Handle dollar sign tap
          },
        ),

        // Star icon
        _buildIconButton(
          iconName: 'favorite_blue_icon.png',
          onTap: () {
            // Handle star tap
          },
        ),

        // Share icon
        _buildIconButton(
          iconName: 'share_blue_icon.png',
          onTap: () {
            // Handle share tap
          },
        ),
      ],
    );
  }

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
          child: CommonImage(
            iconName: iconName,
            size: 24,
          ),
        ),
      ),
    );
  }
}

// Internal profile widget
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

class _PinnedNavBar extends StatelessWidget {
  final String userName;
  final VoidCallback onBack;
  final VoidCallback onMore;
  const _PinnedNavBar({
    required this.userName,
    required this.onBack,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      height: kToolbarHeight + top,
      padding: EdgeInsets.only(top: top),
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBack,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: onMore,
          ),
        ],
      ),
    );
  }
}
