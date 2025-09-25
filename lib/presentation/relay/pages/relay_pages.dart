import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/material.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/relayDB_isar.dart';
import '../../../core/account/relays.dart';
import '../../../core/network/connect.dart';
import '../../../core/utils/navigator/navigator_observer_mixin.dart';
import '../widgets/ping_delay_time_widget.dart';


class RelaysPage extends StatefulWidget {
  const RelaysPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RelaysPageState();
  }
}

class _RelaysPageState extends State<RelaysPage> with WidgetsBindingObserver, NavigatorObserverMixin {
  final PingLifecycleController _pingLifecycleController = PingLifecycleController();
  
  // Only show recommendGroupRelays
  List<RelayDBISAR> _groupRelays = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initDefault();
    Connect.sharedInstance.addConnectStatusListener((relay, status, relayKinds) {
      didRelayStatusChange(relay, status);
    });

    Account.sharedInstance.relayListUpdateCallback = _initDefault;
    Account.sharedInstance.dmRelayListUpdateCallback = _initDefault;
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pingLifecycleController.isPaused.dispose();
    super.dispose();
  }

  void _initDefault() async {
    // Only initialize group relays from recommendGroupRelays
    _groupRelays = Relays.sharedInstance.recommendGroupRelays.map((url) => RelayDBISAR(url: url)).toList();
    if (mounted) setState(() {});
  }


  void didRelayStatusChange(String relay, int status) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Servers',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: double.infinity,
            ),
            child: PingInheritedWidget(
              controller: _pingLifecycleController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 32.px, bottom: 16.px),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Relays',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16.px,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.px),
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                              blurRadius: 8.px,
                              offset: Offset(0, 2.px),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: _groupRelayItemBuild,
                          itemCount: _groupRelays.length,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      SizedBox(height: 32.px),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: 16.px),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'File Server',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16.px,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _buildFileServerSection(),
                    ],
                  ).setPadding(EdgeInsets.symmetric(horizontal: 18.0)),
                ],
              ).setPadding(
                  EdgeInsets.only(bottom: Adapt.px(24))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _groupRelayItemBuild(BuildContext context, int index) {
    final theme = Theme.of(context);
    RelayDBISAR _model = _groupRelays[index];
    final host = _model.url.split('//').last;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 16.px),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.px),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.px),
                ),
                child: Icon(
                  Icons.link,
                  size: 24.px,
                  color: theme.colorScheme.primary,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.px),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _model.url,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16.px,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      PingDelayTimeWidget(
                        host: host,
                        controller: _pingLifecycleController,
                      ).setPaddingOnly(top: 6.px)
                    ],
                  ),
                ),
              ),
              // Show connection status (read-only)
              Container(
                padding: EdgeInsets.all(8.px),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.px),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 20.px,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        _groupRelays.length > 1 && _groupRelays.length - 1 != index
            ? Divider(
          height: 1.px,
          color: theme.dividerColor.withValues(alpha: 0.1),
        )
            : Container(),
      ],
    );
  }





  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _pingLifecycleController.isPaused.value = true;
    } else if (state == AppLifecycleState.resumed) {
      _pingLifecycleController.isPaused.value = false;
    }
  }

  @override
  void didPushNext() {
    _pingLifecycleController.isPaused.value = true;
  }

  @override
  void didPopNext() {
    _pingLifecycleController.isPaused.value = false;
  }

  Widget _buildFileServerSection() {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.px),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8.px,
            offset: Offset(0, 2.px),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 16.px),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.px),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.px),
                  ),
                  child: Icon(
                    Icons.storage,
                    size: 24.px,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.px),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'File Storage Server',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 16.px,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        PingDelayTimeWidget(
                          host: 'file.chuchu.app',
                          controller: _pingLifecycleController,
                        ).setPaddingOnly(top: 6.px)
                      ],
                    ),
                  ),
                ),
                // Show connection status (read-only)
                Container(
                  padding: EdgeInsets.all(8.px),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.px),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 20.px,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum RelayType {
  general,
  dm,
  outbox,
  inbox,
}

extension RelayTypeExtension on RelayType {
  String name() {
    switch (this) {
      case RelayType.dm:
        return 'DM Relays';
      case RelayType.general:
        return 'App Relays';
      case RelayType.inbox:
        return 'Inbox Relays';
      case RelayType.outbox:
        return 'Outbox Relays';
    }
  }

  String sign() {
    switch (this) {
      case RelayType.dm:
        return 'DM';
      case RelayType.general:
        return 'APP';
      case RelayType.inbox:
        return 'INBOX';
      case RelayType.outbox:
        return 'OUTBOX';
    }
  }
}


class RelayConnectStatus {
  static final int connecting = 0;
  static final int open = 1;
  static final int closing = 2;
  static final int closed = 3;
}
