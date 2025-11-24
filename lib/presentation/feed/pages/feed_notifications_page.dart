import 'package:chuchu/core/feed/feed+load.dart';
import 'package:chuchu/core/feed/feed+notification.dart';
import 'package:chuchu/core/widgets/common_toast.dart';
import 'package:chuchu/data/models/feed_extension_model.dart';
import 'package:flutter/material.dart';
import '../../../core/feed/feed.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import '../../../core/feed/model/notificationDB_isar.dart';
import '../../../core/manager/chuchu_feed_manager.dart';
import '../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../core/utils/feed_utils.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../data/models/noted_ui_model.dart';
import 'feed_info_page.dart';
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
  final RelayGroupDBISAR? relayGroupDB;

  FeedNotificationsPage({super.key, this.relayGroupDB});

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
    
    // Only update _lastTimestamp if we have notifications
    if (notificationList.isNotEmpty) {
      _lastTimestamp = notificationList.last.createAt;
    }
    
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading notifications...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    if (_aggregatedNotifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Notifications',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You\'ll see notifications here when someone\ninteracts with your posts',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(AggregatedNotification notification) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        if(notification.kind == 7) return;
        _handleNotificationTap(notification);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            _buildNotificationAvatar(notification),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNotificationTitle(notification),
                  const SizedBox(height: 12),
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
              if(widget.relayGroupDB == null){
                CommonToast.instance.show(context, 'Creator not enabled');
                return;
              }
              ChuChuNavigator.pushPage(
                context,
                (context) => FeedPersonalPage(relayGroupDB: widget.relayGroupDB!),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: FeedWidgetsUtils.clipImage(
              borderRadius: 48,
              imageSize: 48,
              child: ChuChuCachedNetworkImage(
                imageUrl: user?.picture ?? '',
                fit: BoxFit.cover,
                placeholder: (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
                errorWidget:
                    (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(),
                width: 48,
                height: 48,
              ),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    TextSpan(
                      text: ' $actionText',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
        const SizedBox(width: 12),
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
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          FeedUtils.formatTimeAgo(notification.createAt),
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _handleNotificationTap(AggregatedNotification notification)async {
    String noteId;
    if(notification.kind == 1 || notification.kind == 2) {
      noteId = notification.notificationId;
    } else {
      noteId = notification.associatedNoteId;
    }

    NotedUIModel? noteNotifier = await getValueNotifierNoted(
      noteId,
      isUpdateCache: true,
    );

    if(noteNotifier != null){
      ChuChuNavigator.pushPage(context, (context) => FeedInfoPage(isShowReply: true, notedUIModel: noteNotifier));
    }
  }

  static Future<NotedUIModel?> getValueNotifierNoted(
      String noteId,
      {
        bool isUpdateCache = false,
        String? rootRelay,
        String? replyRelay,
        List<String>? setRelay,
        NotedUIModel? notedUIModel,
      }) async {
    Map<String, NoteDBISAR> notesCache = Feed.sharedInstance.notesCache;
    NoteDBISAR? noteNotifier = notesCache[noteId];

    if(!isUpdateCache && noteNotifier != null){
      return NotedUIModel(noteDB: noteNotifier);
    }

    List<String>? relaysList = setRelay;
    if(relaysList == null){
      String? relayStr = (notedUIModel?.noteDB.replyRelay ?? replyRelay) ?? (notedUIModel?.noteDB.rootRelay ?? rootRelay);
      relaysList = relayStr != null ? [relayStr] : null;
    }

    NoteDBISAR? note = await Feed.sharedInstance.loadNoteWithNoteId(noteId, relays: relaysList);
    if(note == null) return null;

    return NotedUIModel(noteDB: note);
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
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Icon(icon, size: 12, color: color),
    );
  }

  String _getActionText(int kind) {
    switch (kind) {
      case 7: // reaction/like
        return 'liked';
      case 1: // reply
        return 'replied';
      case 9735: // zap
        return 'zapped';
      case 6: // repost
        return 'reposted';
      case 2: // quote repost
        return 'quoted';
      default:
        return 'interacted with your post';
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
