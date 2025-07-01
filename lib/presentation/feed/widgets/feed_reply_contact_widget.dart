
import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/data/models/feed_extension_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../data/models/noted_ui_model.dart';

class FeedReplyContactWidget extends StatefulWidget {
  final NotedUIModel? notedUIModel;
  const FeedReplyContactWidget({super.key, required this.notedUIModel});

  @override
  _FeedReplyContactWidgetState createState() => _FeedReplyContactWidgetState();
}

class _FeedReplyContactWidgetState extends State<FeedReplyContactWidget> {
  String? noteAuthor;
  bool isShowReplyContactWidget = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMomentUser();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notedUIModel != oldWidget.notedUIModel) {
      _getMomentUser();
    }

    if(widget.notedUIModel != null && widget.notedUIModel != null && isShowReplyContactWidget && widget.notedUIModel!.noteDB.isReply){
      _getMomentUser();
    }
  }


  void _getMomentUser() async {
    NotedUIModel? model = widget.notedUIModel;
    if (model == null || !model.noteDB.isReply) {
      isShowReplyContactWidget = false;
      noteAuthor = null;
      setState(() {});
      return;
    }

    isShowReplyContactWidget = true;

    String? getReplyId = model.noteDB.getReplyId;

    if (getReplyId == null) {
      setState(() {});
      return;
    }

    NotedUIModel? notedUIModelCache = ChuChuFeedCacheManager.getValueNotifierNoteToCache(getReplyId);
    if(notedUIModelCache != null){

      noteAuthor = (notedUIModelCache).noteDB.author;

      _getMomentUserInfo(notedUIModelCache);
      if (mounted) {
        setState(() {});
      }
      return;
    }

    NotedUIModel? replyNotifier = await ChuChuFeedCacheManager.getValueNotifierNoted(
      getReplyId,
      isUpdateCache: true,
      notedUIModel: model,
    );

    if(replyNotifier == null){
      if(mounted){
        setState(() {});
      }
      return;
    }

    noteAuthor = (replyNotifier).noteDB.author;

    _getMomentUserInfo(replyNotifier);
    if (mounted) {
      setState(() {});
    }
  }

  void _getMomentUserInfo(NotedUIModel notedUIModel)async {
    String pubKey = notedUIModel.noteDB.author;
    await Account.sharedInstance.getUserInfo(pubKey);
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isShowReplyContactWidget) return const SizedBox();
    if(noteAuthor == null) return  _emptyNoteAuthorWidget().setPaddingOnly(bottom: 6.0);;
    return ValueListenableBuilder<UserDBISAR>(
      valueListenable: Account.sharedInstance.getUserNotifier(noteAuthor!),
      builder: (context, value, child) {
        return RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.px,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(text: 'Reply to ',
                  style: Theme.of(context).textTheme.labelLarge,
              ),
              TextSpan(
                text: ' @${value.name ?? ''}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12.px,
                  fontWeight: FontWeight.w400,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {

                    setState(() {});
                  },
              ),
            ],
          ),
        );
      },
    ).setPaddingOnly(bottom: 6.0);
  }

  Widget _emptyNoteAuthorWidget(){
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.px,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(text: 'Reply to ',
            style: Theme.of(context).textTheme.labelLarge
          ),
          TextSpan(
            text: ' @ ',
            style: TextStyle(
              color: Colors.purple,
              fontSize: 12.px,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
