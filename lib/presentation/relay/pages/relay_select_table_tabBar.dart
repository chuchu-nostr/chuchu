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
    final theme = Theme.of(context);
    final tabs = widget.tabs;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.px),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.05),
                blurRadius: 8.px,
                offset: Offset(0, 2.px),
              ),
            ],
          ),
          child: TabBar(
            isScrollable: true,
            controller: _tabController,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            labelPadding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
            labelColor: theme.colorScheme.onPrimary,
            unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12.px),
              color: theme.colorScheme.primary,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            tabs: [
              for (int index = 0; index < tabs.length; index++)
                _buildTabItem(tabs[index], index),
            ],
          ),
        ),
        if (widget.tabTips != null)
          _buildTabTips().setPaddingOnly(top: 16.px)
      ],
    );
  }

  Widget _buildTabItem(String tab, int index) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 12.px),
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
    final theme = Theme.of(context);
    final tips = widget.tabTips?[_currentIndex] ?? '';
    return Container(
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.px),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          width: 1.px,
        ),
      ),
      child: Text(
        tips,
        style: TextStyle(
          fontSize: 13.px,
          fontWeight: FontWeight.w400,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          height: 1.4,
        ),
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
