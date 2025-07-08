import 'package:chuchu/core/feed/feed+notification.dart';
import 'package:chuchu/data/models/feed_extension_model.dart';
import 'package:flutter/material.dart';
import 'package:chuchu/core/utils/adapt.dart';
import '../../../core/feed/feed.dart';
import '../../../core/feed/model/notificationDB_isar.dart';
import '../../../core/manager/chuchu_feed_manager.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import 'feed_personal_page.dart';

class AggregatedNotification {
  String notificationId;
  int kind;
  String author;
  int createAt;
  String content;
  int zapAmount;
  String associatedNoteId;
  int likeCount;

  AggregatedNotification({
    this.notificationId = '',
    this.kind = 0,
    this.author = '',
    this.createAt = 0,
    this.content = '',
    this.zapAmount = 0,
    this.associatedNoteId = '',
    this.likeCount = 0,
  });

  factory AggregatedNotification.fromNotificationDB(
    NotificationDBISAR notificationDB,
  ) {
    return AggregatedNotification(
      notificationId: notificationDB.notificationId,
      kind: notificationDB.kind,
      author: notificationDB.author,
      createAt: notificationDB.createAt,
      content: notificationDB.content,
      zapAmount: notificationDB.zapAmount,
      associatedNoteId: notificationDB.associatedNoteId,
    );
  }
}

class FeedNotificationsPage extends StatefulWidget {
  const FeedNotificationsPage({super.key});

  @override
  State<FeedNotificationsPage> createState() => _FeedNotificationsPageState();
}

class _FeedNotificationsPageState extends State<FeedNotificationsPage>
    with ChuChuFeedObserver {
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  final int _limit = 50;
  int? _lastTimestamp;
  final List<AggregatedNotification> _aggregatedNotifications = [];
  @override
  void initState() {
    super.initState();
    ChuChuFeedManager.sharedInstance.addObserver(this);
    _lastTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    _loadNotificationData();
  }

  @override
  void dispose() {
    ChuChuFeedManager.sharedInstance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  _loadNotificationData() async {
    List<NotificationDBISAR> notificationList =
        await Feed.sharedInstance.loadNotificationsFromDB(
          _lastTimestamp ?? 0,
          limit: _limit,
        ) ??
        [];

    List<AggregatedNotification> aggregatedNotifications =
        _getAggregatedNotifications(notificationList);
    _aggregatedNotifications.addAll(aggregatedNotifications);
    _lastTimestamp = notificationList.last.createAt;
    // notificationList.length < _limit ? _refreshController.loadNoData() : _refreshController.loadComplete();
    _isLoading = false;
    setState(() {});
  }

  List<AggregatedNotification> _getAggregatedNotifications(
    List<NotificationDBISAR> notifications,
  ) {
    List<NotificationDBISAR> likeTypeNotification = [];
    List<NotificationDBISAR> otherTypeNotification = [];
    Set<String> groupedItems = {};

    for (var notification in notifications) {
      if (notification.isLike) {
        likeTypeNotification.add(notification);
        groupedItems.add(notification.associatedNoteId);
      } else {
        otherTypeNotification.add(notification);
      }
    }

    Map<String, List<NotificationDBISAR>> grouped = {};
    for (var groupedItem in groupedItems) {
      grouped[groupedItem] =
          likeTypeNotification
              .where(
                (notification) => notification.associatedNoteId == groupedItem,
              )
              .toList();
    }

    List<AggregatedNotification> aggregatedNotifications = [];
    grouped.forEach((key, value) {
      value.sort((a, b) => b.createAt.compareTo(a.createAt)); // sort each group
      AggregatedNotification groupedNotification =
          AggregatedNotification.fromNotificationDB(value.first);
      groupedNotification.likeCount = value.length;
      aggregatedNotifications.add(groupedNotification);
    });

    aggregatedNotifications.addAll(
      otherTypeNotification.map(
        (element) => AggregatedNotification.fromNotificationDB(element),
      ),
    );
    aggregatedNotifications.sort((a, b) => b.createAt.compareTo(a.createAt));

    return aggregatedNotifications;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text('Notifications', style: theme.textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_aggregatedNotifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 16.px),
      itemCount: _aggregatedNotifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(_aggregatedNotifications[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: 16),
          Text(
            'No Notifications',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You\'ll see notifications here when someone\ninteracts with your posts',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(AggregatedNotification notification) {
    final theme = Theme.of(context);

    return GestureDetector(
      // onTap: () => _handleNotificationTap(notification),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.px, vertical: 4.px),
        padding: EdgeInsets.all(16.px),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            _buildNotificationAvatar(notification),
            SizedBox(width: 12.px),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNotificationTitle(notification),
                  SizedBox(height: 8.px),
                  _buildNotificationContent(notification),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationAvatar(AggregatedNotification notification) {
    return FutureBuilder<UserDBISAR?>(
      future: _getUserInfo(notification.author),
      builder: (context, snapshot) {
        final user = snapshot.data;
        return GestureDetector(
          onTap: () {
            if (user?.pubKey != null) {
              ChuChuNavigator.pushPage(
                context,
                (context) => FeedPersonalPage(userPubkey: user!.pubKey),
              );
            }
          },
          child: FeedWidgetsUtils.clipImage(
            borderRadius: 50.px,
            imageSize: 50.px,
            child: ChuChuCachedNetworkImage(
              imageUrl: user?.picture ?? '',
              fit: BoxFit.cover,
              placeholder: (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
              errorWidget:
                  (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(),
              width: 50.px,
              height: 50.px,
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationTitle(AggregatedNotification notification) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FutureBuilder<UserDBISAR?>(
            future: _getUserInfo(notification.author),
            builder: (context, snapshot) {
              final user = snapshot.data;
              final userName = user?.name ?? '--';

              String actionText = _getActionText(notification.kind);

              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: userName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 18.px,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    TextSpan(
                      text: ' $actionText',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16.px,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
        SizedBox(width: 8.px),
        _buildNotificationTypeIcon(notification),
      ],
    );
  }

  Widget _buildNotificationContent(AggregatedNotification notification) {
    final theme = Theme.of(context);
    String content = notification.kind == 7 ? '' : notification.content;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            content,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 18,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          _formatTime(notification.createAt),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationTypeIcon(AggregatedNotification notification) {
    final theme = Theme.of(context);
    IconData icon;
    Color color;

    switch (notification.kind) {
      case 7: // reaction/like
        icon = Icons.favorite;
        color = Colors.red;
        break;
      case 1: // reply
        icon = Icons.chat_bubble;
        color = theme.colorScheme.primary;
        break;
      case 9735: // zap
        icon = Icons.bolt;
        color = Colors.orange;
        break;
      case 6: // repost
        icon = Icons.repeat;
        color = Colors.green;
        break;
      case 2: // quote repost
        icon = Icons.format_quote;
        color = theme.colorScheme.secondary;
        break;
      default:
        icon = Icons.notifications;
        color = theme.colorScheme.onSurface;
    }

    return Container(
      width: 32.px,
      height: 32.px,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16.px, color: color),
    );
  }

  String _getActionText(int kind) {
    switch (kind) {
      case 7: // reaction/like
        return 'liked your post';
      case 1: // reply
        return 'replied to your post';
      case 9735: // zap
        return 'zapped your post';
      case 6: // repost
        return 'reposted your post';
      case 2: // quote repost
        return 'quoted your post';
      default:
        return 'interacted with your post';
    }
  }

  String _formatTime(int? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  Future<UserDBISAR?> _getUserInfo(String pubkey) async {
    try {
      UserDBISAR? user = await Account.sharedInstance.getUserInfo(pubkey);
      if (user != null) {
        return user;
      }

      return null;
    } catch (e) {
      print('Error getting user info: $e');
      return null;
    }
  }
}
