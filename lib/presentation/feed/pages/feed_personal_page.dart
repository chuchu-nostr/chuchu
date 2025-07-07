import 'package:chuchu/core/account/account+follows.dart';
import 'package:chuchu/core/feed/feed+load.dart';
import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/data/models/feed_extension_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/feed/feed.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import '../../../core/nostr_dart/src/ok.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../core/widgets/chuchu_smart_refresher.dart';
import '../../../core/widgets/common_image.dart';
import '../../../data/models/noted_ui_model.dart';
import '../widgets/feed_skeleton_widget.dart';
import '../widgets/feed_widget.dart';
import 'feed_info_page.dart';

class FeedPersonalPage extends StatefulWidget {
  final String userPubkey;
  const FeedPersonalPage({super.key, required this.userPubkey});

  @override
  State<FeedPersonalPage> createState() => _FeedPersonalPageState();
}

class _FeedPersonalPageState extends State<FeedPersonalPage> {
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController();
  bool _isInitialLoading = true;
  List<NotedUIModel?> notesList = [];
  final int _limit = 1000;
  int? _allNotesFromDBLastTimestamp;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    updateNotesList(true);
    _checkFollowing();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              elevation: 0,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              expandedHeight: 280,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                titlePadding: const EdgeInsets.only(bottom: 16.0),
                title: _buildCollapseTitle(theme),
                background: _buildHeader(theme),
              ),
            ),
          ];
        },
        body: ChuChuSmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () => updateNotesList(true),
          onLoading: () => updateNotesList(false),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount:
                _isInitialLoading
                    ? 8
                    : (notesList.isEmpty ? 1 : notesList.length),
            itemBuilder: (context, index) {
              if (_isInitialLoading) {
                return index < 8
                    ? const FeedSkeletonWidget()
                    : const SizedBox.shrink();
              }

              if (notesList.isEmpty) {
                return index == 0
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 100),
                        CommonImage(iconName: 'no_feed.png', size: 350),
                        Text(
                          'No Content',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    )
                    : const SizedBox.shrink();
              }

              if (index < notesList.length) {
                NotedUIModel? notedUIModel = notesList[index];
                return FeedWidget(
                  isShowReplyWidget: true,
                  notedUIModel: notedUIModel,
                  clickMomentCallback: (NotedUIModel? notedUIModel) async {
                    await ChuChuNavigator.pushPage(
                      context,
                      (context) => FeedInfoPage(notedUIModel: notedUIModel),
                    );
                  },
                ).setPadding(
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.only(left: 18, right: 18, top: 50),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
            Colors.white,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: ValueListenableBuilder<UserDBISAR>(
        valueListenable: Account.sharedInstance.getUserNotifier(
          widget.userPubkey,
        ),
        builder: (context, user, child) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16), // Top padding
                Row(
                  children: [
                    Row(
                      children: [
                        _buildFloatingAvatar(
                          user,
                          theme,
                        ).setPaddingOnly(right: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user.name ?? '',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 24.px,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.dns ?? '--',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.px,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _isFollowing ? _unFollowUser : _followUser,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(
                        _isFollowing ? 'Unfollow' : 'Follow',
                        style: TextStyle(
                          backgroundColor: Colors.white,
                          fontSize: 16.px,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (user.about != null && user.about!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      user.about!,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.px,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingAvatar(UserDBISAR userDB, ThemeData theme) {
    return Stack(
      children: [
        // Avatar container with pink background
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.pink.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: GestureDetector(
            onTap: () {},
            child: FeedWidgetsUtils.clipImage(
              borderRadius: 80,
              imageSize: 80,
              child: ChuChuCachedNetworkImage(
                imageUrl: userDB.picture ?? '',
                fit: BoxFit.cover,
                placeholder:
                    (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
                errorWidget:
                    (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(),
                width: 80,
                height: 80,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCollapseTitle(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final settings =
            context
                .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        double opacity = 0.0;
        if (settings != null) {
          final double delta = settings.maxExtent - settings.minExtent;
          final double t =
              (settings.currentExtent - settings.minExtent) / delta;
          // 仅当已折叠 80%以上 (t < 0.2) 时才逐步显现
          if (t < 0.2) {
            opacity = (0.2 - t) / 0.2; // 0 ->1 之间
          } else {
            opacity = 0.0;
          }
        }

        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: ValueListenableBuilder<UserDBISAR>(
            valueListenable: Account.sharedInstance.getUserNotifier(
              widget.userPubkey,
            ),
            builder: (context, user, _) {
              return Text(
                user.name ?? '',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> updateNotesList(bool isInit) async {
    if (isInit && notesList.isEmpty) {
      setState(() {
        _isInitialLoading = true;
      });
    }

    try {
      List<NoteDBISAR> list = await _getNoteTypeToDB(isInit);
      if (list.isEmpty) {
        isInit
            ? _refreshController.refreshCompleted()
            : _refreshController.loadNoData();

        if (isInit) {
          setState(() {
            _isInitialLoading = false;
          });
        }

        if (!isInit) await _getNotesFromRelay();
        return;
      }

      List<NoteDBISAR> showList = _filterNotes(list);
      _updateUI(showList, isInit, list.length);

      if (list.length < _limit) {
        !isInit ? await _getNotesFromRelay() : _refreshController.loadNoData();
      }
    } catch (e) {
      print('Error loading notes: $e');
      _refreshController.loadFailed();
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  Future<List<NoteDBISAR>> _getNoteTypeToDB(bool isInit) async {
    int? until = isInit ? null : _allNotesFromDBLastTimestamp;
    return await Feed.sharedInstance.loadUserNotesFromDB(
          [widget.userPubkey],
          until: until,
          limit: _limit,
        ) ??
        [];
  }

  Future<List<NoteDBISAR>> _getNoteTypeToRelay() async {
    return await Feed.sharedInstance.loadNewNotesFromRelay(
          authors: [widget.userPubkey],
          until: _allNotesFromDBLastTimestamp,
          limit: _limit,
        ) ??
        [];
  }

  Future<void> _getNotesFromRelay() async {
    try {
      List<NoteDBISAR> list = await _getNoteTypeToRelay();

      if (list.isEmpty) {
        _refreshController.loadNoData();
        setState(() {
          _isInitialLoading = false;
        });
        return;
      }

      List<NoteDBISAR> showList = _filterNotes(list);
      _updateUI(showList, false, list.length);
    } catch (e) {
      print('Error loading notes from relay: $e');
      _refreshController.loadFailed();
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  List<NoteDBISAR> _filterNotes(List<NoteDBISAR> list) {
    return list
        .where(
          (NoteDBISAR note) => !note.isReaction && note.getReplyLevel(null) < 2,
        )
        .toList();
  }

  void _updateUI(List<NoteDBISAR> showList, bool isInit, int fetchedCount) {
    List<NotedUIModel?> list =
        showList.map((item) => NotedUIModel(noteDB: item)).toList();
    if (isInit) {
      notesList = list;
    } else {
      notesList.addAll(list);
    }

    _allNotesFromDBLastTimestamp = showList.last.createAt;

    if (isInit) {
      _refreshController.refreshCompleted();
    } else {
      fetchedCount < _limit
          ? _refreshController.loadNoData()
          : _refreshController.loadComplete();
    }

    if (_isInitialLoading) {
      _isInitialLoading = false;
    }

    setState(() {});
  }

  Future<void> _checkFollowing() async {
    bool f = await Account.sharedInstance.onFollowingList(widget.userPubkey);
    if (mounted) {
      setState(() {
        _isFollowing = f;
      });
    }
  }

  Future<void> _followUser() async {
    OKEvent event = await Account.sharedInstance.addFollows([widget.userPubkey]);
    setState(() {
      _isFollowing = true;
    });
  }

  Future<void> _unFollowUser() async {
    await Account.sharedInstance.removeFollows([widget.userPubkey]);
    setState(() {
      _isFollowing = false;
    });
  }
}
