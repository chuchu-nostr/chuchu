import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/account/model/userDB_isar.dart';

import '../../../../core/contacts/contacts.dart';
import '../../../../core/manager/chuchu_user_info_manager.dart';
import '../../../../core/utils/adapt.dart';
import '../../../../core/widgets/common_image.dart';

enum FollowsFriendStatus {
  hasFollows,
  selectFollows,
  unSelectFollows,
}

class DiyUserDB {
  bool isSelect;
  UserDBISAR db;
  DiyUserDB(this.isSelect, this.db);
}

extension GetFollowsFriendStatusIcon on FollowsFriendStatus {
  IconData get iconData {
    switch (this) {
      case FollowsFriendStatus.hasFollows:
        return Icons.check_circle;
      case FollowsFriendStatus.selectFollows:
        return Icons.check_circle;
      case FollowsFriendStatus.unSelectFollows:
        return Icons.radio_button_unchecked;
    }
  }
  
  Color getIconColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (this) {
      case FollowsFriendStatus.hasFollows:
        return Colors.green;
      case FollowsFriendStatus.selectFollows:
        return theme.colorScheme.primary;
      case FollowsFriendStatus.unSelectFollows:
        return theme.colorScheme.onSurface.withOpacity(0.5);
    }
  }
}

class FollowsPages extends StatefulWidget {
  @override
  _FollowsPagesState createState() => new _FollowsPagesState();
}

class _FollowsPagesState extends State<FollowsPages> {
  List<DiyUserDB> userMapList = [];
  bool isSelectAll = false;

  @override
  void initState() {
    super.initState();
    _getFollowList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<DiyUserDB> getSelectFollowsNum() {
    List<DiyUserDB> selectFollowsList = [];
    userMapList.forEach((DiyUserDB info) => {
      if (info.isSelect) {selectFollowsList.add(info)}
    });
    return selectFollowsList;
  }

  //
  void _getFollowList() async {
    String pubKey = ChuChuUserInfoManager.sharedInstance.currentUserInfo!.pubKey!;

    String decodePubKey = UserDBISAR.decodePubkey(pubKey) ?? '';

    // List userMap = await Account.syncFollowListFromRelay(decodePubKey);
    final user = ChuChuUserInfoManager.sharedInstance.currentUserInfo;
    List userMap = [user,user,user,user,user,user,user,user,user];
    List<DiyUserDB> db = [];

    userMap.forEach((info) => {db.add(new DiyUserDB(false, info))});
    userMapList = db;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Import Follows'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        actions: [
          _appBarActionWidget(context),
          SizedBox(
            width: Adapt.px(24),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Adapt.px(24),
                  vertical: Adapt.px(12),
                ),
                child: Text(
                  'Select users to import as contacts',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: Adapt.px(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    userMapList.length > 0
                        ? ListView.builder(
                      padding: EdgeInsets.only(
                        left: Adapt.px(24),
                        right: Adapt.px(24),
                        bottom: Adapt.px(100),
                      ),
                      primary: false,
                      itemCount: userMapList.length,
                      itemBuilder: (context, index) {
                        return _followsFriendWidget(index);
                      },
                    )
                        : _emptyWidget(),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: Adapt.px(37),
                      child: _addContactBtnView(),
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

  Widget _appBarActionWidget(BuildContext context) {
    final theme = Theme.of(context);
    if(userMapList.length == 0 ) return Container();
    return GestureDetector(
      onTap: () {
        isSelectAll = !isSelectAll;
        userMapList.forEach((DiyUserDB useDB) {
          useDB.isSelect = isSelectAll;
        });
        setState(() {});
      },
      child: Center(
        child: Text(
          !isSelectAll ? 'All' : 'None',
          style: TextStyle(
            fontSize: Adapt.px(16),
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _followsFriendWidget(int index) {
    DiyUserDB userInfo = userMapList[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {},
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Adapt.px(4),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  _followsUserPicWidget(userInfo),
                  Expanded(
                    child: _followsUserInfoWidget(userInfo),
                  ),
                ],
              ),
            ),
            _followsStatusView(index),
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
        width: Adapt.px(40),
        height: Adapt.px(40),
      );
    } else {
      picWidget = CommonImage(
        iconName: 'icon_user_default.png',
        width: Adapt.px(40),
        height: Adapt.px(40),
      );
    }

    return GestureDetector(
      onTap: () {
        // OXNavigator.pushPage(
        //     context, (context) => ContactUserInfoPage(userDB: userDB));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          Adapt.px(40),
        ),
        child: picWidget,
      ),
    );

    //
  }

  Widget _followsUserInfoWidget(DiyUserDB userInfo) {
    final theme = Theme.of(context);
    UserDBISAR userDB = userInfo.db;
    String? nickName = userDB.nickName;
    String name = (nickName != null && nickName.isNotEmpty)
        ? nickName
        : userDB.name ?? '';
    String encodedPubKey = userDB.encodedPubkey ?? '';
    int pubKeyLength = encodedPubKey.length;
    String encodedPubKeyShow =
        '${encodedPubKey.substring(0, 7)}...${encodedPubKey.substring(pubKeyLength - 4, pubKeyLength)}';

    return Container(
      padding: EdgeInsets.only(
        left: Adapt.px(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            encodedPubKeyShow,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: Adapt.px(14),
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _addContactBtnView() {
    final theme = Theme.of(context);
    if (userMapList.length == 0) return Container();
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Adapt.px(24),
        ),
        width: double.infinity,
        height: Adapt.px(48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.primary,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: Adapt.px(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(5)),
              child: Text(
                getSelectFollowsNum().length.toString(),
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: Adapt.px(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              'contacts',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: Adapt.px(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      onTap: _addContactsFn,
    );
  }

  Widget _followsStatusView(int index) {
    DiyUserDB userDB = userMapList[index];
    Map<String, UserDBISAR> allContacts = Contacts.sharedInstance.allContacts;
    bool isContacts = allContacts[userDB.db.pubKey] != null;
    
    FollowsFriendStatus status;
    if (isContacts) {
      status = FollowsFriendStatus.hasFollows;
    } else {
      status = userDB.isSelect
          ? FollowsFriendStatus.selectFollows
          : FollowsFriendStatus.unSelectFollows;
    }

    return GestureDetector(
      onTap: () {
        if (isContacts) return;
        userMapList[index].isSelect = !userDB.isSelect;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(Adapt.px(8)),
        child: Icon(
          status.iconData,
          size: 24.0,
          color: status.getIconColor(context),
        ),
      ),
    );
  }

  Widget _emptyWidget() {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 87.0),
      child: Column(
        children: <Widget>[
          CommonImage(
            iconName: 'icon_no_login.png',
            width: Adapt.px(90),
            height: Adapt.px(90),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              'No follows yet',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: Adapt.px(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addContactsFn() async {
    // await OXLoading.show();
    // List<String> selectFollowPubKey = [];
    // getSelectFollowsNum().forEach((DiyUserDB info) {
    //   selectFollowPubKey.add(info.db.pubKey ?? '');
    // });
    // final OKEvent okEvent =
    // await Contacts.sharedInstance.addToContact(selectFollowPubKey);
    // await OXLoading.dismiss();
    // if (okEvent.status) {
    //   OXNavigator.pop(context, true);
    // } else {
    //   CommonToast.instance.show(context, okEvent.message);
    // }
  }
}