import 'package:chuchu/core/account/account+relay.dart';
import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/presentation/relay/pages/relay_recommend_widget.dart';
import 'package:chuchu/presentation/relay/pages/relay_select_table_tabBar.dart';
import 'package:flutter/material.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/relayDB_isar.dart';
import '../../../core/network/connect.dart';
import '../../../core/utils/navigator/navigator_observer_mixin.dart';
import '../../../core/widgets/common_image.dart';
import '../../../core/widgets/common_toast.dart';
import '../widgets/ping_delay_time_widget.dart';


class RelaysPage extends StatefulWidget {
  const RelaysPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RelaysPageState();
  }
}

class _RelaysPageState extends State<RelaysPage> with WidgetsBindingObserver, NavigatorObserverMixin {
  final TextEditingController _relayTextFieldControll = TextEditingController();
  final Map<RelayType, List<RelayDBISAR>> _relayListMap = {
    RelayType.general: [],
    RelayType.dm: [],
    RelayType.outbox: [],
    RelayType.inbox: []
  };
  final Map<RelayType, List<RelayDBISAR>> _recommendRelayListMap = {
    RelayType.general: [],
    RelayType.dm: [],
    RelayType.outbox: [],
    RelayType.inbox: []
  };
  bool _isEditing = false;
  bool _isShowDelete = false;
  RelayType _relayType = RelayType.outbox;
  final PingLifecycleController _pingLifecycleController = PingLifecycleController();

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

  void _relayTypeChanged(int index) {
    setState(() {
      _relayType = RelayType.values[index];
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pingLifecycleController.isPaused.dispose();
    super.dispose();
  }

  void _initDefault() async {
    for (var relayType in RelayType.values) {
      _initRelayList(relayType);
    }
    if (mounted) setState(() {});
  }

  void _initRelayList(RelayType relayType) {
    List<RelayDBISAR> relayList = _getRelayList(relayType);
    List<RelayDBISAR> recommendRelayList = _getRecommendRelayList(relayType);

    //Filters elements in the relay LIst
    recommendRelayList.removeWhere((recommendRelay) {
      return relayList.any((relay) => relay.url == recommendRelay.url);
    });

    _relayListMap[relayType] = relayList;
    _recommendRelayListMap[relayType] = recommendRelayList;
  }

  List<RelayDBISAR> _getRelayList(RelayType relayType) {
    switch (relayType) {
      case RelayType.general:
        return Account.sharedInstance.getMyGeneralRelayList();
      case RelayType.dm:
        return Account.sharedInstance.getMyDMRelayList();
      case RelayType.inbox:
        return Account.sharedInstance.getMyInboxRelayList();
      case RelayType.outbox:
        return Account.sharedInstance.getMyOutboxRelayList();
      default:
        return [];
    }
  }

  List<RelayDBISAR> _getRecommendRelayList(RelayType relayType) {
    switch (relayType) {
      case RelayType.general:
        return Account.sharedInstance.getMyRecommendGeneralRelaysList();
      case RelayType.dm:
        return Account.sharedInstance.getMyRecommendDMRelaysList();
      case RelayType.inbox:
        return Account.sharedInstance.getMyRecommendDMRelaysList();
      case RelayType.outbox:
        return Account.sharedInstance.getMyRecommendDMRelaysList();
      default:
        return [];
    }
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
          'Relays',
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
    List<RelayDBISAR> relayList = _relayListMap[_relayType]!;
    List<RelayDBISAR> recommendRelayList = _recommendRelayListMap[_relayType]!;
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
                  // RelaySelectTableTabBar(
                  //   tabs: RelayType.values.map((e) => e.name()).toList(),
                  //   onChanged: _relayTypeChanged,
                  // ).setPaddingOnly(top: 16.px),
                 Column(
                   children: [
                     Container(
                       width: double.infinity,
                       padding: EdgeInsets.only(top: 32.px, bottom: 16.px),
                       alignment: Alignment.centerLeft,
                       child: Text(
                         // Localized.text('ox_usercenter.connect_relay'),
                         'CONNECT TO ${_relayType.sign()} RELAY',
                         style: TextStyle(
                           color: Theme.of(context).colorScheme.onSurface,
                           fontSize: 14.px,
                           fontWeight: FontWeight.w600,
                           letterSpacing: 0.5,
                         ),
                       ),
                     ),
                     _inputRelay(),
                     SizedBox(
                       height: Adapt.px(12),
                     ),
                     _isShowDelete
                         ? Container(
                       margin: EdgeInsets.only(top: 16.px),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Expanded(
                             child: GestureDetector(
                               onTap: () {
                                 setState(() {
                                   _relayTextFieldControll.text = '';
                                   _isShowDelete = false;
                                 });
                               },
                               child: Container(
                                 height: 44.px,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(12.px),
                                   color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                                   border: Border.all(
                                     color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                                     width: 1.px,
                                   ),
                                 ),
                                 alignment: Alignment.center,
                                 child: Text(
                                   'Cancel',
                                   style: TextStyle(
                                     fontSize: 14.px,
                                     fontWeight: FontWeight.w500,
                                     color: Theme.of(context).colorScheme.onSurface,
                                   ),
                                 ),
                               ),
                             ),
                           ),
                           SizedBox(width: 12.px),
                           Expanded(
                             child: GestureDetector(
                               behavior: HitTestBehavior.translucent,
                               onTap: () => _addOnTap(isUserInput: true),
                               child: Container(
                                 height: 44.px,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(12.px),
                                   color: Theme.of(context).colorScheme.primary,
                                   boxShadow: [
                                     BoxShadow(
                                       color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                                       blurRadius: 8.px,
                                       offset: Offset(0, 2.px),
                                     ),
                                   ],
                                 ),
                                 alignment: Alignment.center,
                                 child: Text(
                                   'Add',
                                   style: TextStyle(
                                     fontSize: 14.px,
                                     fontWeight: FontWeight.w600,
                                     color: Theme.of(context).colorScheme.onPrimary,
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         ],
                       ),
                     )
                         : Container(),
                     if (relayList.isNotEmpty) ...[
                       Container(
                         width: double.infinity,
                         padding: EdgeInsets.only(top: 32.px, bottom: 16.px),
                         alignment: Alignment.centerLeft,
                         child: Text(
                           // Localized.text('ox_usercenter.connected_relay'),
                           'CONNECTED TO ${_relayType.sign()} RELAY',
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
                           itemBuilder: _itemBuild,
                           itemCount: relayList.length,
                           padding: EdgeInsets.zero,
                         ),
                       ),
                     ],
                     if (recommendRelayList.isNotEmpty)
                       RelayCommendWidget(recommendRelayList, (RelayDBISAR relayDB) {
                         _addOnTap(upcomingRelay: relayDB.url);
                       }),
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

  Widget _itemBuild(BuildContext context, int index) {
    final theme = Theme.of(context);
    List<RelayDBISAR> relayList = _relayListMap[_relayType]!;
    RelayDBISAR _model = relayList[index];
    final host = _model.url.split('//').last;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // if (!_isEditing) {
            //   ChuChuNavigator.pushPage(
            //       context,
            //           (context) => RelayDetailPage(
            //         relayURL: _model.url,
            //       ));
            // }
          },
          child: Container(
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
                _relayStateImage(_model),
              ],
            ),
          ),
        ),
        relayList.length > 1 && relayList.length - 1 != index
            ? Divider(
          height: 1.px,
          color: theme.dividerColor.withValues(alpha: 0.1),
        )
            : Container(),
      ],
    );
  }

  Widget _relayStateImage(RelayDBISAR relayDB) {
    final theme = Theme.of(context);
    if (_isEditing) {
      return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _deleteOnTap(relayDB);
          },
          child: Container(
            padding: EdgeInsets.all(8.px),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.px),
            ),
            child: Icon(
              Icons.delete_outline,
              size: 20.px,
              color: Colors.red,
            ),
          ));
    } else {
      if (relayDB.connectStatus == RelayConnectStatus.open) {
        return Container(
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
        );
      } else {
        return Container(
          padding: EdgeInsets.all(8.px),
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.px),
          ),
          child: SizedBox(
            width: 20.px,
            height: 20.px,
            child: CircularProgressIndicator(
              strokeWidth: 2.px,
              backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
        );
      }
    }
  }

  Widget _inputRelay() {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.px),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1.px,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8.px,
            offset: Offset(0, 2.px),
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 4.px),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.px),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.px),
              ),
              child: Icon(
                Icons.content_paste,
                size: 20.px,
                color: theme.colorScheme.primary,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _relayTextFieldControll,
                style: TextStyle(
                  fontSize: 16.px,
                  color: theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'wss://some.relay.com',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 15.px,
                  ),
                  suffixIcon: _isShowDelete
                      ? IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        _relayTextFieldControll.text = '';
                        _isShowDelete = false;
                      });
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 20.px,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  )
                      : null,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 16.px),
                ),
                onChanged: (str) {
                  setState(() {
                    if (str.isNotEmpty) {
                      _isShowDelete = true;
                    } else {
                      _isShowDelete = false;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isWssWithValidURL(String input) {
    RegExp regex = RegExp(r'^(wss?://)([\w-]+\.)+[\w-]+(:\d+)?(/[\w- ./?%&=]*)?$');
    return regex.hasMatch(input);
  }

  void _addOnTap({String? upcomingRelay, bool isUserInput = false}) async {
    upcomingRelay ??= _relayTextFieldControll.text;
    if (upcomingRelay.endsWith('/')) {
      upcomingRelay = upcomingRelay.substring(0, upcomingRelay.length - 1);
    }
    List<RelayDBISAR> relayList = _relayListMap[_relayType]!;
    List<RelayDBISAR> recommendRelayList = _recommendRelayListMap[_relayType]!;
    final upcomingRelays = relayList.map((e) => e.url).toList();
    if (!isWssWithValidURL(upcomingRelay)) {
      CommonToast.instance.show(context, 'Please input the right wss');
      return;
    }
    if (upcomingRelays.contains(upcomingRelay)) {
      CommonToast.instance.show(context, 'This Relay already exists');
    } else {
      switch (_relayType) {
        case RelayType.general:
          await Account.sharedInstance.addGeneralRelay(upcomingRelay);
          break;
        case RelayType.dm:
          await Account.sharedInstance.addDMRelay(upcomingRelay);
          break;
        case RelayType.inbox:
          await Account.sharedInstance.addInboxRelay(upcomingRelay);
          break;
        case RelayType.outbox:
          await Account.sharedInstance.addOutboxRelay(upcomingRelay);
          break;
      }
      recommendRelayList.removeWhere((element) => element.url == upcomingRelay);
      setState(() {
        relayList.add(RelayDBISAR(url: upcomingRelay!));
        if (isUserInput) {
          _relayTextFieldControll.text = '';
          _isShowDelete = false;
        }
      });
    }
  }

  void _deleteOnTap(RelayDBISAR relayModel) async {
    // OXCommonHintDialog.show(context,
    //     title: Localized.text('ox_common.tips'),
    //     content: Localized.text('ox_usercenter.delete_relay_hint'),
    //     actionList: [
    //       OXCommonHintAction.cancel(onTap: () {
    //         OXNavigator.pop(context);
    //       }),
    //       OXCommonHintAction.sure(
    //           text: Localized.text('ox_common.confirm'),
    //           onTap: () async {
    //             switch (_relayType) {
    //               case RelayType.general:
    //                 await Account.sharedInstance.removeGeneralRelay(relayModel.url);
    //                 break;
    //               case RelayType.dm:
    //                 await Account.sharedInstance.removeDMRelay(relayModel.url);
    //                 break;
    //               case RelayType.inbox:
    //                 await Account.sharedInstance.removeInboxRelay(relayModel.url);
    //                 break;
    //               case RelayType.outbox:
    //                 await Account.sharedInstance.removeOutboxRelay(relayModel.url);
    //                 break;
    //             }
    //             OXNavigator.pop(context);
    //             _initDefault();
    //           }),
    //     ],
    //     isRowAction: true);
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
