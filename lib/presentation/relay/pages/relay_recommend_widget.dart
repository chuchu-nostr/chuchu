import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/material.dart';

import '../../../core/account/model/relayDB_isar.dart';
import '../../../core/utils/adapt.dart';
import '../widgets/ping_delay_time_widget.dart';


class RelayRecommendModule{
  RelayDBISAR relayDB;
  bool isAddedCommend;
  RelayRecommendModule(this.relayDB, this.isAddedCommend);
}

class RelayCommendWidget extends StatelessWidget {
  List<RelayDBISAR> relayList = [];
  List<RelayRecommendModule> commendRelayList = [];
  Function(RelayDBISAR) onTapCall;

  RelayCommendWidget(this.relayList, this.onTapCall, {Key? key}) : super(key: key){
    for(var relay in relayList){
      commendRelayList.add(RelayRecommendModule(relay, false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: Adapt.px(58),
          alignment: Alignment.centerLeft,
          child: Text(
            'Recommend relay',
            style: TextStyle(
              color: Colors.black,
              fontSize: Adapt.px(16),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(16)),
            color: Colors.white,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: _itemBuild,
            itemCount: commendRelayList.length,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    RelayRecommendModule _model = commendRelayList[index];
    final controller = PingInheritedWidget.of(context)?.controller ?? PingLifecycleController();
    final host = _model.relayDB.url.split('//').last;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap:() {
            // OXNavigator.pushPage(context, (context) => RelayDetailPage(relayURL: _model.relayDB.url,));
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 10.px),
            child: Row(
              children: [
                Expanded(child:
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      size: Adapt.px(32),
                      color: Colors.black,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.px),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _model.relayDB.url,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Adapt.px(16),
                            ),
                          ),
                          PingDelayTimeWidget(
                            host: host,
                            controller: controller,
                          ).setPaddingOnly(top: 4.px)
                        ],
                      ),
                    ),
                  ],
                ),),
                _relayStateImage(_model),
              ],
            ),
          ),
        ),
        // commendRelayList.length > 1 && commendRelayList.length - 1 != index
        //     ? Divider(
        //   height: Adapt.px(0.5),
        //   color: Colors.black,
        // )
        //     : SizedBox(width: Adapt.px(24)),
      ],
    );
  }

  Widget _relayStateImage(RelayRecommendModule relayModel) {
    return relayModel.isAddedCommend
        ? const SizedBox()
        : GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTapCall(relayModel.relayDB);
      },
      child: Icon(
        Icons.add,
        size: Adapt.px(24),
        color: Colors.black,
      ),
    );
  }
}
