import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/material.dart';

class RelaySelectTableTabBar extends StatefulWidget {
  final List<String> tabs;
  final List<String>? tabTips;
  final ValueChanged<int>? onChanged;

  const RelaySelectTableTabBar({
    Key? key,
    required this.tabs,
    this.onChanged,
    this.tabTips,
  })  : assert(tabTips == null || tabs.length == tabTips.length,
  'tabs and tabTips must have the same length'),
        super(key: key);

  @override
  State<RelaySelectTableTabBar> createState() => _RelaySelectTableTabBarState();
}

class _RelaySelectTableTabBarState extends State<RelaySelectTableTabBar>
    with SingleTickerProviderStateMixin {

  late final TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(_updateStatus);
  }

  _updateStatus() {
    setState(() {
      _currentIndex = _tabController.index;
      widget.onChanged?.call(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = widget.tabs;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          isScrollable: true,
          controller: _tabController,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          labelPadding: EdgeInsets.only(right: 12.px),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 0),
          ),
          tabs: [
            for (int index = 0; index < tabs.length; index++)
              _buildTabItem(tabs[index], index),
          ],
        ),
        if (widget.tabTips != null)
          _buildTabTips().setPaddingOnly(top: 10.px)
      ],
    );
  }

  Widget _buildTabItem(String tab, int index) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 24.px, vertical: 10.px),
      child: Text(
        tab,
        style: TextStyle(
          fontSize: 14.px,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTabTips() {
    final tips = widget.tabTips?[_currentIndex] ?? '';
    return Text(
      tips,
      style: TextStyle(
        fontSize: 12.px,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabController.removeListener(_updateStatus);
    super.dispose();
  }
}
