import 'package:chuchu/core/relayGroups/relayGroup+info.dart';
import 'package:chuchu/core/relayGroups/relayGroup+note.dart';
import 'package:chuchu/data/models/feed_extension_model.dart';
import 'package:chuchu/presentation/feed/widgets/locked_content_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/account/account.dart';
import '../../../core/config/config.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import '../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_smart_refresher.dart';
import '../../../core/widgets/common_image.dart';
import '../../../data/models/noted_ui_model.dart';
import '../../profile/pages/profile_edit_page.dart';
import '../widgets/feed_personal_header_widget.dart';
import '../widgets/feed_widget.dart';
import '../widgets/subscribed_ui_widget.dart';
import 'feed_info_page.dart';

class FeedPersonalPage extends StatefulWidget {
  final RelayGroupDBISAR relayGroupDB;

  const FeedPersonalPage({super.key, required this.relayGroupDB});

  @override
  State<FeedPersonalPage> createState() => _FeedPersonalPageState();
}

class _FeedPersonalPageState extends State<FeedPersonalPage> {
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController();

  ESubscriptionStatus subscriptionStatus = ESubscriptionStatus.unsubscribed;

  bool _isShowAppBar = false;

  List<NotedUIModel?> notesList = [];
  int? _allNotesFromDBLastTimestamp;
  int? _latestNotesTimestamp;
  bool _isSyncingRemoteNotes = false;

  static const int _limit = 1000;
  static const double _triggerOffset = 100;

  @override
  void initState() {
    super.initState();
    _initializePageData();
  }

  void _initializePageData() {
    _setStatusBarStyle();
    getSubscriptionStatus();
    _scrollController.addListener(_handleScroll);
    updateNotesList(true);
  }

  void getSubscriptionStatus() async {
    String myPubkey = Account.sharedInstance.currentPubkey;
    if (widget.relayGroupDB.author == myPubkey) {
      subscriptionStatus = ESubscriptionStatus.author;
    } else {
      RelayGroupDBISAR? relayGroup = await RelayGroup.sharedInstance
          .getGroupMetadataFromRelay(
            widget.relayGroupDB.groupId,
            relay: Config.sharedInstance.recommendGroupRelays.first,
            author: widget.relayGroupDB.author,
          );
      subscriptionStatus = ESubscriptionStatus.free;
      if (relayGroup != null &&
          relayGroup.subscriptionAmount > 0 &&
          relayGroup.members != null) {
        if (relayGroup.members!.contains(
          Account.sharedInstance.currentPubkey,
        )) {
          subscriptionStatus = ESubscriptionStatus.subscribed;
        } else {
          subscriptionStatus = ESubscriptionStatus.unsubscribed;
        }
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final shouldShowAppBar = _scrollController.offset > _triggerOffset;
    if (shouldShowAppBar != _isShowAppBar) {
      setState(() => _isShowAppBar = shouldShowAppBar);
    }
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
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget? _buildAppBar() {
    if (!_isShowAppBar) return null;
    final top = MediaQuery.of(context).padding.top;
    final name =
        Account.sharedInstance
            .getUserNotifier(widget.relayGroupDB.author)
            .value
            .name;
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
            actionWidget(),
          ],
        ),
      ),
    );
  }

  Widget actionWidget() {
    if (subscriptionStatus != ESubscriptionStatus.author) {
      return const SizedBox();
    }
    return IconButton(
      onPressed: () {
        ChuChuNavigator.pushPage(
          context,
          (context) => ProfileEditPage(relayGroup: widget.relayGroupDB),
        );
      },
      icon: CommonImage(
        iconName: 'setting_icon.png',
        size: 24,
        color: Colors.white,
      ),
    );
  }

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

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: _calculateItemCount(),
      itemBuilder: _buildListItem,
    );
  }

  int _calculateItemCount() {
    if (notesList.isEmpty) return 3; // Header + subscription + content
    switch (subscriptionStatus) {
      case ESubscriptionStatus.author:
      case ESubscriptionStatus.free:
      case ESubscriptionStatus.subscribed:
        return notesList.length + 2;
      case ESubscriptionStatus.unsubscribed:
        return 3;
    }
  }

  Widget _buildListItem(BuildContext context, int index) {
    if (index == 0) {
      return Column(
        children: [
          FeedPersonalHeaderWidget(
            isShowAppBar: _isShowAppBar,
            relayGroupDB: widget.relayGroupDB,
            actionWidget: actionWidget(),
          ),
          dividerWidget(),
        ],
      );
    }

    if (index == 1) {
      if (subscriptionStatus == ESubscriptionStatus.author) {
        return const SizedBox();
      } else {
        return Column(
          children: [
            SubscribedOptionWidget(
              relayGroup: widget.relayGroupDB,
              subscriptionStatus: subscriptionStatus,
              onSubscriptionSuccess: () {
                getSubscriptionStatus();
              }
            ),
            dividerWidget(),
          ],
        );
      }
    }

    if(index == 2) {
      if(subscriptionStatus == ESubscriptionStatus.unsubscribed) {
        return LockedContentSection();
      }
      if(notesList.isEmpty){
        return _buildEmptyState();
      }
    }


    final noteIndex = index - 2;
    if (noteIndex >= 0 && noteIndex < notesList.length) {
      return Column(
        children: [
          const SizedBox(height: 20),
          _buildFeedItem(notesList[noteIndex]),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 100),
        CommonImage(iconName: 'no_feed.png', size: 150),
        Text('No Content', style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }

  Widget _buildFeedItem(NotedUIModel? notedUIModel) {
    if (notedUIModel == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: FeedWidget(
        isShowReplyWidget: true,
        feedWidgetLayout: EFeedWidgetLayout.fullScreen,
        notedUIModel: notedUIModel,
        clickMomentCallback:
            (m) => ChuChuNavigator.pushPage(
              context,
              (_) => FeedInfoPage(notedUIModel: m),
            ),
      ),
    );
  }

  Widget dividerWidget() {
    return Container(
      width: double.infinity,
      height: 6,
      color: Theme.of(context).dividerColor.withAlpha(30),
    );
  }

  Future<void> updateNotesList(bool isInit) async {
    try {
      await _syncNotesFromRelay(isInit);

      List<NoteDBISAR> list = await RelayGroup.sharedInstance.loadGroupNotesFromDB(
          widget.relayGroupDB.groupId,
          until: isInit ? null : _allNotesFromDBLastTimestamp,
          limit: _limit) ??
          [];
      if (list.isEmpty) {
        isInit
            ? _refreshController.refreshCompleted()
            : _refreshController.loadNoData();
        return;
      }

      List<NoteDBISAR> showList = _filterNotes(list);
      _updateUI(showList, isInit, list.length);

      if (list.length < _limit) {
        _refreshController.loadNoData();
      }
    } catch (e) {
      print('Error loading notes: $e');
      _refreshController.loadFailed();
    }
  }

  void _updateUI(List<NoteDBISAR> showList, bool isInit, int fetchedCount) {
    List<NotedUIModel> list = showList
        .map((note) => NotedUIModel(noteDB: note))
        .toList();
    _updateLatestTimestamp(list);
    if (isInit) {
      notesList = list;
    } else {
      notesList.addAll(list);
    }

    _allNotesFromDBLastTimestamp = showList.last.createAt;

    if (isInit) {
      _refreshController.refreshCompleted();
    } else {
      fetchedCount < _limit
          ? _refreshController.loadNoData()
          : _refreshController.loadComplete();
    }
    setState(() {});
  }


  List<NoteDBISAR> _filterNotes(List<NoteDBISAR> notes) {
    if (notes.isEmpty) return [];

    return notes
        .where((note) => !note.isReaction &&  (note.root == null || note.root!.isEmpty))
        .toList();
  }

  Future<void> _syncNotesFromRelay(bool isInit) async {
    if (_isSyncingRemoteNotes) return;
    _isSyncingRemoteNotes = true;
    try {
      int? since;
      int? until;
      if (isInit) {
        if (_latestNotesTimestamp != null) {
          since = _latestNotesTimestamp! + 1;
        }
      } else {
        if (_allNotesFromDBLastTimestamp != null) {
          until = _allNotesFromDBLastTimestamp! - 1;
          if (until <= 0) {
            until = null;
          }
        }
      }
      await RelayGroup.sharedInstance
          .syncGroupNotesFromRelay(
            widget.relayGroupDB.groupId,
            limit: _limit,
            since: since,
            until: until,
          )
          .timeout(const Duration(seconds: 10), onTimeout: () {});
    } catch (e) {
      debugPrint('syncGroupNotesFromRelay failed: $e');
    } finally {
      _isSyncingRemoteNotes = false;
    }
  }

  void _updateLatestTimestamp(List<NotedUIModel> models) {
    for (final model in models) {
      final ts = model.noteDB.createAt;
      if (_latestNotesTimestamp == null || ts > _latestNotesTimestamp!) {
        _latestNotesTimestamp = ts;
      }
    }
  }
}
