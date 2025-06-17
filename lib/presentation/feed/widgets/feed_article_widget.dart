
import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/feed_utils.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../data/models/feed_extension_model.dart';
import 'feed_rich_text_widget.dart';

class MomentArticleWidget extends StatefulWidget {
  final String naddr;

  const MomentArticleWidget({super.key, required this.naddr});

  @override
  MomentArticleWidgetState createState() => MomentArticleWidgetState();
}

class MomentArticleWidgetState extends State<MomentArticleWidget> {
  Map<String,dynamic>? articleInfo;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.naddr != oldWidget.naddr) {
      _initData();
    }

  }

  @override
  Widget build(BuildContext context) {
    return quoteMoment();
  }

  void _initData() async {
    final naddrAnalysisCache = ChuChuFeedCacheManager.sharedInstance.naddrAnalysisCache;
    if(naddrAnalysisCache[widget.naddr] != null){
      articleInfo = naddrAnalysisCache[widget.naddr];
      if (mounted) {
        setState(() {});
      }
      return;
    }
    // final info = await FeedUtils.tryDecodeNostrScheme(widget.naddr);
    //
    // if(info != null){
    //   naddrAnalysisCache[widget.naddr] = info;
    //   articleInfo = info;
    //   if (mounted) {
    //     setState(() {});
    //   }
    // }
  }



  Widget _getImageWidget() {
    Map<String,dynamic>? info = articleInfo;
    if (info == null) return const SizedBox();
    if (info['content']['image'] == null ) return const SizedBox();
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(11.5.px),
        topRight: Radius.circular(11.5.px),
      ),
      child: Container(
        width: double.infinity,
        color: Colors.red,
        child: ChuChuCachedNetworkImage(
          imageUrl: info['content']['image'],
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              FeedWidgetsUtils.badgePlaceholderContainer(
                  height: 172, width: double.infinity),
          errorWidget: (context, url, error) =>
              FeedWidgetsUtils.badgePlaceholderContainer(
                  size: 172, width: double.infinity),
          height: 172.px,
        ),
      ),
    );
  }

  Widget quoteMoment() {
    Map<String,dynamic>? info = articleInfo;
    if (info == null) return FeedWidgetsUtils.emptyNoteMomentWidget(null,100);
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.px),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.px,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              11.5.px,
            ),
          ),
        ),
        child: Column(
          children: [
            _getImageWidget(),
            Container(
              padding: EdgeInsets.all(12.px),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // await OXModuleService.pushPage(
                          //     context, 'ox_chat', 'ContactUserInfoPage', {
                          //   'pubkey': pubKey,
                          // });
                          // setState(() {});
                        },
                        child: FeedWidgetsUtils.clipImage(
                          borderRadius: 40.px,
                          imageSize: 40.px,
                          child: ChuChuCachedNetworkImage(
                            imageUrl: info['content']['authorIcon'] ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                FeedWidgetsUtils
                                    .badgePlaceholderImage(),
                            errorWidget: (context, url, error) =>
                                FeedWidgetsUtils
                                    .badgePlaceholderImage(),
                            width: 40.px,
                            height: 40.px,
                          ),
                        ),
                      ),
                      Text(
                        info['content']['authorName'] ?? '--',
                        style: TextStyle(
                          fontSize: 12.px,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ).setPadding(
                        EdgeInsets.symmetric(
                          horizontal: 4.px,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          FeedUtils.formatTimeAgo(int.parse(info['content']?['createTime'] ?? '0')),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.px,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ).setPaddingOnly(bottom: 4.px),
                  FeedRichTextWidget(
                    text: info['content']['note'] ?? '',
                    textSize: 14.px,
                    // maxLines: 1,
                    isShowAllContent: false,
                    clickBlankCallback: ()  {

                    },
                    showMoreCallback: ()  {

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}