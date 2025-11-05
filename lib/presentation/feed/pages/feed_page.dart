import 'dart:math';

import 'package:chuchu/core/account/model/userDB_isar.dart';
import 'package:chuchu/core/relayGroups/relayGroup+note.dart';
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
import '../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../core/relayGroups/relayGroup.dart';
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
  final ScrollController storiesScrollController = ScrollController();

  final Map<String,List<NoteDBISAR>> _notificationGroupNotes = {};

  bool _isInitialLoading = true;
  Map<String, ValueNotifier<RelayGroupDBISAR>> myGroupsList = {};

  ThemeData? _cachedTheme;

  // Track processed note ids to prevent duplicate handling across callbacks
  final Set<String> _seenNoteIds = <String>{};

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
    
    // Listen for group updates
    RelayGroup.sharedInstance.myGroupsUpdatedCallBack = () {
      _loadSubscriptionList();
    };
    
    _initData();
    _setupScrollListener();
  }

  void _initData() {
    _resetStoriesSection();
    _loadSubscriptionList();

    Future.delayed(Duration(milliseconds: 5000), () {
      updateNotesList(true);
    });
  }

  void _loadSubscriptionList() {
    myGroupsList = RelayGroup.sharedInstance.myGroups;
    _sortMyGroupsList();
    if(mounted){
      setState(() {});
    }
  }

  void _sortMyGroupsList() {
    final currentPubkey = Account.sharedInstance.currentPubkey;
    
    // Convert to list for sorting
    final groupsList = myGroupsList.entries.toList();
    
    // Sort the list
    groupsList.sort((a, b) {
      final groupA = a.value.value;
      final groupB = b.value.value;
      
      // Current user's group always comes first
      if (groupA.groupId == currentPubkey) return -1;
      if (groupB.groupId == currentPubkey) return 1;
      
      // Get notification counts
      final countA = _notificationGroupNotes[groupA.groupId]?.length ?? 0;
      final countB = _notificationGroupNotes[groupB.groupId]?.length ?? 0;
      
      // Sort by notification count (descending)
      return countB.compareTo(countA);
    });
    
    // Rebuild the map with sorted order
    final sortedMap = <String, ValueNotifier<RelayGroupDBISAR>>{};
    for (final entry in groupsList) {
      sortedMap[entry.key] = entry.value;
    }
    
    myGroupsList = sortedMap;
    
    // Scroll to the beginning (leftmost position) after sorting
    _scrollToBeginning();
  }

  void _scrollToBeginning() {
    if (storiesScrollController.hasClients) {
      storiesScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
    myGroupsList = {};
    _allNotesFromDBLastTimestamp = null;
    _seenNoteIds.clear();
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


  void _clearAvatarBorders() {
    if (mounted) {
      setState(() {
      });
    }
  }

  void _setInitialLoadingFalse() {
    if (mounted) {
      setState(() => _isInitialLoading = false);
    }
  }

  void _handleNewNotesAfterNavigation(RelayGroupDBISAR relayGroupDB, bool hasNewNotes) {
    if (mounted) {
      // Mark current group's notifications as seen to prevent reappearing
      final cleared = _notificationGroupNotes[relayGroupDB.groupId] ?? [];
      for (final note in cleared) {
        _seenNoteIds.add(note.noteId);
      }
      _notificationGroupNotes[relayGroupDB.groupId] = [];
      // Re-sort the groups list after clearing notifications
      _sortMyGroupsList();
      setState(() {});
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
      ).setPaddingOnly(bottom: 100.0),
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
      return Column(
        children: [
          SizedBox(height: 100),
          CommonImage(iconName: 'no_feed.png', size: 150),
          Text('No Content', style: Theme.of(context).textTheme.titleLarge),
        ],
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
        // Use noteId as key to prevent widget reuse issues
        final key = notedUIModel?.noteDB.noteId ?? 'note_$index';
        return FeedWidget(
          key: ValueKey(key),
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
        ).setPadding(EdgeInsets.only(bottom: 12.0));
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
                        controller: storiesScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: myGroupsList.length + 1,
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
    if(index == myGroupsList.length) {
      return _buildAddStoryItem();
    }
    return _buildMyGroupStoryItem(index);
  }

  Widget _buildMyGroupStoryItem(int userIndex) {
    RelayGroupDBISAR relayGroupDB = myGroupsList.values.toList()[userIndex].value;
    bool hasNewNotes =  _notificationGroupNotes[relayGroupDB.groupId]?.isNotEmpty ?? false;
    final noteCount = _notificationGroupNotes[relayGroupDB.groupId]?.length ?? 0;

    return GestureDetector(
      onTap: () async {
        await ChuChuNavigator.pushPage(
          context,
          (context) => FeedPersonalPage(relayGroupDB: relayGroupDB),
        );
        updateNotesList(true);
        _handleNewNotesAfterNavigation(relayGroupDB,hasNewNotes);
      },
      child: _buildStoryItem(
        relayGroup: relayGroupDB,
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
        isCurrentUser: false,
        hasUnread: false,
        marginRight: 12,
        storyCount: 0,
        isAddButton: true,
      ),
    );
  }

  Widget _buildStoryItem({
    RelayGroupDBISAR? relayGroup,
    required bool isCurrentUser,
    required bool hasUnread,
    double marginRight = 0,
    int storyCount = 0,
    bool isAddButton = false,
  }) {
    final theme = Theme.of(context);

    int noteCount = _notificationGroupNotes[relayGroup?.groupId]?.length ?? 0;

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
              :
          ValueListenableBuilder<UserDBISAR>(
            valueListenable: Account.sharedInstance.getUserNotifier(
              relayGroup?.groupId ?? '',
            ),
            builder: (context, user, child) {
              return  StoryCircle(
                imageUrl: user.picture ?? '',
                size: avatarSize.toDouble(),
                segmentCount: noteCount > 0 ? noteCount : 0,
                gapRatio: 0.1,
              );
            },
          ),

          const SizedBox(height: 8),
          Text(
            relayGroup?.name ?? 'Add',
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

    // Clear the callback
    RelayGroup.sharedInstance.myGroupsUpdatedCallBack = null;

    final scrollController = widget.scrollController ?? feedScrollController;
    scrollController.removeListener(_onScroll);

    super.dispose();
  }

  Future<void> updateNotesList(bool isInit) async {
    if (isInit && notesList.isEmpty) {
      setState(() => _isInitialLoading = true);
    }

    if (isInit) {
      _clearAvatarBorders();
    }

    try {
      // List<NoteDBISAR> list = await _getNoteTypeToDB(isInit);
      List<NoteDBISAR> list = await RelayGroup.sharedInstance.loadGroupNotesFromDB(
          Account.sharedInstance.currentPubkey,
          until: isInit ? null : _allNotesFromDBLastTimestamp,
          limit: _limit) ??
          [];
      if (list.isEmpty) {
        isInit
            ? refreshController.refreshCompleted()
            : refreshController.loadNoData();

        if (isInit) {
          _setInitialLoadingFalse();
        }

        return;
      }

      List<NoteDBISAR> showList = _filterNotes(list);
      _updateUI(showList, isInit, list.length);

      if (list.length < _limit) {
        refreshController.loadNoData();
      }
    } catch (e) {
      debugPrint('Error loading notes: $e');
      refreshController.loadFailed();
      _setInitialLoadingFalse();
    }
  }

  List<NoteDBISAR> _filterNotes(List<NoteDBISAR> list) {

    return list
        .where((NoteDBISAR note) => !note.isReaction && (note.root == null || note.root!.isEmpty))
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
    // Only process notes that haven't been seen yet (by noteId)
    final List<NoteDBISAR> incremental = notes
        .where((n) => !_seenNoteIds.contains(n.noteId))
        .toList(growable: false);

    if (incremental.isEmpty) return;

    _seenNoteIds.addAll(incremental.map((n) => n.noteId));
    _notificationUpdateNotes(incremental);
  }

  void _notificationUpdateNotes(List<NoteDBISAR> notes) async {
    if (notes.isEmpty || !mounted) return;

    try {
      if (mounted) {
        Future.microtask(() {
          if (mounted) {
            for (NoteDBISAR noteDB in notes) {
              bool isGroupNoted = noteDB.groupId.isNotEmpty;
              if (isGroupNoted) {
                if(_notificationGroupNotes[noteDB.groupId] == null){
                  _notificationGroupNotes[noteDB.groupId] = [noteDB];
                }else{
                  _notificationGroupNotes[noteDB.groupId] = [... _notificationGroupNotes[noteDB.groupId]!,noteDB];
                }
              }
            }
            // Re-sort the groups list after updating notifications
            _sortMyGroupsList();
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
              imageUrl: imageUrl,
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
      // Base sector angle per segment
      final double sector = (2 * pi) / segmentCount;
      // Make the gap grow with segmentCount, so more segments -> larger gaps
      // gapAngle is absolute radians, clamped below the sector size
      final double baseGapAngle = sector * gapRatio; // start from provided ratio
      final double growthPerSegment = 0.03; // gentler growth (~1.7° per extra segment)
      final double gapAngle = (baseGapAngle + growthPerSegment * (segmentCount - 1))
          .clamp(0.0, sector * 0.6);

      final double minSweep = 0.06; // ensure each segment still visible (~3.4°)
      final double sweep = (sector - gapAngle).clamp(minSweep, sector);

      for (int i = 0; i < segmentCount; i++) {
        final double startAngle = sector * i;
        canvas.drawArc(rect, startAngle, sweep, false, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is _SegmentedBorderPainter) {
      return oldDelegate.segmentCount != segmentCount ||
          oldDelegate.gapRatio != gapRatio ||
          oldDelegate.isShowBorder != isShowBorder;
    }
    return true;
  }

}
