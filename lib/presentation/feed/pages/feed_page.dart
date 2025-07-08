import 'package:chuchu/core/account/model/userDB_isar.dart';
import 'package:chuchu/core/utils/adapt.dart';
import 'package:flutter/material.dart';

import 'package:chuchu/core/feed/feed+load.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:chuchu/data/models/feed_extension_model.dart';

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

import '../widgets/feed_widget.dart';
import '../widgets/feed_skeleton_widget.dart';
import 'feed_info_page.dart';

class FeedPage extends StatefulWidget {
  final ScrollController? scrollController;
  
  const FeedPage({super.key, this.scrollController});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin, ChuChuUserInfoObserver, ChuChuFeedObserver{
  List<NotedUIModel?> notesList = [];
  final int _limit = 1000;
  int? _allNotesFromDBLastTimestamp;

  final ScrollController feedScrollController = ScrollController();
  final RefreshController refreshController = RefreshController();

  bool _isInitialLoading = true;
  List<UserDBISAR> _showNotedToUserList = [];
  int _newNotesCount = 0;

  @override
  void initState() {
    super.initState();
    ChuChuUserInfoManager.sharedInstance.addObserver(this);
    ChuChuFeedManager.sharedInstance.addObserver(this);
    _initData();
  }

  void _initData(){
    Future.delayed(Duration(milliseconds: 5000), () {
      updateNotesList(true);
    });
  }


  void _resetData(){
    notesList = [];
    _allNotesFromDBLastTimestamp = null;
    _newNotesCount = 0;
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (notesList.isNotEmpty && _showNotedToUserList.isNotEmpty) _buildTopStoriesSection(),
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
        itemBuilder: (context, index) => const FeedSkeletonWidget(),
      );
    }

    if (notesList.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 100,
          ),
          CommonImage(iconName: 'no_feed.png', size: 350),
          Text('No Content',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      );
    }

    return ListView.builder(
      primary: false,
      controller: null,
      shrinkWrap: false,
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        NotedUIModel? notedUIModel = notesList[index];
        return FeedWidget(
          isShowReplyWidget: true,
          notedUIModel: notedUIModel,
          clickMomentCallback: (NotedUIModel? notedUIModel) async {
            await ChuChuNavigator.pushPage(
              context,
              (context) => FeedInfoPage(notedUIModel: notedUIModel),
            );
          },
        ).setPadding(EdgeInsets.only(left: 16.0,right: 16.0, bottom: 12.0));
      },
    );
  }

  Widget _buildTopStoriesSection() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _handleNewNotesClick();
      },
      child: Container(
        width: double.infinity,
        height: 121,
        padding: EdgeInsets.symmetric(vertical: 16),
        margin: EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withAlpha(80),
                    width: 0.5,
                ),
            ),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: _showNotedToUserList.length,
          itemBuilder: (context, index) {
           return _buildNewNotesIndicator(index);
          },
        ),
      ),
    );
  }



  Widget _buildNewNotesIndicator(int index) {
    final theme = Theme.of(context);
    
    return Container(
      width: 80,
      margin: EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Stack(
            children: [
              _buildAvatarWidget(imageUrl:  _showNotedToUserList[index].picture ?? ''),
              if (_newNotesCount > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                    child: Text(
                      _newNotesCount > 99 ? '99+' : _newNotesCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            _showNotedToUserList[index].name ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWidget({String? imageUrl}) {
    return GestureDetector(
      onTap: (){
      },
      child: FeedWidgetsUtils.clipImage(
        borderRadius: 64.px,
        imageSize: 64.px,
        child: ChuChuCachedNetworkImage(
          imageUrl: imageUrl ?? '',
          fit: BoxFit.cover,
          placeholder: (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
          errorWidget: (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(),
          width: 64.px,
          height: 64.px,
        ),
      ),
    );

  }

  void _handleNewNotesClick() {
    _showNotedToUserList = [];
    _newNotesCount = 0;
    setState(() {});

    // 滚动到顶部
    final scrollController = widget.scrollController ?? feedScrollController;
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    updateNotesList(true);
  }


  @override
  void dispose() {
    ChuChuUserInfoManager.sharedInstance.removeObserver(this);
    ChuChuFeedManager.sharedInstance.removeObserver(this);
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
    List<NotedUIModel?> list =
        showList.map((item) => NotedUIModel(noteDB: item)).toList();
    if (isInit) {
      notesList = list;
    } else {
      notesList.addAll(list);
    }

    _allNotesFromDBLastTimestamp = showList.last.createAt;

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

    setState(() {});
  }

  @override
  didNewNotesCallBackCallBack(List<NoteDBISAR> notes) {
    _notificationUpdateNotes(notes);
  }

  void _notificationUpdateNotes(List<NoteDBISAR> notes) async {
    if (notes.isEmpty) return;

    List<UserDBISAR> users = await FeedUtils.getUserList(
        notes.map((e) => e.author).toSet().toList());

    _showNotedToUserList = users;
    if(mounted){
      setState(() {});
    }
  }

  @override
  didNewNotificationCallBack(List<NotificationDBISAR> notifications) {
    // _updateNotifications(notifications);
    // tipContainerHeight.value = tipsHeight;
  }


  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    // TODO: implement didLoginSuccess
    _initData();
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
    _resetData();
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    // TODO: implement didSwitchUser
  }
}
