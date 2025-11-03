import 'package:chuchu/core/relayGroups/relayGroup+note.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:flutter/material.dart';

import '../../../core/feed/feed.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import '../../../core/nostr_dart/src/ok.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_toast.dart';
import '../../../data/enum/feed_enum.dart';
import '../../../data/models/feed_extension_model.dart';
import '../../../data/models/noted_ui_model.dart';
import '../pages/feed_reply_page.dart';

class FeedOptionWidget extends StatefulWidget {

  final NotedUIModel? notedUIModel;

  const FeedOptionWidget({super.key,this.notedUIModel});
  @override
  State createState() => _FeedOptionWidgetState();
}

class _FeedOptionWidgetState extends State<FeedOptionWidget> {
  bool _reactionTag = false;
  bool _bookmarkTag = false;

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
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: feedOptionTypeList.map((EFeedOptionType type) {
                return _showItemWidget(type);
              }).toList(),
            ),
          ),
          Flexible(
            flex: 1, // 25%
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _onBookmarkTap,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CommonImage(iconName: 'bookmark_icon.png',size: 24,),
                ),
              ),
            ),
          ),
        ]
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
        return () async {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => FeedReplyPage(notedUIModel:notedUIModel!),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
              reverseTransitionDuration: const Duration(milliseconds: 250),
            ),
          );
        };
      case EFeedOptionType.like:
        return () async {
          if (noteDB.reactionCountByMe > 0 || _reactionTag) return;
          bool isSuccess = false;
          try {

            OKEvent event = await RelayGroup.sharedInstance.sendGroupNoteReaction(noteDB.noteId);
            isSuccess = event.status;
          } catch (e) {
            debugPrint('Error sending reaction: $e');
            isSuccess = false;
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

  void _onBookmarkTap() {
    CommonToast.instance.show(context, 'Bookmarks coming soon');
    // setState(() {
    //   _bookmarkTag = !_bookmarkTag;
    // });
    //
    // if (_bookmarkTag) {
    //   CommonToast.instance.show(context, 'Bookmarked');
    // } else {
    //   CommonToast.instance.show(context, 'Bookmark removed');
    // }
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
    Color textColors = isSelect ? Color(0xFFA84F4F) : kIconState;
    return GestureDetector(
      onLongPress: onLongPress,
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap?.call(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: CommonImage(iconName: _mapIconData(type, isSelect),  size: 24,),
          ),
          Text(
            content,
            style: TextStyle(
              color: kIconState,
              fontSize: 18,
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

  String _mapIconData(EFeedOptionType type, bool isSelect) {
    switch (type) {
      case EFeedOptionType.reply:
        return isSelect ? EFeedOptionType.reply.getSelectIconName : EFeedOptionType.reply.getIconName;
      case EFeedOptionType.like:
        return isSelect ? EFeedOptionType.like.getSelectIconName : EFeedOptionType.like.getIconName;
      case EFeedOptionType.zaps:
        return isSelect ? EFeedOptionType.zaps.getSelectIconName : EFeedOptionType.zaps.getIconName;
    }
  }
}

/// Reusable like button component that can be used across different pages
class ReusableLikeButton extends StatefulWidget {
  final NotedUIModel? notedUIModel;
  final double? iconSize;
  final double? fontSize;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool showCount;

  const ReusableLikeButton({
    super.key,
    required this.notedUIModel,
    this.iconSize = 24,
    this.fontSize = 18,
    this.textColor,
    this.onTap,
    this.showCount = true,
  });

  @override
  State<ReusableLikeButton> createState() => _ReusableLikeButtonState();
}

class _ReusableLikeButtonState extends State<ReusableLikeButton> {
  bool _reactionTag = false;

  @override
  void initState() {
    super.initState();
    _initReactionState();
  }

  void _initReactionState() {
    if (widget.notedUIModel?.noteDB.reactionCountByMe != null) {
      _reactionTag = widget.notedUIModel!.noteDB.reactionCountByMe > 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLiked = _isLiked();
    final likeCount = _getLikeCount();

    return GestureDetector(
      onTap: widget.onTap ?? _handleLikeTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: widget.showCount ? 8.0 : 0.0),
            child: CommonImage(
              iconName: isLiked ? 'liked_icon.png' : 'like_icon.png',
              size: widget.iconSize ?? 24,
            ),
          ),
          if (widget.showCount)
            Text(
              likeCount.toString(),
              style: TextStyle(
                color: widget.textColor ?? Theme.of(context).colorScheme.outline,
                fontSize: widget.fontSize ?? 18,
              ),
            ),
        ],
      ),
    );
  }

  bool _isLiked() {
    final noteDB = widget.notedUIModel?.noteDB;
    if (noteDB == null) return false;
    return _reactionTag || noteDB.reactionCountByMe > 0;
  }

  int _getLikeCount() {
    final noteDB = widget.notedUIModel?.noteDB;
    return noteDB?.reactionCount ?? 0;
  }

  Future<void> _handleLikeTap() async {
    final noteDB = widget.notedUIModel?.noteDB;
    if (noteDB == null) return;

    // Prevent double tap
    if (noteDB.reactionCountByMe > 0 || _reactionTag) return;

    bool isSuccess = false;
    try {
      OKEvent event = await RelayGroup.sharedInstance.sendGroupNoteReaction(noteDB.noteId);
      isSuccess = event.status;
    } catch (e) {
      debugPrint('Error sending reaction: $e');
      isSuccess = false;
    }

    _dealWithReaction(isSuccess);
  }

  void _dealWithReaction(bool isSuccess) {
    if (isSuccess) {
      setState(() {
        _reactionTag = true;
      });
      _updateNoteDB();
      CommonToast.instance.show(context, 'Like success tips');
    } else {
      CommonToast.instance.show(context, 'Like fail tips');
    }
  }

  void _updateNoteDB() async {
    if (widget.notedUIModel == null) return;

    try {
      NotedUIModel? noteNotifier = await ChuChuFeedCacheManager.getValueNotifierNoted(
        widget.notedUIModel!.noteDB.noteId,
        isUpdateCache: true,
        notedUIModel: widget.notedUIModel,
      );

      if (noteNotifier != null && mounted) {
        // Update the widget's notedUIModel if possible
        // Note: This might need to be handled by parent widget
      }
    } catch (e) {
      debugPrint('Error updating note DB: $e');
    }
  }
}

/// Reusable interaction buttons component that can be used across different pages
class ReusableInteractionButtons extends StatefulWidget {
  final NotedUIModel? notedUIModel;
  final double? iconSize;
  final double? fontSize;
  final Color? textColor;
  final bool showLike;
  final bool showComment;
  final bool showZap;
  final bool showBookmark;
  final VoidCallback? onCommentTap;
  final VoidCallback? onZapTap;
  final VoidCallback? onBookmarkTap;

  const ReusableInteractionButtons({
    super.key,
    required this.notedUIModel,
    this.iconSize = 24,
    this.fontSize = 18,
    this.textColor,
    this.showLike = true,
    this.showComment = true,
    this.showZap = true,
    this.showBookmark = true,
    this.onCommentTap,
    this.onZapTap,
    this.onBookmarkTap,
  });

  @override
  State<ReusableInteractionButtons> createState() => _ReusableInteractionButtonsState();
}

class _ReusableInteractionButtonsState extends State<ReusableInteractionButtons> {
  bool _bookmarkTag = false;

  @override
  void initState() {
    super.initState();
    _initBookmarkState();
  }

  void _initBookmarkState() {
    // Initialize bookmark state if needed
    _bookmarkTag = false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.showLike)
          ReusableLikeButton(
            notedUIModel: widget.notedUIModel,
            iconSize: widget.iconSize,
            fontSize: widget.fontSize,
            textColor: widget.textColor,
          ),
        if (widget.showLike && widget.showComment)
          SizedBox(width: 16),
        if (widget.showComment)
          _buildCommentButton(),
        if (widget.showComment && widget.showZap)
          SizedBox(width: 16),
        if (widget.showZap)
          _buildZapButton(),
        if (widget.showZap && widget.showBookmark)
          SizedBox(width: 16),
        if (widget.showBookmark)
          _buildBookmarkButton(),
      ],
    );
  }

  Widget _buildCommentButton() {
    final commentCount = widget.notedUIModel?.noteDB.replyCount ?? 0;

    return GestureDetector(
      onTap: widget.onCommentTap ?? _handleCommentTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: CommonImage(
              iconName: 'comment_feed_icon.png',
              size: widget.iconSize ?? 24,
            ),
          ),
          Text(
            commentCount.toString(),
            style: TextStyle(
              color: widget.textColor ?? Theme.of(context).colorScheme.outline,
              fontSize: widget.fontSize ?? 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZapButton() {
    final zapAmount = widget.notedUIModel?.noteDB.zapAmount ?? 0;

    return GestureDetector(
      onTap: widget.onZapTap ?? _handleZapTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: CommonImage(
              iconName: 'zap_icon.png',
              size: widget.iconSize ?? 24,
            ),
          ),
          Text(
            zapAmount.toString(),
            style: TextStyle(
              color: widget.textColor ?? Theme.of(context).colorScheme.outline,
              fontSize: widget.fontSize ?? 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkButton() {
    return GestureDetector(
      onTap: widget.onBookmarkTap ?? _handleBookmarkTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: CommonImage(
              iconName: _bookmarkTag ? 'bookmarked_icon.png' : 'bookmark_icon.png',
              size: widget.iconSize ?? 24,
            ),
          ),
        ],
      ),
    );
  }

  void _handleCommentTap() {
    // Navigate to comment page or show comment dialog
    if (widget.notedUIModel != null) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FeedReplyPage(notedUIModel: widget.notedUIModel!),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
        ),
      );
    }
  }

  void _handleZapTap() {
    // Handle zap functionality
    CommonToast.instance.show(context, 'Zap functionality coming soon');
  }

  void _handleBookmarkTap() {
    setState(() {
      _bookmarkTag = !_bookmarkTag;
    });

    if (_bookmarkTag) {
      CommonToast.instance.show(context, 'Bookmarked');
    } else {
      CommonToast.instance.show(context, 'Bookmark removed');
    }
  }
}
