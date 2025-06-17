
import 'package:flutter/cupertino.dart';

import 'navigator.dart';

mixin NavigatorObserverMixin<T extends StatefulWidget> on State<T> implements RouteAware {

  NavigatorState? get navigator => Navigator.of(context);
  Route? get route => ModalRoute.of(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = this.route;
    if (route != null) {
      ChuChuNavigator.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    if (mounted) {
      removeObserver();
    }
    super.dispose();
  }

  void removeObserver() {
    ChuChuNavigator.routeObserver.unsubscribe(this);
  }

  @protected
  void didPopNext() { }

  @protected
  void didPush() { }

  @protected
  void didPop() { }

  @protected
  void didPushNext() { }
}