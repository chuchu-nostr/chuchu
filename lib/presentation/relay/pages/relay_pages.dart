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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Relays'),
        actions: [
          //icon_edit.png
          // OXButton(
          //   highlightColor: Colors.transparent,
          //   color: Colors.transparent,
          //   minWidth: Adapt.px(44),
          //   height: Adapt.px(44),
          //   child: CommonImage(
          //     iconName: _isEditing ? 'icon_done.png' : 'icon_edit.png',
          //     width: Adapt.px(24),
          //     height: Adapt.px(24),
          //     useTheme: true,
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       _isEditing = !_isEditing;
          //     });
          //   },
          // ),
        ],
      ),
      backgroundColor: Colors.white,
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
                  RelaySelectTableTabBar(
                    tabs: RelayType.values.map((e) => e.name()).toList(),
                    tabTips: RelayType.values.map((e) => e.tips()).toList(),
                    onChanged: _relayTypeChanged,
                  ).setPaddingOnly(top: 12.px),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 24.px, bottom: 12.px),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      // Localized.text('ox_usercenter.connect_relay'),
                      'CONNECT TO ${_relayType.sign()} RELAY',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Adapt.px(14),
                      ),
                    ),
                  ),
                  _inputRelay(),
                  SizedBox(
                    height: Adapt.px(12),
                  ),
                  _isShowDelete
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _relayTextFieldControll.text = '';
                              _isShowDelete = false;
                            });
                          },
                          child: Container(
                            height: Adapt.px(36),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Adapt.px(8)),
                              color: Colors.black,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: Adapt.px(14),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Adapt.px(12),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => _addOnTap(isUserInput: true),
                          child: Container(
                            height: Adapt.px(36),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Adapt.px(8)),

                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Add',
                              style: TextStyle(
                                fontSize: Adapt.px(14),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Container(),
                  if (relayList.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 24.px, bottom: 12.px),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        // Localized.text('ox_usercenter.connected_relay'),
                        'CONNECTED TO ${_relayType.sign()} RELAY',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Adapt.px(16),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Adapt.px(16)),
                        // color: Colors.black,
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
              ).setPadding(
                  EdgeInsets.only(left: Adapt.px(24), right: Adapt.px(24), bottom: Adapt.px(24))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
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
            padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 10.px),
            child: Row(
              children: [
                Icon(
                  Icons.link,
                  size: Adapt.px(32),
                  color: Colors.black,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.px),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _model.url,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Adapt.px(16),
                          ),
                        ),
                        PingDelayTimeWidget(
                          host: host,
                          controller: _pingLifecycleController,
                        ).setPaddingOnly(top: 4.px)
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
          height: Adapt.px(0.5),
          color: Theme.of(context).dividerColor.withAlpha(50),
        )
            : Container(),
      ],
    );
  }

  Widget _relayStateImage(RelayDBISAR relayDB) {
    if (_isEditing) {
      return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _deleteOnTap(relayDB);
          },
          child: CommonImage(
            iconName: 'icon_bar_delete_red.png',
            width: Adapt.px(24),
            height: Adapt.px(24),
          ));
    } else {
      if (relayDB.connectStatus == RelayConnectStatus.open) {
        return Icon(
          Icons.check_circle,
          size: Adapt.px(24),
          color: Colors.green,
        );
      } else {
        return SizedBox(
          width: Adapt.px(24),
          height: Adapt.px(24),
          child: CircularProgressIndicator(
            backgroundColor: Colors.black.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        );
      }
    }
  }

  Widget _inputRelay() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: Adapt.px(24),
              height: Adapt.px(24),
              child: Icon(
                Icons.content_paste,
                size: Adapt.px(24),
                color: Colors.black,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _relayTextFieldControll,
                decoration: InputDecoration(
                  hintText: 'wss://some.relay.com',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: Adapt.px(15),
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
                    icon: CommonImage(
                      iconName: 'icon_textfield_close.png',
                      width: Adapt.px(16),
                      height: Adapt.px(16),
                    ),
                  )
                      : null,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
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

  String tips() {
    switch (this) {
      case RelayType.dm:
        return "Your private messages and private group chat messages will be sent to your DM relay. It is recommended to set up 1-3 DM inbox relays.";
      case RelayType.general:
        return "These relays are stored locally and are used to download user profiles, lists, and posts for you";
      case RelayType.inbox:
        return "These relays are used by other users to send notes, likes, zaps to you. It is recommended to set up 2-4 inbox relays.";
      case RelayType.outbox:
        return "0xchat will send your posts to these relays so other users can find your content. It is recommended to set up 2-4 outbox relays.";
    }
  }
}


class RelayConnectStatus {
  static final int connecting = 0;
  static final int open = 1;
  static final int closing = 2;
  static final int closed = 3;
}
