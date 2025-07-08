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
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.px),
          alignment: Alignment.centerLeft,
          child: Text(
            'Recommend relay',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 16.px,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
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
    final theme = Theme.of(context);
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
            padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 16.px),
            child: Row(
              children: [
                Expanded(child:
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.px),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.px),
                      ),
                      child: Icon(
                        Icons.settings,
                        size: 24.px,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.px),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _model.relayDB.url,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 16.px,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          PingDelayTimeWidget(
                            host: host,
                            controller: controller,
                          ).setPaddingOnly(top: 6.px)
                        ],
                      ),
                    ),
                  ],
                ),),
                _relayStateImage(context,_model),
              ],
            ),
          ),
        ),
        commendRelayList.length > 1 && commendRelayList.length - 1 != index
            ? Divider(
          height: 1.px,
          color: theme.dividerColor.withValues(alpha: 0.1),
        )
            : Container(),
      ],
    );
  }

  Widget _relayStateImage(context,RelayRecommendModule relayModel) {
    final theme = Theme.of(context);
    return relayModel.isAddedCommend
        ? const SizedBox()
        : GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTapCall(relayModel.relayDB);
      },
      child: Container(
        padding: EdgeInsets.all(8.px),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.px),
        ),
        child: Icon(
          Icons.add,
          size: 20.px,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
