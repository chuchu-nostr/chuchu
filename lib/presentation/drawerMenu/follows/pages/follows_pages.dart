import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/account/account.dart';
import '../../../../core/account/model/userDB_isar.dart';

import '../../../../core/utils/adapt.dart';
import '../../../../core/widgets/common_image.dart';

enum FollowsFriendStatus { hasFollows, selectFollows, unSelectFollows }

class DiyUserDB {
  bool isSelect;
  UserDBISAR db;
  DiyUserDB(this.isSelect, this.db);
}

class FollowsPages extends StatefulWidget {
  const FollowsPages({super.key});

  @override
  FollowsPagesState createState() => FollowsPagesState();
}

class FollowsPagesState extends State<FollowsPages> {
  List<DiyUserDB> userMapList = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  UserDBISAR? _searchedUser;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    _getFollowList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //
  void _getFollowList() async {
    final List<String> followings = List<String>.from(
      Account.sharedInstance.me?.followingList ?? [],
    );

    if (followings.isEmpty) {
      if (mounted) setState(() => userMapList = []);
      return;
    }

    final List<UserDBISAR?> results = await Future.wait(
      followings.map(
        (pk) async => await Account.sharedInstance.getUserInfo(pk),
      ),
    );

    final List<DiyUserDB> temp =
        results
            .whereType<UserDBISAR>()
            .map((u) => DiyUserDB(false, u))
            .toList();

    if (mounted) {
      setState(() {
        userMapList = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leadingWidth: 25.px,
        titleSpacing: 0,
        leading: SizedBox(
          width: 25,
        ),
        title: _buildSearchBar(theme),
        actions: [SizedBox(width: Adapt.px(24))],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _isSearching ? _buildSearchResult(theme) : _buildFollowList(theme),
          ],
        ),
      ),
    );
  }

  Widget _followsUserPicWidget(DiyUserDB userInfo) {
    UserDBISAR userDB = userInfo.db;
    Widget picWidget;
    if ((userDB.picture != null && userDB.picture!.isNotEmpty)) {
      picWidget = CachedNetworkImage(
        imageUrl: userInfo.db.picture ?? '',
        fit: BoxFit.contain,
        // placeholder: (context, url) => _badgePlaceholderImage,
        // errorWidget: (context, url, error) => _badgePlaceholderImage,
        width: Adapt.px(80),
        height: Adapt.px(80),
      );
    } else {
      picWidget = CommonImage(
        iconName: 'icon_user_default.png',
        width: Adapt.px(80),
        height: Adapt.px(80),
      );
    }

    return GestureDetector(
      onTap: () {
      },
      child: Container(
        width: Adapt.px(80),
        height: Adapt.px(80),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Adapt.px(40)),
          child: picWidget,
        ),
      ),
    );

    //
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      height: Adapt.px(36),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by npub...',
                border: InputBorder.none,
                isCollapsed: true,
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _isSearching = false;
                    _searchedUser = null;
                    _searchError = null;
                  });
                }
              },
            ),
          ),
          GestureDetector(
            onTap: _search,
            child: Icon(Icons.search, size: 24, color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowList(ThemeData theme) {
    if (userMapList.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(24),
            vertical: Adapt.px(12),
          ),
          child: Row(
            children: [
              Icon(Icons.list, color: theme.colorScheme.primary),
              SizedBox(width: 8),
              Text('Follows', style: theme.textTheme.titleMedium),
            ],
          ),
        ),
        ...userMapList.map(
          (e) => Padding(
            padding: EdgeInsets.only(
              bottom: Adapt.px(12),
              right: Adapt.px(24),
              left: Adapt.px(24),
            ),
            child: _userCard(e),
          ),
        ),
      ],
    );
  }

  Widget _userCard(DiyUserDB info) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // ChuChuNavigator.pushPage(context, (context) => FeedPersonalPage(userPubkey: info.db.pubKey));
      },
      child: SizedBox(
        height: Adapt.px(140),
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned.fill(
                child:
                    info.db.banner != null && info.db.banner!.isNotEmpty
                        ? CachedNetworkImage(
                          imageUrl: info.db.picture!,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primaryContainer,
                              ],
                            ),
                          ),
                        ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                right: 12,
                child: Row(
                  children: [
                    _followsUserPicWidget(info),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.db.name ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          '@${info.db.dns ?? info.db.dns ?? ''}',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchedUser = null;
      _searchError = null;
    });

    try {
      String? pubkey;
      if (query.startsWith('npub')) {
        pubkey = UserDBISAR.decodePubkey(query);
      } else {
        pubkey = query;
      }

      if (pubkey == null || pubkey.isEmpty) {
        setState(() {
          _searchError = 'Invalid npub format';
        });
        return;
      }

      UserDBISAR? user = await Account.sharedInstance.getUserInfo(pubkey);

      if (mounted) {
        setState(() {
          if (user != null) {
            _searchedUser = user;
            _searchError = null;
          } else {
            _searchedUser = null;
            _searchError = 'User not found';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchError = 'Search failed: ${e.toString()}';
        });
      }
    }
  }

  Widget _buildSearchResult(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Search Result', style: theme.textTheme.titleMedium),
          SizedBox(height: Adapt.px(16)),
          if (_searchError != null)
            Container(
              padding: EdgeInsets.all(Adapt.px(16)),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  SizedBox(width: 8),
                  Text(
                    _searchError!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
              ),
            )
          else if (_searchedUser != null)
            _userCard(DiyUserDB(false, _searchedUser!))
          else
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
