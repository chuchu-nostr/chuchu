import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/data/models/feed_extension_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../data/models/noted_ui_model.dart';
import '../pages/feed_info_page.dart';
import 'feed_widget.dart';

class FeedReplyAbbreviateWidget extends StatefulWidget {
  final bool isShowReplyWidget;
  final NotedUIModel? notedUIModel;

  const FeedReplyAbbreviateWidget({super.key, required this.notedUIModel, this.isShowReplyWidget = false});

  @override
  _FeedReplyAbbreviateWidgetState createState() => _FeedReplyAbbreviateWidgetState();
}

class _FeedReplyAbbreviateWidgetState extends State<FeedReplyAbbreviateWidget> {
  NotedUIModel? notedUIModel;
  bool hasReplyWidget = false;

  @override
  void initState() {
    super.initState();
    _getNotedUIModel();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notedUIModel != oldWidget.notedUIModel) {
      _getNotedUIModel();
    }
    if(hasReplyWidget && notedUIModel == null){
      _getNotedUIModel();
    }
  }

  void _getNotedUIModel() async {
    NotedUIModel? notedUIModelDraft = widget.notedUIModel;
    if (notedUIModelDraft == null || !notedUIModelDraft.noteDB.isReply || !widget.isShowReplyWidget) {
      // Preventing a bug where the internal component fails to update in a timely manner when the outer ListView.builder array is updated with a non-reply note.
      notedUIModel = null;
      hasReplyWidget = false;
      setState(() {});
      return;
    }

    hasReplyWidget = true;

    String? replyId = notedUIModelDraft.noteDB.getReplyId;
    if (replyId == null) {
      setState(() {});
      return;
    }

    NotedUIModel? notedUIModelCache = ChuChuFeedCacheManager.getValueNotifierNoteToCache(replyId);
    if(notedUIModelCache != null){
      notedUIModel = notedUIModelCache;
      setState(() {});
      return;
    }


    NotedUIModel? noteNotifier = await ChuChuFeedCacheManager.getValueNotifierNoted(
      replyId,
      isUpdateCache: true,
      notedUIModel: notedUIModelDraft,
    );

    if(noteNotifier == null){
      if(mounted){
        setState(() {});
      }
      return;
    }

    notedUIModel = noteNotifier;
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    NotedUIModel? model = notedUIModel;
    if(!widget.isShowReplyWidget || model == null) return const SizedBox();
    if (hasReplyWidget && model == null) return FeedWidgetsUtils.emptyNoteMomentWidget(null,100);
    return Container(

      padding: EdgeInsets.only(
        top: 10.px,
      ),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5.px,
          color: Theme.of(context).dividerColor.withAlpha(50),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            11.5.px,
          ),
        ),
      ),
      child: FeedWidget(
        notedUIModel: model,
        isShowMomentOptionWidget: false,
        isShowBottomBorder: false,
        clickMomentCallback: (NotedUIModel? notedUIModel) async {
          await ChuChuNavigator.pushPage(
              context, (context) => FeedInfoPage(notedUIModel: notedUIModel));
        },
      ).setPadding(EdgeInsets.symmetric(horizontal: 12.0)),
    );
  }
}
