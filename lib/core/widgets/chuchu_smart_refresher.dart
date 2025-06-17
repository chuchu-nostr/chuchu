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
    return ClassicFooter(
        idleText: 'Pull up to load more',
        loadingText: 'Loading',
        noDataText: "-------- It's all down to the bottom --------",
        failedText: "Failure",
        canLoadingText: "Release and load",
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
          child: Text(_getRefreshTimeString(),style: TextStyle(
              color: Colors.black,
              fontSize: 12.px,
          ),),
        )
      ],
    );
  }


  _getRefreshTimeString(){

    if(refreshTime != null){
      String lastFresh = 'Last updated:';
      if(DateUtils.isSameDay(DateTime.fromMillisecondsSinceEpoch(refreshTime!), DateTime.now())){
        lastFresh = lastFresh + 'Today' + FeedUtils.formatTimestamp(refreshTime!);
      }else{
        lastFresh = lastFresh + FeedUtils.formatTimestamp(refreshTime!);
      }
      return lastFresh;
    }


    return "";

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
