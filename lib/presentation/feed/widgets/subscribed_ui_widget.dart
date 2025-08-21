import 'package:flutter/material.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../data/models/noted_ui_model.dart';
import '../widgets/feed_widget.dart';
import '../pages/feed_info_page.dart';

/// Widget for displaying subscribed user interface
/// Shows normal feed content for subscribed users
class SubscribedUIWidget extends StatelessWidget {
  final List<NotedUIModel?> notesList;
  final bool isInitialLoading;

  const SubscribedUIWidget({
    super.key,
    required this.notesList,
    required this.isInitialLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isInitialLoading) {
      return const SizedBox.shrink(); // Loading is handled by parent
    }

    if (notesList.isEmpty) {
      return _buildEmptyContent(context);
    }

    return _buildFeedContent(context);
  }

  /// Build empty content when no notes are available
  Widget _buildEmptyContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        // You can replace this with your own empty state image
        Icon(
          Icons.feed_outlined,
          size: 100,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        Text(
          'No Content Available',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This user hasn\'t posted anything yet',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  /// Build feed content list
  Widget _buildFeedContent(BuildContext context) {
    return Column(
      children: notesList.map((notedUIModel) {
        if (notedUIModel == null) return const SizedBox.shrink();
        
        return Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 12,
          ),
          child: FeedWidget(
            isShowReplyWidget: true,
            feedWidgetLayout: EFeedWidgetLayout.fullScreen,
            notedUIModel: notedUIModel,
            clickMomentCallback: (m) => ChuChuNavigator.pushPage(
              context,
              (_) => FeedInfoPage(notedUIModel: m),
            ),
          ),
        );
      }).toList(),
    );
  }
}
