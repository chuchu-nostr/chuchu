import 'package:flutter/material.dart';

import 'package:chuchu/core/feed/feed+load.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:chuchu/data/models/feed_extension_model.dart';
import 'package:flutter/material.dart';

import '../../../core/feed/feed.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_smart_refresher.dart';
import '../../../data/models/noted_ui_model.dart';
import '../widgets/feed_widget.dart';
import '../widgets/feed_skeleton_widget.dart';
import 'feed_info_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  List<NotedUIModel?> notesList = [];
  final int _limit = 1000;
  int? _allNotesFromDBLastTimestamp;

  final ScrollController feedScrollController = ScrollController();
  final RefreshController refreshController = RefreshController();

  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 5000), () {
      updateNotesList(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChuChuSmartRefresher(
        scrollController: feedScrollController,
        controller: refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () => updateNotesList(true),
        onLoading: () => updateNotesList(false),
        child: _getFeedListWidget(),
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
        ).setPadding(EdgeInsets.symmetric(horizontal: 16.0));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> updateNotesList(bool isInit) async {
    if (isInit && notesList.isEmpty) {
      setState(() {
        _isInitialLoading = true;
      });
    }

    await Feed.sharedInstance.updateSubscriptions();

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
    return await Feed.sharedInstance.loadContactsNotesFromDB(
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
}
