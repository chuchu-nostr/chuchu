import 'dart:math' as math;

import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:google_fonts/google_fonts.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../manager/cache/chuchu_cache_manager.dart';
import '../theme/app_theme.dart';
import '../utils/feed_utils.dart';

export 'package:pull_to_refresh/src/smart_refresher.dart';

class ChuChuSmartRefresher extends StatelessWidget {
  ChuChuSmartRefresher({
    Key? key,
    required this.controller,
    this.child,
    this.header,
    this.footer,
    this.enablePullDown,
    this.enablePullUp,
    this.enableTwoLevel,
    this.onRefresh,
    this.onLoading,
    this.onTwoLevel,
    this.scrollController,
  }) : super(key: key);

  final RefreshController controller;
  final Widget? child;
  final Widget? header;
  final Widget? footer;
  final bool? enablePullDown;
  final bool? enablePullUp;
  final bool? enableTwoLevel;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final OnTwoLevel? onTwoLevel;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      scrollController: scrollController,
      controller: controller,
      header: header ?? refresherHeader,
      footer: footer ?? refresherFooter,
      enablePullDown: enablePullDown ?? true,
      enablePullUp: enablePullUp ?? false,
      enableTwoLevel: enableTwoLevel ?? false,
      onRefresh: onRefresh,
      onLoading: onLoading,
      onTwoLevel: onTwoLevel,
      child: child,
    );
  }

  Widget get refresherHeader {
    return LoadingHeader();
  }

  Widget get refresherFooter {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        final theme = Theme.of(context);
        Widget body;

        if (mode == LoadStatus.idle) {
          body = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.touch_app,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                size: 18,
              ),
              SizedBox(width: 6),
              Icon(
                Icons.keyboard_arrow_up,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Pull up to load more",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_up,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                size: 20,
              ),
              SizedBox(width: 6),
              Icon(
                Icons.touch_app,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                size: 18,
              ),
            ],
          );
        } else if (mode == LoadStatus.loading) {
          body = _LoadingDotsWidget(text: 'Discovering...');
        } else if (mode == LoadStatus.failed) {
          body = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                color: theme.colorScheme.error.withOpacity(0.7),
                size: 16,
              ),
              SizedBox(width: 6),
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "Load failed, tap to retry",
                style: TextStyle(color: theme.colorScheme.error, fontSize: 14),
              ),
              SizedBox(width: 8),
              Icon(Icons.refresh, color: theme.colorScheme.error, size: 16),
            ],
          );
        } else if (mode == LoadStatus.canLoading) {
          body = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.flash_on,
                color: theme.colorScheme.primary.withOpacity(0.8),
                size: 16,
              ),
              SizedBox(width: 6),
              Icon(
                Icons.keyboard_arrow_down,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Release to load",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 6),
              Icon(
                Icons.flash_on,
                color: theme.colorScheme.primary.withOpacity(0.8),
                size: 16,
              ),
            ],
          );
        } else {
          body = Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                Container(
                  width: 50,
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.withOpacity(0.3)],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CommonImage(
                  iconName: 'start_ill_icon.png',
                  size: 12,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "No more data",
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                CommonImage(
                  iconName: 'start_ill_icon.png',
                  size: 12,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: 8),
                Container(
                  width: 50,
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.withOpacity(0.3), Colors.white],
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          );
        }

        return Container(height: 55.0, child: Center(child: body));
      },
    );
  }
}

class LoadingHeader extends RefreshIndicator {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoadingHeaderState();
  }
}

class LoadingHeaderState extends RefreshIndicatorState<LoadingHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  int? refreshTime;

  @override
  void initState() {
    // TODO: implement initState
    // init frame is 2
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _getUpdateTime();
  }

  @override
  Future<void> endRefresh() {
    // TODO: implement endRefresh
    _controller.value = 1;
    _controller.stop();
    return super.endRefresh();
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    if (mode == RefreshStatus.canRefresh) {
      _controller.repeat();
    } else if (mode == RefreshStatus.refreshing) {
      _controller.repeat();
    } else if (mode == RefreshStatus.completed) {
      _controller.stop();
      ChuChuCacheManager.defaultOXCacheManager.saveData(
        "pull_refresh_time",
        DateTime.now().millisecondsSinceEpoch,
      );
      setState(() {
        refreshTime = DateTime.now().millisecondsSinceEpoch;
      });
    } else {
      _controller.stop();
    }
    super.onModeChange(mode);
  }

  _getUpdateTime() {
    ChuChuCacheManager.defaultOXCacheManager
        .getData("pull_refresh_time", defaultValue: null)
        .then((value) {
          if (value != null) {
            setState(() {
              refreshTime = value;
            });
          }
        });
  }

  @override
  void resetValue() {
    // TODO: implement resetValue
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    final theme = Theme.of(context);

    return Column(
      children: [_LoadingDotsWidget(text: _getRefreshTimeString())],
    );
  }

  _getRefreshTimeString() {
    if (refreshTime != null) {
      if (DateUtils.isSameDay(
        DateTime.fromMillisecondsSinceEpoch(refreshTime!),
        DateTime.now(),
      )) {
        return 'Last updated: Today ${FeedUtils.formatTimestamp(refreshTime!)}';
      } else {
        return 'Last updated: ${FeedUtils.formatTimestamp(refreshTime!)}';
      }
    }

    return "";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

/// Loading dots widget with bouncing animation
class _LoadingDotsWidget extends StatefulWidget {
  final String text;

  const _LoadingDotsWidget({required this.text});

  @override
  State<_LoadingDotsWidget> createState() => _LoadingDotsWidgetState();
}

class _LoadingDotsWidgetState extends State<_LoadingDotsWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _BouncingDot(
              controller: _controller,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kGradientColors[0], // Pink
                  kGradientColors[1], // Magenta
                ],
              ),
              delay: 0.0,
            ),
            SizedBox(width: 6),
            _BouncingDot(
              controller: _controller,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kGradientColors[1], // Magenta
                  kGradientColors[2], // Purple
                ],
              ),
              delay: 0.15,
            ),
            SizedBox(width: 6),
            _BouncingDot(
              controller: _controller,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kGradientColors[2], // Purple
                  kGradientColors[0], // Pink (cycle back)
                ],
              ),
              delay: 0.3,
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          widget.text,
          style: GoogleFonts.inter(
            color: kTitleColor,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ],
    ).setPaddingOnly(bottom: 20);
  }
}

class _BouncingDot extends StatelessWidget {
  final AnimationController controller;
  final Gradient gradient;
  final double delay;

  const _BouncingDot({
    required this.controller,
    required this.gradient,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double t = (controller.value + delay) % 1.0;

        double bounceValue = (math.sin(t * 2 * math.pi) + 1) / 2;

        double yOffset = -8 * bounceValue;

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
            ),
          ),
        );
      },
    );
  }
}
