import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/web_url_helper_utils.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../data/models/feed_extension_model.dart';

class MomentUrlWidget extends StatefulWidget {
  final String url;
  const MomentUrlWidget({super.key, required this.url});

  @override
  MomentUrlWidgetState createState() => MomentUrlWidgetState();
}

class MomentUrlWidgetState extends State<MomentUrlWidget> {
  PreviewData? urlData;

  final GlobalKey<MomentUrlWidgetState> _containerKey = GlobalKey<MomentUrlWidgetState>();

  double? containerHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUrlInfo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderObject? renderBox = _containerKey.currentContext?.findRenderObject();
      if(renderBox != null){
        if(mounted){
          setState(() {
            containerHeight = (renderBox as RenderBox).size.height;
          });
        }
      }
    });
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
                fontSize: 15.px,
                color: Colors.white,
              ),
            ).setPaddingOnly(bottom: 20.px),
            Text(
              getDescription(urlData!.description ?? ''),
              style: TextStyle(
                fontSize: 15.px,
                color: Colors.white,
              ),
            ).setPaddingOnly(bottom: 20.px),
            _showPicWidget(urlData!),
          ],
        ),
      ),
    );
  }

  Widget _showPicWidget(PreviewData urlData){
    if(urlData.image == null || urlData.image?.url == null) return const SizedBox();
    return Container(
      key:_containerKey,
      height: containerHeight,
      width: double.infinity,
      child: FeedWidgetsUtils.clipImage(
        borderRadius: 10.px,
        child: ChuChuCachedNetworkImage(
          width: double.infinity,
          imageUrl: urlData.image?.url ?? '',
          fit: BoxFit.cover,
        ),
      ),
    );
  }


  String getDescription(String description){
    if(description.length > 200){
      return description.substring(0,200) + '...';
    }
    return description;
  }
}
