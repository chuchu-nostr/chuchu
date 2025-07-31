import 'dart:io';
import 'dart:typed_data';

import 'package:chuchu/core/utils/adapt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/widgets/common_image.dart';
import '../../../core/widgets/common_video_page.dart';


class FeedVideoWidget extends StatefulWidget {
  final String videoUrl;

  const FeedVideoWidget({super.key, required this.videoUrl});

  @override
  _FeedVideoWidgetState createState() => _FeedVideoWidgetState();
}

class _FeedVideoWidgetState extends State<FeedVideoWidget> {
  File? _thumbnailFile;
  bool _isLoadingThumbnail = false;
  String? _thumbnailPath;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }



  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.videoUrl != oldWidget.videoUrl) {
      if (mounted) {
        _thumbnailFile = null;
        _thumbnailPath = null;
        _generateThumbnail();
      }
    }
  }

  @override
  void dispose() {
    // Clean up thumbnail file if needed
    if (_thumbnailPath != null) {
      try {
        File(_thumbnailPath!).delete();
      } catch (e) {
        // Ignore errors when deleting file
      }
    }
    super.dispose();
  }

  Future<void> _generateThumbnail() async {
    if (widget.videoUrl.isEmpty || _isLoadingThumbnail) return;

    setState(() {
      _isLoadingThumbnail = true;
    });

    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final thumbnailPath = '${tempDir.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Generate thumbnail
      final thumbnailFile = await VideoThumbnail.thumbnailFile(
        video: widget.videoUrl,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 300,
        quality: 75,
      );

      if (thumbnailFile != null && mounted) {
        setState(() {
          _thumbnailPath = thumbnailFile;
          _thumbnailFile = File(thumbnailFile);
          _isLoadingThumbnail = false;
        });
      } else {
        setState(() {
          _isLoadingThumbnail = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingThumbnail = false;
        });
      }
      print('Error generating thumbnail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return videoMoment();
  }

  Widget videoMoment() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.px,
      ),
      child: GestureDetector(
        onTap: () {
          CommonVideoPage.show(widget.videoUrl);
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Background container
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Adapt.px(12),
                  ),
                ),
              ),
              width: 210.px,
              height: 154.px,
            ),
            
            // Thumbnail image
            _getPicWidget(),
            
            // Loading indicator
            if (_isLoadingThumbnail)
              Container(
                width: 210.px,
                height: 154.px,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      Adapt.px(12),
                    ),
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),
              ),
            
            // Play button
            CommonImage(
              iconName: 'play_feed_icon.png',
              size: 60.0.px,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPicWidget() {
    if (_thumbnailFile == null) return const SizedBox();
    
    return Container(
      width: 210.px,
      height: 154.px,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        child: Image.file(
          _thumbnailFile!,
          width: 210.px,
          height: 154.px,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 210.px,
              height: 154.px,
              color: Colors.grey.shade400,
              child: Icon(
                Icons.video_library,
                color: Colors.grey.shade600,
                size: 40.px,
              ),
            );
          },
        ),
      ),
    );
  }
}
