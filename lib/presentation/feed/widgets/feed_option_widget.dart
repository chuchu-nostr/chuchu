import 'package:chuchu/core/feed/feed+send.dart';
import 'package:flutter/material.dart';

import '../../../core/feed/feed.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import '../../../core/nostr_dart/src/ok.dart';
import '../../../core/widgets/common_toast.dart';
import '../../../data/enum/feed_enum.dart';
import '../../../data/models/feed_extension_model.dart';
import '../../../data/models/noted_ui_model.dart';

class FeedOptionWidget extends StatefulWidget {

  final NotedUIModel? notedUIModel;

  const FeedOptionWidget({super.key,this.notedUIModel});
  @override
  State createState() => _FeedOptionWidgetState();
}

class _FeedOptionWidgetState extends State<FeedOptionWidget> {
  bool _reactionTag = false;

  late NotedUIModel? notedUIModel;

  final List<EFeedOptionType> feedOptionTypeList = [
    EFeedOptionType.reply,
    EFeedOptionType.like,
    EFeedOptionType.zaps,
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init(){
    notedUIModel = widget.notedUIModel;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              feedOptionTypeList.map((EFeedOptionType type) {
                return _showItemWidget(type);
              }).toList(),
        ),
      ),
    );
  }

  Widget _showItemWidget(EFeedOptionType type) {
    Widget iconTextWidget = _iconTextWidget(
      type: type,
      isSelect: _isClickByMe(type),
      onTap: () => _onTapCallback(type)(),
      onLongPress: () => _onLongPress(type)(),
      clickNum: _getClickNum(type),
    );

    return iconTextWidget;
  }

  GestureTapCallback _onTapCallback(EFeedOptionType type) {
    NoteDBISAR? noteDB = notedUIModel?.noteDB;
    if(noteDB == null) return (){};
    switch (type) {
      case EFeedOptionType.reply:
        return () async{

        };
      case EFeedOptionType.like:
        return () async {
          if (noteDB.reactionCountByMe > 0 || _reactionTag) return;
          bool isSuccess = false;
          if (noteDB.groupId.isEmpty) {
            OKEvent event = await Feed.sharedInstance.sendReaction(noteDB.noteId);
            isSuccess = event.status;
          }
          _dealWithReaction(isSuccess);
        };
      case EFeedOptionType.zaps:
        return (){};
    }
  }

  void _dealWithReaction(bool isSuccess){
    if (isSuccess) {
      _reactionTag = true;
      setState(() {});
      _updateNoteDB();
      CommonToast.instance.show(context, 'Like success tips');
    }else{
      CommonToast.instance.show(context, 'Like fail tips');
    }
  }


  void _updateNoteDB() async {
    if(notedUIModel == null)  return;
    NotedUIModel? noteNotifier = await ChuChuFeedCacheManager.getValueNotifierNoted(
      notedUIModel!.noteDB.noteId,
      isUpdateCache: true,
      notedUIModel: notedUIModel,
    );

    if(noteNotifier == null) return;
    if(mounted){
      notedUIModel = noteNotifier;
    }

  }

  GestureLongPressCallback _onLongPress(EFeedOptionType type) {
    return () => {};
  }

  Widget _iconTextWidget({
    required EFeedOptionType type,
    required bool isSelect,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    int? clickNum,
  }) {
    final content =
        clickNum == null || clickNum == 0 ? '' : clickNum.toString();
    Color textColors = isSelect ? Color(0xFFA84F4F) : Colors.black54;
    return GestureDetector(
      onLongPress: onLongPress,
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap?.call(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Icon(
              _mapIconData(type, isSelect),
              size: 18,
              color: textColors,
            ),
          ),
          Text(
            content,
            style: TextStyle(
              color: textColors,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  int _getClickNum(EFeedOptionType type) {
    NoteDBISAR? noteDB = notedUIModel?.noteDB;
    if(noteDB == null) return 0;
    switch(type){
      case EFeedOptionType.like:
        return noteDB.reactionCount;
      case EFeedOptionType.zaps:
        return noteDB.zapAmount;
      case EFeedOptionType.reply:
        return noteDB.replyCount;
    }
  }

  bool _isClickByMe(EFeedOptionType type) {
    NoteDBISAR? noteDB = notedUIModel?.noteDB;
    if(noteDB == null) return false;
    switch(type){
      case EFeedOptionType.like:
        return _reactionTag ? _reactionTag : noteDB.reactionCountByMe > 0;
      case EFeedOptionType.zaps:
        return noteDB.zapAmountByMe > 0;
      case EFeedOptionType.reply:
        return noteDB.replyCountByMe > 0;
    }
  }

  IconData _mapIconData(EFeedOptionType type, bool isSelect) {
    switch (type) {
      case EFeedOptionType.reply:
        return isSelect ? Icons.chat_bubble : Icons.chat_bubble_outline;
      case EFeedOptionType.like:
        return isSelect ? Icons.favorite : Icons.favorite_border;
      case EFeedOptionType.zaps:
        return isSelect ? Icons.bolt : Icons.bolt_outlined;
    }
  }
}
