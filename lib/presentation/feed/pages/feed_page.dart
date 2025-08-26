import 'package:chuchu/core/account/model/userDB_isar.dart';
import 'package:chuchu/core/utils/adapt.dart';
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
import '../../../core/utils/feed_utils.dart';
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
  List<UserDBISAR> _showNotedToUserList = [];
  int _newNotesCount = 0;

  ThemeData? _cachedTheme;

  double avatarSize = 72;
  double storyItemWidth = 82;
  double storyItemHeight = 128;
  
  static const double kStoriesSectionHeight = 148.0;
  bool _isStoriesVisible = true;
  double _storiesHeight = kStoriesSectionHeight;
  double _storiesOpacity = 1.0;


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
    
    Future.delayed(Duration(milliseconds: 5000), () {
      updateNotesList(true);
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
        _storiesOpacity = 0.0;
      });
      print('Stories hidden, height: $_storiesHeight');
    } else if (scrollOffset <= threshold && !_isStoriesVisible) {
      setState(() {
        _isStoriesVisible = true;
        _storiesHeight = kStoriesSectionHeight;
        _storiesOpacity = 1.0;
      });
      print('Stories shown, height: $_storiesHeight');
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
        _storiesOpacity = 1.0;
      });
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
        itemBuilder:
            (context, index) =>
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
            padding: EdgeInsets.only(
              bottom: 16
            ),
            margin: EdgeInsets.only(
              bottom: 10
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withAlpha(80), width: 0.5)),
            ),
            child: _isStoriesVisible ? RepaintBoundary(
              child: SizedBox(
                height: kStoriesSectionHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _showNotedToUserList.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: (){
                          ChuChuNavigator.pushPage(
                            context,
                                (context) => FeedPersonalPage(
                              userPubkey: Account.sharedInstance.currentPubkey ?? '',
                            ),
                          );
                        },
                        child: _buildStoryItem(
                          name: "You",
                          imageUrl: ChuChuUserInfoManager.sharedInstance.currentUserInfo?.picture ?? '',
                          isCurrentUser: true,
                          hasUnread: false,
                          marginRight: 12,
                        ),
                      );
                    } else if (index == _showNotedToUserList.length + 1) {
                      return _buildAddStoryItem();
                    } else {
                      final user = _showNotedToUserList[index - 1];
                      return _buildStoryItem(
                        name: user.name ?? '',
                        imageUrl: user.picture ?? '',
                        isCurrentUser: false,
                        hasUnread: true,
                        marginRight: 12,
                      );
                    }
                  },
                ),
              ),
            ) : SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
  Widget _buildAddStoryItem() {
    return GestureDetector(
      onTap: (){
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
    int storyCount = 3,
    bool isAddButton = false,
  }) {
    final theme = Theme.of(context);
    final hasStory = hasUnread && storyCount > 0;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: storyItemHeight,
        maxHeight: storyItemHeight,
        minWidth: storyItemWidth,
        maxWidth: storyItemWidth,
      ),
      child: Container(
        width: storyItemWidth,
        height: storyItemHeight,
        margin: EdgeInsets.only(right: marginRight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (hasStory)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: SegmentedCirclePainter(
                          segmentCount: storyCount,
                          color: Colors.blueAccent,
                          strokeWidth: 1.5,
                        ),
                      ),
                    ),
                  isAddButton
                      ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    width: avatarSize,
                    height: avatarSize,
                    child: const Icon(Icons.add, size: 28, color: Colors.black87),
                  )
                      : _buildAvatar(imageUrl),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 24,
              width: double.infinity,
              child: Text(
                name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }




  Color _getBackgroundColor(String name) {
    switch (name.toLowerCase()) {
      case 'you':
        return Colors.lightBlue[100]!;
      case 'saaik_':
        return Colors.pink[100]!;
      case 'leeesove...':
        return Colors.lightBlue[100]!;
      case 'saika_ka...':
        return Colors.grey[100]!;
      case 'honk':
        return Colors.lightBlue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Widget debugPainterPreview() {
    return Center(
      child: CustomPaint(
        painter: SegmentedCirclePainter(
          segmentCount: 5,
          strokeWidth: 4,
          color: Colors.orange,
          gapAngle: 8,
        ),
        size: Size(80, 80),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          child: ClipOval(
            child: Image.asset(
              'assets/images/icon_user_default.png',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildAvatarWidget(String imageUrl) {
    return imageUrl.isNotEmpty
        ? ChuChuCachedNetworkImage(
            imageUrl: imageUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            placeholder: (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
            errorWidget: (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(),
          )
        : Image.asset(
            'assets/images/icon_user_default.png',
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          );
  }

  Widget _buildAvatar(String imageUrl) {
    return ClipOval(
      child: SizedBox(
        width: avatarSize,
        height: avatarSize,
        child: imageUrl.isNotEmpty
            ? ChuChuCachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
          errorWidget: (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(),
        )
            : Image.asset(
          'assets/images/icon_user_default.png',
          fit: BoxFit.cover,
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
      setState(() {
        _isInitialLoading = true;
      });
    }

    try {
      List<NoteDBISAR> list = await _getNoteTypeToDB(isInit);
      if (list.isEmpty) {
        isInit
            ? refreshController.refreshCompleted()
            : refreshController.loadNoData();

        if (isInit) {
          setState(() {
            _isInitialLoading = false;
          });
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
      print('Error loading notes: $e');
      refreshController.loadFailed();
      setState(() {
        _isInitialLoading = false;
      });
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
        setState(() {
          _isInitialLoading = false;
        });
        return;
      }

      List<NoteDBISAR> showList = _filterNotes(list);
      _updateUI(showList, false, list.length);
    } catch (e) {
      print('Error loading notes from relay: $e');
      refreshController.loadFailed();
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  List<NoteDBISAR> _filterNotes(List<NoteDBISAR> list) {
    return list
        .where(
          (NoteDBISAR note) => !note.isReaction && note.getReplyLevel(null) < 2,
        )
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
      final List<UserDBISAR> users = await FeedUtils.getUserList(
        notes.map((e) => e.author).toSet().toList(),
      );

      if (mounted) {
        Future.microtask(() {
          if (mounted) {
            _showNotedToUserList = users;
            _newNotesCount = notes.length;
            setState(() {});
          }
        });
      }
    } catch (e) {
      print('Error updating notification notes: $e');
    }
  }

  @override
  didNewNotificationCallBack(List<NotificationDBISAR> notifications) {
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    _initData();
  }

  @override
  void didLogout() {
    _resetData();
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
  }
}

class SegmentedCirclePainter extends CustomPainter {
  final int segmentCount;
  final double strokeWidth;
  final Color color;
  final double gapAngle;

  SegmentedCirclePainter({
    required this.segmentCount,
    this.strokeWidth = 1.5,
    this.color = Colors.blue,
    this.gapAngle = 6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2 - strokeWidth / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final double sweep = (360 - gapAngle * segmentCount) / segmentCount;

    for (int i = 0; i < segmentCount; i++) {
      final startAngle = radians(i * (sweep + gapAngle));
      canvas.drawArc(rect, startAngle, radians(sweep), false, paint);
    }
  }

  double radians(double degree) => degree * 3.1415926535 / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
