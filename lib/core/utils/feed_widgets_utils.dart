import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../widgets/chuchu_cached_network_Image.dart';
import '../widgets/common_image.dart';
import '../widgets/youtube_player_widget.dart';


class FeedWidgetsUtils {
  static Widget clipImage({
    required double borderRadius,
    String? imageName,
    Widget? child,
    double imageHeight = 20,
    double imageWidth = 20,
    double? imageSize,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        borderRadius,
      ),
      child: child ??
          CommonImage(
            iconName: imageName ?? '',
            width: imageSize ?? imageWidth,
            height: imageSize ?? imageHeight,
          ),
    );
  }

  static Widget videoMoment(context, String videoUrl, String? videoImagePath,
      {
        isEdit = false,
        Function? delVideoCallback,
      }) {
    Widget _showImageWidget() {
      if (videoImagePath != null) {
        return FeedWidgetsUtils.clipImage(
          borderRadius: 8.px,
          child: Image.asset(
            videoImagePath,
            width: 210.px,
            height: 210.px,
            fit: BoxFit.cover,
            package: null,
          ),
        );
      }

      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {

      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              bottom: 12.px,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Adapt.px(12),
                ),
              ),
            ),
            width: 210.px,
            height: 154.px,
          ),
          FeedWidgetsUtils.clipImage(
            borderRadius: 16,
            child: _showImageWidget(),
          ).setPaddingOnly(bottom: 20.px),
          // VideoCoverWidget(videoUrl:videoUrl),
          CommonImage(
            iconName: 'play_moment_icon.png',
            size: 60.0.px,
            color: Colors.white,
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                delVideoCallback?.call();
              },
              child: Container(
                width: 30.px,
                height: 30.px,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.px),
                  ),
                ),
                child: Center(
                  child: CommonImage(
                    iconName: 'close_icon.png',
                    size: 20.px,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget emptyNoteMomentWidget(String? content, double height) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.px),
      height: height.px,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) {
            return Transform.rotate(
              angle: value * 2 * 3.14159, // 2π radians = 360 degrees
              child: Icon(
                Icons.refresh,
                size: 50.px,
                color: Colors.black38,
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget youtubeSurfaceMoment(context,String videoUrl) {
    return GestureDetector(
      onTap: () {
        ChuChuNavigator.presentPage(context, (context) => YoutubePlayerWidget(videoUrl: videoUrl),fullscreenDialog: true);
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10.px,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Adapt.px(12),
                  ),
                ),
              ),
              width: 210.px,
              // height: 154.px,
            ),
            FeedWidgetsUtils.clipImage(
              borderRadius: 16,
              child: ChuChuCachedNetworkImage(
                imageUrl:
                'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(videoUrl)}/hqdefault.jpg',
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    FeedWidgetsUtils.badgePlaceholderContainer(size: 210),
                errorWidget: (context, url, error) =>
                    FeedWidgetsUtils.badgePlaceholderContainer(size: 210),
                width: double.infinity,
              ),
            ),
            // _videoSurfaceDrawingWidget(),
            CommonImage(
              iconName: 'play_moment_icon.png',
              size: 60.0.px,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  static Widget badgePlaceholderImage({int size = 24}) {
    return CommonImage(
      iconName: 'icon_user_default.png',
      fit: BoxFit.cover,
      width: size.px,
      height: size.px,
    );
  }

  static Widget badgePlaceholderContainer(
      {int size = 24, double? width, double? height}) {
    return Container(
      width: width ?? size.px,
      height: height ?? size.px,
      color: Colors.black,
    );
  }

  static int getTextLine(String text, double width, int? maxLine) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text.trim(),
      ),
      maxLines: maxLine ?? 100,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: width);
    bool isOver = textPainter.didExceedMaxLines;
    int lineCount = textPainter.computeLineMetrics().length;

    return lineCount;
  }
}
