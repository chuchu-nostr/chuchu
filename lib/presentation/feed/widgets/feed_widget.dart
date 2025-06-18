import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/material.dart';
import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/utils/feed_utils.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../data/models/noted_ui_model.dart';
import 'feed_article_widget.dart';
import 'feed_option_widget.dart';
import 'feed_reply_abbreviate_widget.dart';
import 'feed_reply_contact_widget.dart';
import 'feed_rich_text_widget.dart';
import 'feed_url_widget.dart';
import 'nine_palace_grid_picture_widget.dart';

class FeedWidget extends StatefulWidget {
  final bool isShowInteractionData;
  final bool isShowReply;
  final bool isShowUserInfo;
  final bool isShowReplyWidget;
  final bool isShowMomentOptionWidget;
  final bool isShowAllContent;
  final Function(NotedUIModel? notedUIModel)? clickMomentCallback;
  final NotedUIModel? notedUIModel;
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
  });

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  NotedUIModel? notedUIModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataInit();
  }

  @override
  Widget build(BuildContext context) {
    return _feedItemWidget();
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

  Widget _feedItemWidget() {
    NotedUIModel? modelNotifier = notedUIModel;
    if (modelNotifier == null) return const SizedBox();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.clickMomentCallback?.call(modelNotifier),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 0.5,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 12.px,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _feedUserInfoWidget(),
            _showReplyContactWidget().setPaddingOnly(left: 50.0),
            _showFeedContent(),
            _showFeedMediaWidget().setPaddingOnly(left: 50.0),
            FeedReplyAbbreviateWidget(
                notedUIModel: modelNotifier,
                isShowReplyWidget: widget.isShowReplyWidget,
            ),
            // _FeedInteractionDataWidget(),
            FeedOptionWidget(
              notedUIModel: notedUIModel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _showFeedContent() {
    NotedUIModel? model = notedUIModel;
    NotedUIModel? draftNotedUIModel = model;
    if(model == null || draftNotedUIModel == null) return const SizedBox();

    List<String> getNddrlList = draftNotedUIModel.getNddrlList;

    List<String> contentList = FeedUtils.momentContentSplit(model.noteDB.content);
    return Container(
      margin: EdgeInsets.only(
        left: 50.px,
      ),
      child: Column(
        children: contentList.map((String content) {
          if(getNddrlList.contains(content)){
            return MomentArticleWidget(naddr: content);
          } else {
          return FeedRichTextWidget(
            isShowAllContent: widget.isShowAllContent,
            clickBlankCallback: () => widget.clickMomentCallback?.call(model),
            showMoreCallback: () async {
              // await ChuChuNavigator.pushPage(context, (context) => MomentsPage(notedUIModel: model,isShowReply: widget.isShowReply));
            },
            text: content,
          ).setPadding(EdgeInsets.only(bottom: 12.px));
          }
        }).toList(),

      ),
    );
  }

  Widget _showFeedMediaWidget() {
    NotedUIModel? model = notedUIModel;
    if (model == null) return const SizedBox();

    List<String> getImageList = model.getImageList;
    if (getImageList.isNotEmpty) {
      double width = MediaQuery.of(context).size.width * 0.64;
      return NinePalaceGridPictureWidget(
        crossAxisCount: _calculateColumnsForPictures(getImageList.length),
        width: width.px,
        axisSpacing: 4,
        imageList: getImageList,
      ).setPadding(EdgeInsets.only(bottom: 12.px));
    }

    List<String> getVideoList = model.getVideoList;
    if (getVideoList.isNotEmpty) {
      String videoUrl = getVideoList[0];
      bool isHasYoutube =
          videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be');
      return isHasYoutube
          ? FeedWidgetsUtils.youtubeSurfaceMoment(context,videoUrl)
          : const SizedBox();
    }

    List<String> getFeedExternalLink = model.getMomentExternalLink;
    if (getFeedExternalLink.isNotEmpty) {
      String url = getFeedExternalLink[0];
      return MomentUrlWidget(url: url);
    }
    return const SizedBox();
  }

  Widget _showReplyContactWidget() {
    if (!widget.isShowReply) return const SizedBox();
    return FeedReplyContactWidget(notedUIModel: notedUIModel);
  }

  Widget _feedUserInfoWidget() {
    NotedUIModel? model = notedUIModel;
    if (model == null || !widget.isShowUserInfo) return const SizedBox();
    String pubKey = model.noteDB.author;

    double width = MediaQuery.of(context).size.width;
    double maxWidth = width - 170;

    return Container(
      padding: EdgeInsets.only(bottom: 12.px),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: ValueListenableBuilder<UserDBISAR>(
              valueListenable: Account.sharedInstance.getUserNotifier(pubKey),
              builder: (context, value, child) {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                      },
                      child: FeedWidgetsUtils.clipImage(
                        borderRadius: 40.px,
                        imageSize: 40.px,
                        child: ChuChuCachedNetworkImage(
                          imageUrl: value.picture ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              FeedWidgetsUtils.badgePlaceholderImage(),
                          errorWidget: (context, url, error) =>
                              FeedWidgetsUtils.badgePlaceholderImage(),
                          width: 40.px,
                          height: 40.px,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 10.px,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: maxWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                value.name ?? '--',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.px,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // _checkIsPrivate(),
                            ],
                          ),
                          Text(
                            FeedUtils.getUserMomentInfo(
                                value, model.createAtStr)[0],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.px,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _dataInit() async {
    NotedUIModel? model = widget.notedUIModel;

    if(model == null) return;


    notedUIModel = model;
    _getFeedUserInfo(model);
    setState(() {});
  }


  void _getFeedUserInfo(NotedUIModel model) async {
    String pubKey = model.noteDB.author;
    await Account.sharedInstance.getUserInfo(pubKey);
  }

  int _calculateColumnsForPictures(int picSize) {
    if (picSize == 1) return 1;
    if (picSize > 1 && picSize < 5) return 2;
    return 3;
  }
}
