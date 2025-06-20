import 'package:chuchu/core/utils/adapt.dart';
import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:lottie/lottie.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../manager/cache/chuchu_cache_manager.dart';
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
        scrollController:scrollController,
        controller: controller,
        header: header ?? refresherHeader,
        footer: footer ?? refresherFooter,
        enablePullDown: enablePullDown ?? true,
        enablePullUp: enablePullUp ?? false,
        enableTwoLevel: enableTwoLevel ?? false,
        onRefresh: onRefresh,
        onLoading: onLoading,
        onTwoLevel: onTwoLevel,
        child: child
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
          body = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.download,
                color: theme.colorScheme.primary.withOpacity(0.7),
                size: 16,
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Loading...",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 12),
              Icon(
                Icons.cloud_download,
                color: theme.colorScheme.primary.withOpacity(0.5),
                size: 16,
              ),
            ],
          );
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
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.refresh,
                color: theme.colorScheme.error,
                size: 16,
              ),
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
                Icon(
                  Icons.star,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  size: 12,
                ),
                SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 1,
                  color: theme.dividerColor,
                ),
                SizedBox(width: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "No more data",
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 1,
                  color: theme.dividerColor,
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.star,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  size: 12,
                ),
              ],
            ),
          );
        }
        
        return Container(
          height: 55.0,
          child: Center(child: body),
        );
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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
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
    // TODO: implement onModeChange
    if (mode == RefreshStatus.canRefresh) {
      _controller.repeat();
    }else if(mode == RefreshStatus.completed){
      ChuChuCacheManager.defaultOXCacheManager.saveData("pull_refresh_time", DateTime.now().millisecondsSinceEpoch);
      setState(() {
        refreshTime = DateTime.now().millisecondsSinceEpoch;
      });

    }
    super.onModeChange(mode);
  }

  _getUpdateTime(){

    ChuChuCacheManager.defaultOXCacheManager.getData("pull_refresh_time",defaultValue: null).then((value){

      if(value != null){

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
    // TODO: implement buildContent
    return Column(
      children: [
        Lottie.asset(
          "assets/chuchu_pull_loading.json",
          width: 72.px,
          repeat: true,
          fit: BoxFit.fitWidth,
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration ??= composition.duration;
          },
        ),
        Container(
          margin: EdgeInsets.only(top: 4.px),
          child: Text(
            _getRefreshTimeString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12.px,
            ),
          ),
        )
      ],
    );
  }


  _getRefreshTimeString(){

    if(refreshTime != null){
      if(DateUtils.isSameDay(DateTime.fromMillisecondsSinceEpoch(refreshTime!), DateTime.now())){
        return 'Last updated: Today ${FeedUtils.formatTimestamp(refreshTime!)}';
      }else{
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
