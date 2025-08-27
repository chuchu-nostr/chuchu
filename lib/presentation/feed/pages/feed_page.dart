import 'dart:math';

import 'package:chuchu/core/account/model/userDB_isar.dart';
import 'package:flutter/material.dart';

import 'package:chuchu/core/feed/feed+load.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:chuchu/data/models/feed_extension_model.dart';

import '../../../core/account/account.dart';
import '../../../core/feed/feed.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import '../../../core/feed/model/notificationDB_isar.dart';
import '../../../core/manager/chuchu_feed_manager.dart';
import '../../../core/manager/chuchu_user_info_manager.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../core/widgets/chuchu_smart_refresher.dart';
import '../../../data/models/noted_ui_model.dart';

import '../../search/pages/search_page.dart';
import '../widgets/feed_widget.dart';
import '../widgets/feed_skeleton_widget.dart';
import 'feed_info_page.dart';
import 'feed_personal_page.dart';

class FeedPage extends StatefulWidget {
  final ScrollController? scrollController;

  const FeedPage({super.key, this.scrollController});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with
        SingleTickerProviderStateMixin,
        ChuChuUserInfoObserver,
        ChuChuFeedObserver {
  List<NotedUIModel?> notesList = [];
  final int _limit = 1000;
  int? _allNotesFromDBLastTimestamp;

  final ScrollController feedScrollController = ScrollController();
  final RefreshController refreshController = RefreshController();

  bool _isInitialLoading = true;
  List<String> _followsList = [];
  int _newNotesCount = 0;
  Set<String> _usersWithNewNotes = {};
  Map<String, int> _userNoteCounts = {};

  ThemeData? _cachedTheme;

  double avatarSize = 80;
  double storyItemWidth = 85;
  double storyItemHeight = 128;

  static const double kStoriesSectionHeight = 148.0;
  bool _isStoriesVisible = true;
  double _storiesHeight = kStoriesSectionHeight;

  @override
  void initState() {
    super.initState();
    ChuChuUserInfoManager.sharedInstance.addObserver(this);
    ChuChuFeedManager.sharedInstance.addObserver(this);
    _initData();
    _setupScrollListener();
  }

  void _initData() {
    _resetStoriesSection();
    _loadFollowsList();

    Future.delayed(Duration(milliseconds: 5000), () {
      updateNotesList(true);
    });
  }

  void _loadFollowsList() {
    final List<String> followings = List<String>.from(
      Account.sharedInstance.me?.followingList ?? [],
    );
    setState(() {
      _followsList = followings;
    });
  }

  void _setupScrollListener() {
    final scrollController = widget.scrollController ?? feedScrollController;
    scrollController.addListener(_onScroll);
  }

  bool _isScrollProcessing = false;

  void _onScroll() {
    if (!mounted || _isScrollProcessing) return;

    _isScrollProcessing = true;

    final scrollController = widget.scrollController ?? feedScrollController;
    final scrollOffset = scrollController.offset;
    final threshold = 50.0;

    if (scrollOffset > threshold && _isStoriesVisible) {
      setState(() {
        _isStoriesVisible = false;
        _storiesHeight = 0.0;
      });
    } else if (scrollOffset <= threshold && !_isStoriesVisible) {
      setState(() {
        _isStoriesVisible = true;
        _storiesHeight = kStoriesSectionHeight;
      });
    }

    Future.delayed(Duration(milliseconds: 100), () {
      _isScrollProcessing = false;
    });
  }

  void _resetData() {
    notesList = [];
    _allNotesFromDBLastTimestamp = null;
    _newNotesCount = 0;
    if (mounted) {
      setState(() {});
    }
  }

  void _resetStoriesSection() {
    if (mounted) {
      setState(() {
        _isStoriesVisible = true;
        _storiesHeight = kStoriesSectionHeight;
      });
    }
  }

  void _clearNewNotesIndicator(String userPubkey) {
    if (mounted) {
      setState(() {
        _usersWithNewNotes.remove(userPubkey);
      });
    }
  }

  void _setInitialLoadingFalse() {
    if (mounted) {
      setState(() => _isInitialLoading = false);
    }
  }

  void _handleNewNotesAfterNavigation(bool hasNewNotes, {bool clearUserNoteCounts = false}) {
    if (hasNewNotes && mounted) {
      if (clearUserNoteCounts) {
        _userNoteCounts.clear();
      } else {
        _usersWithNewNotes.clear();
      }
      updateNotesList(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _cachedTheme ??= Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
          _buildTopStoriesSection(),
          Expanded(
            child: ChuChuSmartRefresher(
              scrollController: widget.scrollController ?? feedScrollController,
              controller: refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () => updateNotesList(true),
              onLoading: () => updateNotesList(false),
              child: _getFeedListWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFeedListWidget() {
    if (_isInitialLoading) {
      return ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) =>
            RepaintBoundary(child: const FeedSkeletonWidget()),
      );
    }

    if (notesList.isEmpty) {
      return RepaintBoundary(
        child: Column(
          children: [
            SizedBox(height: 100),
            CommonImage(iconName: 'no_feed.png', size: 150),
            Text('No Content', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      );
    }

    return ListView.builder(
      primary: false,
      controller: null,
      shrinkWrap: false,
      itemCount: notesList.length,
      cacheExtent: 1000,
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      itemBuilder: (context, index) {
        final notedUIModel = notesList[index];
        return RepaintBoundary(
          key: ValueKey('feed_$index'),
          child: FeedWidget(
            horizontalPadding: 16,
            feedWidgetLayout: EFeedWidgetLayout.fullScreen,
            isShowReplyWidget: true,
            notedUIModel: notedUIModel,
            clickMomentCallback: (NotedUIModel? notedUIModel) async {
              await ChuChuNavigator.pushPage(
                context,
                (context) => FeedInfoPage(notedUIModel: notedUIModel),
              );
            },
          ).setPadding(EdgeInsets.only(bottom: 12.0)),
        );
      },
    );
  }

  Widget _buildTopStoriesSection() {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        height: _storiesHeight,
        child: ClipRect(
          child: Container(
            padding: EdgeInsets.only(bottom: 16),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withAlpha(80),
                  width: 0.5,
                ),
              ),
            ),
            child: _isStoriesVisible
                ? RepaintBoundary(
                    child: SizedBox(
                      height: kStoriesSectionHeight,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _followsList.length + 2,
                        itemBuilder: _buildStoryItemBuilder,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryItemBuilder(BuildContext context, int index) {
    if (index == 0) {
      return _buildCurrentUserStoryItem();
    } else if (index == _followsList.length + 1) {
      return _buildAddStoryItem();
    } else {
      return _buildFollowedUserStoryItem(index - 1);
    }
  }

  Widget _buildCurrentUserStoryItem() {
    final currentUserPubkey = Account.sharedInstance.currentPubkey;
    final hasNewNotes = currentUserPubkey != null &&
        _usersWithNewNotes.contains(currentUserPubkey);

    return GestureDetector(
      onTap: () async {
        await ChuChuNavigator.pushPage(
          context,
          (context) => FeedPersonalPage(
            userPubkey: currentUserPubkey ?? '',
          ),
        );

        _handleNewNotesAfterNavigation(hasNewNotes, clearUserNoteCounts: true);
      },
      child: _buildStoryItem(
        name: "You",
        imageUrl: ChuChuUserInfoManager.sharedInstance.currentUserInfo?.picture ?? '',
        isCurrentUser: true,
        hasUnread: hasNewNotes,
        marginRight: 12,
      ),
    );
  }

  Widget _buildFollowedUserStoryItem(int userIndex) {
    final userPubkey = _followsList[userIndex];
    final hasNewNotes = _usersWithNewNotes.contains(userPubkey);
    final noteCount = _userNoteCounts[userPubkey] ?? 0;

    return GestureDetector(
      onTap: () async {
        await ChuChuNavigator.pushPage(
          context,
          (context) => FeedPersonalPage(userPubkey: userPubkey),
        );

        _handleNewNotesAfterNavigation(hasNewNotes);
      },
      child: _buildStoryItem(
        name: userPubkey.substring(0, 8),
        imageUrl: '',
        isCurrentUser: false,
        hasUnread: hasNewNotes,
        marginRight: 12,
        storyCount: noteCount,
      ),
    );
  }

  Widget _buildAddStoryItem() {
    return GestureDetector(
      onTap: () {
        ChuChuNavigator.pushPage(context, (context) => SearchPage());
      },
      child: _buildStoryItem(
        name: "Add",
        imageUrl: "",
        isCurrentUser: false,
        hasUnread: false,
        marginRight: 12,
        storyCount: 0,
        isAddButton: true,
      ),
    );
  }

  Widget _buildStoryItem({
    required String name,
    required String imageUrl,
    required bool isCurrentUser,
    required bool hasUnread,
    double marginRight = 0,
    int storyCount = 0,
    bool isAddButton = false,
  }) {
    final theme = Theme.of(context);

    int noteCount = 0;
    if (isCurrentUser) {
      final currentUserPubkey = Account.sharedInstance.currentPubkey;
      if (currentUserPubkey != null) {
        noteCount = _userNoteCounts[currentUserPubkey] ?? 0;
      }
    } else if (hasUnread) {
      noteCount = storyCount;
    }

    return Container(
      width: storyItemWidth,
      height: storyItemHeight,
      margin: EdgeInsets.only(right: marginRight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isAddButton
              ? _buildAddButton()
              : StoryCircle(
                  imageUrl: imageUrl,
                  size: avatarSize.toDouble(),
                  segmentCount: noteCount > 0 ? noteCount : 0,
                  gapRatio: 0.1,
                ),
          const SizedBox(height: 8),
          Text(
            name,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: 15,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: avatarSize,
      height: avatarSize,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          width: avatarSize * 0.8,
          height: avatarSize * 0.8,
          child: const Icon(Icons.add, size: 28, color: Colors.black87),
        ),
      ),
    );
  }

  @override
  void dispose() {
    ChuChuUserInfoManager.sharedInstance.removeObserver(this);
    ChuChuFeedManager.sharedInstance.removeObserver(this);

    final scrollController = widget.scrollController ?? feedScrollController;
    scrollController.removeListener(_onScroll);

    super.dispose();
  }

  Future<void> updateNotesList(bool isInit) async {
    if (isInit && notesList.isEmpty) {
      setState(() => _isInitialLoading = true);
    }

    try {
      List<NoteDBISAR> list = await _getNoteTypeToDB(isInit);
      if (list.isEmpty) {
        isInit
            ? refreshController.refreshCompleted()
            : refreshController.loadNoData();

        if (isInit) {
          _setInitialLoadingFalse();
        }

        if (!isInit) await _getNotesFromRelay();
        return;
      }

      List<NoteDBISAR> showList = _filterNotes(list);
      _updateUI(showList, isInit, list.length);

      if (list.length < _limit) {
        !isInit ? await _getNotesFromRelay() : refreshController.loadNoData();
      }
    } catch (e) {
      debugPrint('Error loading notes: $e');
      refreshController.loadFailed();
      _setInitialLoadingFalse();
    }
  }

  Future<List<NoteDBISAR>> _getNoteTypeToDB(bool isInit) async {
    int? until = isInit ? null : _allNotesFromDBLastTimestamp;
    return await Feed.sharedInstance.loadAllNotesFromDB(
          until: until,
          limit: _limit,
        ) ??
        [];
  }

  Future<List<NoteDBISAR>> _getNoteTypeToRelay() async {
    return await Feed.sharedInstance.loadContactsNewNotesFromRelay(
          until: _allNotesFromDBLastTimestamp,
          limit: _limit,
        ) ??
        [];
  }

  Future<void> _getNotesFromRelay() async {
    try {
      List<NoteDBISAR> list = await _getNoteTypeToRelay();

      if (list.isEmpty) {
        refreshController.loadNoData();
        _setInitialLoadingFalse();
        return;
      }

      List<NoteDBISAR> showList = _filterNotes(list);
      _updateUI(showList, false, list.length);
    } catch (e) {
      debugPrint('Error loading notes from relay: $e');
      refreshController.loadFailed();
      _setInitialLoadingFalse();
    }
  }

  List<NoteDBISAR> _filterNotes(List<NoteDBISAR> list) {
    return list
        .where((NoteDBISAR note) => !note.isReaction && note.getReplyLevel(null) < 2)
        .toList();
  }

  void _updateUI(List<NoteDBISAR> showList, bool isInit, int fetchedCount) {
    Future.microtask(() {
      if (!mounted) return;

      final List<NotedUIModel?> list =
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
        refreshController.refreshCompleted();
      } else {
        fetchedCount < _limit
            ? refreshController.loadNoData()
            : refreshController.loadComplete();
      }

      if (_isInitialLoading) {
        _isInitialLoading = false;
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  didNewNotesCallBackCallBack(List<NoteDBISAR> notes) {
    _notificationUpdateNotes(notes);
  }

  void _notificationUpdateNotes(List<NoteDBISAR> notes) async {
    if (notes.isEmpty || !mounted) return;

    try {
      final currentUserPubkey = Account.sharedInstance.currentPubkey;

      if (mounted) {
        Future.microtask(() {
          if (mounted) {
            _newNotesCount = notes.length;

            _usersWithNewNotes.clear();
            _userNoteCounts.clear();

            for (final note in notes) {
              final author = note.author;
              _usersWithNewNotes.add(author);
              _userNoteCounts[author] = (_userNoteCounts[author] ?? 0) + 1;
            }

            if (currentUserPubkey != null &&
                _usersWithNewNotes.contains(currentUserPubkey)) {
              _usersWithNewNotes.add(currentUserPubkey);
            }

            setState(() {});
          }
        });
      }
    } catch (e) {
      debugPrint('Error updating notification notes: $e');
    }
  }

  @override
  didNewNotificationCallBack(List<NotificationDBISAR> notifications) {}

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    _initData();
  }

  @override
  void didLogout() {
    _resetData();
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {}
}

class StoryCircle extends StatelessWidget {
  final String imageUrl;
  final double size;
  final int segmentCount;
  final double gapRatio;

  const StoryCircle({
    super.key,
    required this.imageUrl,
    this.size = 110,
    this.segmentCount = 0,
    this.gapRatio = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipOval(
            child: ChuChuCachedNetworkImage(
              imageUrl: imageUrl ?? '',
              fit: BoxFit.cover,
              placeholder: (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
              errorWidget: (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(),
              width: size * 0.8,
              height: size * 0.8,
            ),
          ),
          CustomPaint(
            size: Size(size, size),
            painter: _SegmentedBorderPainter(
              segmentCount: segmentCount,
              gapRatio: gapRatio,
              isShowBorder: segmentCount > 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedBorderPainter extends CustomPainter {
  final int segmentCount;
  final double gapRatio;
  final bool isShowBorder;

  _SegmentedBorderPainter({
    required this.segmentCount,
    required this.gapRatio,
    required this.isShowBorder,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 4;

    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * pi,
      colors: isShowBorder
          ? [kPrimaryBlue, kSecondaryBlue]
          : [Colors.transparent, Colors.transparent],
    );

    final rect = Rect.fromCircle(center: center, radius: outerRadius);

    final borderPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    if (segmentCount == 1) {
      canvas.drawArc(rect, 0, 2 * pi, false, borderPaint);
    } else {
      for (int i = 0; i < segmentCount; i++) {
        final startAngle = (2 * pi / segmentCount) * i;
        final sweepAngle = (2 * pi / segmentCount) * (1 - gapRatio);

        canvas.drawArc(rect, startAngle, sweepAngle, false, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
