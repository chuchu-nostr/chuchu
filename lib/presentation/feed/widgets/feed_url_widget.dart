import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/web_url_helper_utils.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../data/models/feed_extension_model.dart';

class FeedUrlWidget extends StatefulWidget {
  final String url;
  const FeedUrlWidget({super.key, required this.url});

  @override
  FeedUrlWidgetState createState() => FeedUrlWidgetState();
}

class FeedUrlWidgetState extends State<FeedUrlWidget> {
  PreviewData? urlData;

  @override
  void initState() {
    super.initState();
    _getUrlInfo();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      _getUrlInfo();
    }
  }

  void _getUrlInfo() async {
    if (widget.url.contains('youtube.com') || widget.url.contains('youtu.be')) return;
    final urlPreviewDataCache = ChuChuFeedCacheManager.sharedInstance.urlPreviewDataCache;
    PreviewData? previewData = urlPreviewDataCache[widget.url];
    if(previewData != null){
      urlData = previewData;
      setState(() {});
      return;
    }

    urlData = await WebURLHelperUtils.getPreviewData(widget.url);
    if(urlData?.title == null && urlData?.image == null && urlData?.description == null) return;
    urlPreviewDataCache[widget.url] = urlData;
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.contains('youtube.com') || widget.url.contains('youtu.be')) return const SizedBox();
    if(urlData == null) return const SizedBox();
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          bottom: 10.px,
        ),
        padding: EdgeInsets.all(10.px),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.px)),
          border: Border.all(
            width: 1.px,
            color: Theme.of(context).dividerColor.withAlpha(50),
          ),
        ),
        child: Column(
          children: [
            Text(
              urlData!.title ?? '',
              style: TextStyle(
                fontSize: 18.px,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ).setPaddingOnly(bottom: 10.px),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    getDescription(urlData!.description ?? ''),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.px,
                      color: kTitleColor,
                    ),
                  ).setPaddingOnly(bottom: 20.px),
                ),
                SizedBox(width: 8.px),
                _showPicWidget(urlData!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _showPicWidget(PreviewData urlData){
    const Widget defaultPic = Center(
      child: CommonImage(
        iconName: 'website_icon.png',
        size: 40,
      ),
    );

    final String? imageUrl = urlData.image?.url;

    Widget imageWidget;
    if (imageUrl == null || imageUrl.isEmpty) {
      imageWidget = defaultPic;
    } else {
      imageWidget = ChuChuCachedNetworkImage(
        width: double.infinity,
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => defaultPic,
        errorWidget: (context, url, error) => defaultPic,
      );
    }

    return SizedBox(
      height: 100,
      width: 100,
      child: FeedWidgetsUtils.clipImage(
        borderRadius: 10.px,
        child: imageWidget,
      ),
    );
  }


  String getDescription(String description){
    if(description.length > 200){
      return '${description.substring(0,200)}...';
    }
    return description;
  }
}
