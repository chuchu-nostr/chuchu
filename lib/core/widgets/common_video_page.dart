import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../manager/common_file_cache_manager.dart';
import '../utils/navigator/navigator.dart';
import 'chuchu_Loading.dart';
import 'common_image.dart';


class CommonVideoPage extends StatefulWidget {
  final String videoUrl;
  const CommonVideoPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<CommonVideoPage> createState() => _CommonVideoPageState();

  static show(String videoUrl, {BuildContext? context}) {
    return ChuChuNavigator.presentPage(
      context,
          (context) => CommonVideoPage(videoUrl: videoUrl),
      fullscreenDialog: true,
    );
  }
}

class _CommonVideoPageState extends State<CommonVideoPage> {
  final GlobalKey<_CustomControlsState> _customControlsKey = GlobalKey<_CustomControlsState>();
  ChewieController? _chewieController;
  late VideoPlayerController _videoPlayerController;
  int? bufferDelay;

  Color bgColor = Color(0xFF5B5B5B);
  
  // Video cache state
  bool _isCaching = false;
  double _cacheProgress = 0.0;
  bool _isCached = false;
  String? _cacheStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializePlayer();
    });
  }

  @override
  void dispose() {
    ChuChuLoading.dismiss();
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _onVideoTap() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _customControlsKey.currentState?.showControls();
    } else {
      _videoPlayerController.play();
      _customControlsKey.currentState?.showControls();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isShowVideoWidget = _chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized;
    if (!isShowVideoWidget) {
      ChuChuLoading.show();
      return Container(
        color: bgColor,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Close button
            Positioned(
              top: 70,
              left: 10,
              child: GestureDetector(
                onTap: () => ChuChuNavigator.pop(context),
                child: CommonImage(
                  iconName: 'circle_close_icon.png',
                  size: 24.px,
                  color: Colors.white,
                ),
              ),
            ),
            
            // Cache status display
            if (_cacheStatus != null)
              Positioned(
                top: 120,
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8.px),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isCached ? Icons.check_circle : Icons.download,
                            color: _isCached ? Colors.green : Colors.blue,
                            size: 20.px,
                          ),
                          SizedBox(width: 8.px),
                          Expanded(
                            child: Text(
                              _cacheStatus!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.px,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_isCaching)
                        Container(
                          margin: EdgeInsets.only(top: 8.px),
                          child: LinearProgressIndicator(
                            value: _cacheProgress,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    ChuChuLoading.dismiss();
    Size size = MediaQuery.of(context).size;
    return Container(
      color: bgColor,
      child: Stack(
        children: [
          GestureDetector(
            onTap: _onVideoTap,
            child: SafeArea(
              child: Chewie(
                controller: _chewieController!,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 70),
            padding: EdgeInsets.symmetric(horizontal: 10.px),
            height: 40,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => ChuChuNavigator.pop(context),
                  child: CommonImage(
                    iconName: 'video_del_icon.png',
                    size: 24.px,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => ChuChuNavigator.pop(context),
                      child: CommonImage(
                        iconName: 'setting_icon.png',
                        size: 24.px,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Future<void> initializePlayer() async {
    try {
      if (RegExp(r'https?:\/\/').hasMatch(widget.videoUrl)) {
        // Check if video is already cached
        final fileInfo = await ChuChuFileCacheManager.get().getFileFromCache(widget.videoUrl);
        if (fileInfo != null) {
          _isCached = true;
          _cacheStatus = 'Video loaded from cache';
          _videoPlayerController = VideoPlayerController.file(fileInfo.file);
          print('Video loaded from cache: ${fileInfo.file.path}');
        } else {
          _isCached = false;
          _cacheStatus = 'Loading video from network...';
          _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
          // Start caching in background
          _startCaching();
        }
      } else {
        // Local file
        File videoFile = File(widget.videoUrl);
        _isCached = true;
        _cacheStatus = 'Local video file';
        _videoPlayerController = VideoPlayerController.file(videoFile);
      }
      
      await Future.wait([_videoPlayerController.initialize()]);
      _createChewieController();
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing video player: $e');
      _cacheStatus = 'Error: $e';
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _startCaching() {
    if (!_isCaching) {
      _isCaching = true;
      _cacheProgress = 0.0;
      _cacheStatus = 'Starting cache...';
      setState(() {});
      cacheVideo();
    }
  }

  Future<void> cacheVideo() async {
    try {
      print('Starting video cache process...');
      _cacheStatus = 'Downloading video...';
      setState(() {});
      
      // Start caching with progress tracking
      await ChuChuFileCacheManager.get().downloadFile(widget.videoUrl);
      
      _isCaching = false;
      _isCached = true;
      _cacheProgress = 1.0;
      _cacheStatus = 'Video cached successfully';
      
      print('Video cached successfully');
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error caching video: $e');
      _isCaching = false;
      _cacheStatus = 'Cache failed: $e';
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      customControls: CustomControls(
        key: _customControlsKey,
        videoPlayerController: _videoPlayerController,
        videoUrl: widget.videoUrl,
        isCached: _isCached,
        onCachePressed: _handleCacheAction,
      ),
      showControls: true,
      videoPlayerController: _videoPlayerController,
      hideControlsTimer: const Duration(seconds: 3),
      autoPlay: true,
      looping: false,
    );
  }

  void _handleCacheAction() {
    if (_isCached) {
      // Show cache info or clear cache option
      _showCacheInfo();
    } else {
      // Start caching if not already cached
      _startCaching();
    }
  }

  void _showCacheInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Video Cache Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Video is cached locally'),
            SizedBox(height: 16.px),
            Text('Cache location: ${_getCachePath()}'),
            SizedBox(height: 16.px),
            Text('Cache status: ${_cacheStatus ?? "Unknown"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearCache();
            },
            child: Text('Clear Cache'),
          ),
        ],
      ),
    );
  }

  String _getCachePath() {
    try {
      final fileInfo = ChuChuFileCacheManager.get().getFileFromCache(widget.videoUrl);
      return fileInfo.then((info) => info?.file.path ?? 'Unknown').toString();
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<void> _clearCache() async {
    try {
      await ChuChuFileCacheManager.get().removeFile(widget.videoUrl);
      _isCached = false;
      _cacheStatus = 'Cache cleared';
      setState(() {});
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}

class CustomControlsOption {
  bool isDragging;
  bool isVisible;
  CustomControlsOption({required this.isDragging, required this.isVisible});
}

class CustomControls extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final String videoUrl;
  final bool isCached;
  final VoidCallback? onCachePressed;
  
  const CustomControls({
    Key? key, 
    required this.videoPlayerController, 
    required this.videoUrl,
    this.isCached = false,
    this.onCachePressed,
  }) : super(key: key);

  @override
  _CustomControlsState createState() => _CustomControlsState();
}

class _CustomControlsState extends State<CustomControls> {
  ValueNotifier<CustomControlsOption> customControlsStatus =
  ValueNotifier(CustomControlsOption(
    isVisible: true,
    isDragging: false,
  ));

  Timer? _hideTimer;
  List<double> videoSpeedList = [0.5, 1.0, 1.5, 2.0];
  ValueNotifier<double> videoSpeedNotifier = ValueNotifier(1.0);

  @override
  void initState() {
    super.initState();
    widget.videoPlayerController.addListener(() {
      if (!widget.videoPlayerController.value.isPlaying &&
          !customControlsStatus.value.isDragging) {
        customControlsStatus.value = CustomControlsOption(
          isVisible: true,
          isDragging: false,
        );
      }
      if (mounted) {
        setState(() {});
      }
    });
    hideControlsAfterDelay();
  }

  void hideControlsAfterDelay() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      customControlsStatus.value = CustomControlsOption(
        isVisible: false,
        isDragging: customControlsStatus.value.isDragging,
      );
    });
  }

  void showControls() {
    customControlsStatus.value = CustomControlsOption(
      isVisible: true,
      isDragging: customControlsStatus.value.isDragging,
    );
    hideControlsAfterDelay();
  }

  void _toggleControls() {
    if (customControlsStatus.value.isVisible &&
        widget.videoPlayerController.value.isPlaying) {
      hideControlsAfterDelay();
    } else {
      customControlsStatus.value = CustomControlsOption(
        isVisible: false,
        isDragging: customControlsStatus.value.isDragging,
      );
      _hideTimer?.cancel();
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: _toggleControls,
            child: Container(),
          ),
        ),
        _buildProgressBar(),
        _buildBottomOption(),
      ],
    );
  }

  Widget _buildBottomOption() {
    return ValueListenableBuilder<CustomControlsOption>(
      valueListenable: customControlsStatus,
      builder: (context, value, child) {
        if (!value.isVisible) return Container();
        return Positioned(
          bottom: 10.0,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Share button
              GestureDetector(
                onTap: () => ChuChuNavigator.pop(context),
                child: CommonImage(
                  iconName: 'share_white_icon.png',
                  size: 24.px,
                ),
              ),
              _buildPlayPause(),
              GestureDetector(
                onTap: toggleFullScreen,
                child: CommonImage(
                  iconName: 'video_screen_icon.png',
                  size: 24.px,
                ),
                // onTap: () async {
                  // await ChuChuLoading.show();
                  // if (RegExp(r'https?:\/\/').hasMatch(widget.videoUrl)) {
                  //   var result;
                  //   final fileInfo = await ChuChuFileCacheManager.get()
                  //       .getFileFromCache(widget.videoUrl);
                  //   if (fileInfo != null) {
                  //     result =
                  //     await ImageGallerySaverPlus.saveFile(fileInfo.file.path);
                  //   } else {
                  //     var appDocDir = await getTemporaryDirectory();
                  //     String savePath = appDocDir.path + "/temp.mp4";
                  //     await Dio().download(widget.videoUrl, savePath);
                  //     result = await ImageGallerySaverPlus.saveFile(savePath);
                  //   }
                  //
                  //   if (result['isSuccess'] == true) {
                  //     await ChuChuLoading.dismiss();
                  //     CommonToast.instance.show(context, 'Save successful');
                  //   }
                  // } else {
                  //   final result =
                  //   await ImageGallerySaverPlus.saveFile(widget.videoUrl);
                  //   if (result['isSuccess'] == true) {
                  //     await ChuChuLoading.dismiss();
                  //     CommonToast.instance.show(context, 'Save successful');
                  //   }
                  // }
                // },

              ),
            ],
          ),
        );
      },
    );
  }

  void toggleFullScreen() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  Widget _buildPlayPause() {
    return ValueListenableBuilder<CustomControlsOption>(
      valueListenable: customControlsStatus,
      builder: (context, value, child) {
        String iconName = 'video_palyer_icon.png';

        if (widget.videoPlayerController.value.isPlaying ||
            value.isDragging ||
            !value.isVisible) {
          iconName = 'video_stop_icon.png';
        }
        return GestureDetector(
          onTap: () {
            if (widget.videoPlayerController.value.isPlaying) {
              widget.videoPlayerController.pause();

              showControls();
            } else {
              widget.videoPlayerController.play();

              hideControlsAfterDelay();
            }
          },
          child: CommonImage(
            iconName: iconName,
            size: 30.px,
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return ValueListenableBuilder<CustomControlsOption>(
      valueListenable: customControlsStatus,
      builder: (context, value, child) {
        if (!value.isVisible) return Container();
        return Positioned(
          bottom: 40.0,
          left: 0,
          right: 0,
          child:
          Column(
            children: [
              Container(
                child: CustomVideoProgressIndicator(
                  controller: widget.videoPlayerController,
                  callback: _progressCallback,
                ),
              ).setPadding(
                EdgeInsets.symmetric(horizontal: 10.px),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10.px),
                    width: 45.px,
                    child: Text(
                      _formatDuration(
                          widget.videoPlayerController.value.position),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: 45.px,
                    margin: EdgeInsets.only(right: 10.px),
                    child: Text(
                      _formatDuration(
                          widget.videoPlayerController.value.duration),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ).setPaddingOnly(bottom: 20.px),

            ],
          ),
        );
      },
    );
  }

  void _progressCallback(bool isStart) {
    if (isStart) {
      _hideTimer?.cancel();
      if (widget.videoPlayerController.value.isPlaying) {
        widget.videoPlayerController.pause();
      }
    } else {
      if (!widget.videoPlayerController.value.isPlaying) {
        widget.videoPlayerController.play();
      }
      hideControlsAfterDelay();
    }
    customControlsStatus.value = CustomControlsOption(
      isDragging: isStart,
      isVisible: customControlsStatus.value.isVisible,
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}

class CustomVideoProgressIndicator extends StatelessWidget {
  final VideoPlayerController controller;
  final Function callback;

  const CustomVideoProgressIndicator(
      {super.key, required this.controller, required this.callback});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.position.asStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        Duration position = snapshot.data ?? Duration.zero;
        final totalDuration = controller.value.duration.inMilliseconds;
        double progress = 0;
        if (totalDuration != 0) {
          progress = position.inMilliseconds / controller.value.duration.inMilliseconds;
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (details) {
                callback(true);
                _dragUpdate(context, constraints, details);
              },
              onHorizontalDragEnd: (details) {
                callback(false);
              },
              onHorizontalDragUpdate: (details) =>
                  _dragUpdate(context, constraints, details),
              child: SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 5, // Thin progress bar
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: LinearProgressIndicator(
                          value: progress,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    Positioned(
                      left: constraints.maxWidth * progress -
                          10, // Adjust for circle size
                      child: GestureDetector(
                        onPanUpdate: (details) =>
                            _dragUpdate(context, constraints, details),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _dragUpdate(context, constraints, details) {
    final RenderBox boxChuChu = context.findRenderObject() as RenderBox;
    final Offset offset = boxChuChu.globalToLocal(details.globalPosition);
    double newProgress = offset.dx / constraints.maxWidth;
    if (newProgress < 0) newProgress = 0;
    if (newProgress > 1) newProgress = 1;
    controller.seekTo(controller.value.duration * newProgress);
  }
}
