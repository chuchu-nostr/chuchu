import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/material.dart';
import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/utils/feed_utils.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../data/models/noted_ui_model.dart';
import '../pages/feed_info_page.dart';
import '../pages/feed_personal_page.dart';
import 'feed_article_widget.dart';
import 'feed_option_widget.dart';
import 'feed_reply_abbreviate_widget.dart';
import 'feed_reply_contact_widget.dart';
import 'feed_rich_text_widget.dart';
import 'feed_url_widget.dart';
import 'nine_palace_grid_picture_widget.dart';

enum EFeedWidgetLayout {
  fullScreen,
  halfScreen
}

class FeedWidget extends StatefulWidget {
  final bool isShowInteractionData;
  final bool isShowReply;
  final bool isShowUserInfo;
  final bool isShowReplyWidget;
  final bool isShowMomentOptionWidget;
  final bool isShowAllContent;
  final bool isShowBottomBorder;
  final Function(NotedUIModel? notedUIModel)? clickMomentCallback;
  final NotedUIModel? notedUIModel;
  final EFeedWidgetLayout? feedWidgetLayout;

  const FeedWidget({
    super.key,
    required this.notedUIModel,
    this.clickMomentCallback,
    this.isShowAllContent = false,
    this.isShowReply = true,
    this.isShowUserInfo = true,
    this.isShowReplyWidget = false,
    this.isShowMomentOptionWidget = true,
    this.isShowInteractionData = false,
    this.isShowBottomBorder = true,
    this.feedWidgetLayout = EFeedWidgetLayout.halfScreen
  });

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  static const double _avatarSize = 50.0;
  static const double _borderWidth = 0.5;
  static const double _verticalPadding = 12.0;
  static const double _rightPadding = 8.0;
  static const double _bottomSpacing = 12.0;
  static const int _imageSpacing = 4;
  static const double _mediaWidthRatio = 0.64;

  NotedUIModel? notedUIModel;

  @override
  void initState() {
    super.initState();
    _dataInit();
  }

  @override
  Widget build(BuildContext context) {
    return widget.feedWidgetLayout == EFeedWidgetLayout.halfScreen 
        ? _feedHalfItemWidget() 
        : _feedFullItemWidget();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    NotedUIModel? newNote = widget.notedUIModel;
    NotedUIModel? oldNote = oldWidget.notedUIModel;
    if (newNote != oldNote) {
      _dataInit();
    }
  }

  Border? get _bottomBorder => widget.isShowBottomBorder
      ? Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withAlpha(80), width: _borderWidth))
      : null;

  Widget _buildFeedContainer({required Widget child, EdgeInsets? padding}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.clickMomentCallback?.call(notedUIModel),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(border: _bottomBorder),
        child: child,
      ),
    );
  }

  Widget _buildContentColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _feedUserInfoWidget(),
        _showReplyContactWidget(),
        _showFeedContent(),
        _showFeedMediaWidget(),
        FeedReplyAbbreviateWidget(
          notedUIModel: notedUIModel,
          isShowReplyWidget: widget.isShowReplyWidget,
        ),
        FeedOptionWidget(notedUIModel: notedUIModel).setPaddingOnly(bottom:  _verticalPadding.px),
      ],
    );
  }

  Widget _feedFullItemWidget() {
    if (notedUIModel == null) return const SizedBox();
    
    return _buildFeedContainer(
      child: _buildContentColumn(),
    );
  }

  Widget _buildAvatarWidget({String? imageUrl}) {
    return GestureDetector(
      onTap: (){
        if(notedUIModel != null){
          ChuChuNavigator.pushPage(context, (context) => FeedPersonalPage(userPubkey: notedUIModel!.noteDB.author,));
        }
      },
      child: FeedWidgetsUtils.clipImage(
        borderRadius: _avatarSize.px,
        imageSize: _avatarSize.px,
        child: ChuChuCachedNetworkImage(
          imageUrl: imageUrl ?? '',
          fit: BoxFit.cover,
          placeholder: (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
          errorWidget: (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(),
          width: _avatarSize.px,
          height: _avatarSize.px,
        ),
      ),
    );

  }

  Widget _buildAvatarColumn() {
    if(notedUIModel == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(right: _rightPadding),
      child: Column(
        children: [
          ValueListenableBuilder<UserDBISAR>(
            valueListenable: Account.sharedInstance.getUserNotifier(notedUIModel!.noteDB.author),
            builder: (context, user, child) {
              return _buildAvatarWidget(imageUrl:user.picture);
            },
          ),
          if (widget.isShowAllContent)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: _rightPadding),
                width: 1,
                color: Colors.grey.withOpacity(.5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _feedHalfItemWidget() {
    if (notedUIModel == null) return const SizedBox();
    
    return _buildFeedContainer(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatarColumn(),
            Expanded(child: _buildContentColumn()),
          ],
        ),
      ),
    );
  }

  Widget _buildContentItem(String content, NotedUIModel model, List<String> nddrlList) {
    if (nddrlList.contains(content)) {
      return MomentArticleWidget(naddr: content);
    }
    
    return FeedRichTextWidget(
      isShowAllContent: widget.isShowAllContent,
      clickBlankCallback: () => widget.clickMomentCallback?.call(model),
      showMoreCallback: () async {
        await ChuChuNavigator.pushPage(context, (context) => FeedInfoPage(notedUIModel: model,isShowReply: widget.isShowReply));

      },
      text: content,
    ).setPadding(EdgeInsets.only(bottom: _bottomSpacing.px));
  }

  Widget _showFeedContent() {
    final model = notedUIModel;
    if (model == null) return const SizedBox();

    final nddrlList = model.getNddrlList;
    final contentList = FeedUtils.momentContentSplit(model.noteDB.content);
    
    return Column(
      children: contentList
          .map((content) => _buildContentItem(content, model, nddrlList))
          .toList(),
    );
  }

  Widget _buildImageGrid(List<String> imageList) {
    final width = MediaQuery.of(context).size.width * _mediaWidthRatio;
    return NinePalaceGridPictureWidget(
      crossAxisCount: _calculateColumnsForPictures(imageList.length),
      width: width.px,
      axisSpacing: _imageSpacing,
      imageList: imageList,
    ).setPadding(EdgeInsets.only(bottom: _bottomSpacing.px));
  }

  Widget _buildVideoWidget(String videoUrl) {
    final isYoutube = videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be');
    return isYoutube 
        ? FeedWidgetsUtils.youtubeSurfaceMoment(context, videoUrl)
        : const SizedBox();
  }

  Widget _showFeedMediaWidget() {
    final model = notedUIModel;
    if (model == null) return const SizedBox();

    final imageList = model.getImageList;
    if (imageList.isNotEmpty) {
      return _buildImageGrid(imageList);
    }

    final videoList = model.getVideoList;
    if (videoList.isNotEmpty) {
      return _buildVideoWidget(videoList[0]);
    }

    final externalLinks = model.getMomentExternalLink;
    if (externalLinks.isNotEmpty) {
      return FeedUrlWidget(url: externalLinks[0]);
    }
    
    return const SizedBox();
  }

  Widget _showReplyContactWidget() {
    if (!widget.isShowReply) return const SizedBox();
    return FeedReplyContactWidget(notedUIModel: notedUIModel);
  }

  Widget _buildUserNameAndTime(UserDBISAR user, NotedUIModel model) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.name ?? '--',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.px,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  FeedUtils.getUserMomentInfo(user, model.createAtStr)[2],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.px,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // _checkIsPrivate(),
              ],
            ),
          ),
          Text(
            FeedUtils.getUserMomentInfo(user, model.createAtStr)[1],
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.px,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow(UserDBISAR user, NotedUIModel model) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.feedWidgetLayout == EFeedWidgetLayout.fullScreen)
          GestureDetector(
            onTap: () async {},
            child: _buildAvatarWidget(imageUrl: user.picture),
          ).setPaddingOnly(right: _rightPadding),
        _buildUserNameAndTime(user, model),
      ],
    );
  }

  Widget _feedUserInfoWidget() {
    final model = notedUIModel;
    if (model == null || !widget.isShowUserInfo) return const SizedBox();
    
    final pubKey = model.noteDB.author;

    return Container(
      padding: EdgeInsets.only(bottom: _bottomSpacing.px),
      child: ValueListenableBuilder<UserDBISAR>(
        valueListenable: Account.sharedInstance.getUserNotifier(pubKey),
        builder: (context, user, child) {
          return _buildUserInfoRow(user, model);
        },
      ),
    );
  }

  Future<void> _dataInit() async {
    final model = widget.notedUIModel;
    if (model == null) return;

    notedUIModel = model;
    await _getFeedUserInfo(model);
    if (mounted) setState(() {});
  }

  Future<void> _getFeedUserInfo(NotedUIModel model) async {
    final pubKey = model.noteDB.author;
    await Account.sharedInstance.getUserInfo(pubKey);
  }

  int _calculateColumnsForPictures(int picSize) {
    if (picSize == 1) return 1;
    if (picSize > 1 && picSize < 5) return 2;
    return 3;
  }
}
