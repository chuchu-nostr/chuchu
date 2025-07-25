import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:chuchu/presentation/login/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/config/storage_key_tool.dart';
import '../../../core/manager/cache/chuchu_cache_manager.dart';
import '../../../core/manager/chuchu_user_info_manager.dart';
import '../../../core/nostr_dart/src/nips/nip_019.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../backup/pages/backup_page.dart';
import '../../drawerMenu/follows/pages/follows_pages.dart';
import '../../feed/pages/feed_personal_page.dart';
import '../../relay/pages/relay_pages.dart';

class DrawerMenu extends StatefulWidget {
  final Future<void> Function()? onProfileTap;
  const DrawerMenu({this.onProfileTap, super.key});

  @override
  State createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu>
    with SingleTickerProviderStateMixin {
  String get _getUserNupbStr {
    UserDBISAR? userInfo = ChuChuUserInfoManager.sharedInstance.currentUserInfo;
    if (userInfo == null) return '--';
    String pubkey = userInfo.pubKey;
    String nupKey = Nip19.encodePubkey(pubkey);
    return '${nupKey.substring(0, 6)}:${nupKey.substring(nupKey.length - 6)}';
  }

  @override
  Widget build(BuildContext context) {
    String? nikName =
        ChuChuUserInfoManager.sharedInstance.currentUserInfo?.nickName;
    if (nikName == null || nikName.isEmpty) {
      nikName = _getUserNupbStr;
    }
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                ValueListenableBuilder<UserDBISAR>(
                  valueListenable: Account.sharedInstance.getUserNotifier(
                    ChuChuUserInfoManager
                            .sharedInstance
                            .currentUserInfo
                            ?.pubKey ??
                        '',
                  ),
                  builder: (context, user, child) {
                    final avatarSize = 40;
                    return FeedWidgetsUtils.clipImage(
                      borderRadius: avatarSize.px,
                      imageSize: avatarSize.px,
                      child: ChuChuCachedNetworkImage(
                        imageUrl: user.picture ?? '',
                        fit: BoxFit.cover,
                        placeholder:
                            (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
                        errorWidget:
                            (_, __, ___) =>
                                FeedWidgetsUtils.badgePlaceholderImage(),
                        width: avatarSize.px,
                        height: avatarSize.px,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nikName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getUserNupbStr,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: theme.colorScheme.onBackground.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () async {
                              bool? status = await ChuChuCacheManager
                                  .defaultOXCacheManager
                                  .saveForeverData(
                                    StorageKeyTool.CHUCHU_USER_PUBKEY,
                                    '',
                                  );

                              if (status) {
                                await ChuChuUserInfoManager.sharedInstance
                                    .logout(needObserver: true);
                                widget.onProfileTap?.call();
                                ChuChuNavigator.pushReplacement(
                                  context,
                                  const LoginPage(),
                                );
                              }
                            },
                            child: Icon(Icons.logout, size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _menuItem(
              context,
              Icons.person_outline,
              "My Posts",
              onTap: () {
                widget.onProfileTap?.call();
                ChuChuNavigator.pushPage(
                  context,
                      (context) => FeedPersonalPage(
                    userPubkey: Account.sharedInstance.currentPubkey ?? '',
                  ),
                );
              }
            ),
            _menuItem(
              context,
              Icons.link,
              "Relays",
              onTap: () {
                widget.onProfileTap?.call();
                ChuChuNavigator.pushPage(context, (context) => RelaysPage());
              },
            ),
            _menuItem(
              context,
              Icons.list_alt,
              "Follows",
              onTap: () {
                widget.onProfileTap?.call();
                ChuChuNavigator.pushPage(context, (context) => FollowsPages());
              },
            ),

            Divider(color: theme.dividerColor.withAlpha(50)),
            _menuItem(
              context, 
              Icons.lock_outline, 
              "Back Up",
              onTap: () {
                widget.onProfileTap?.call();
                ChuChuNavigator.pushPage(context, (context) => const BackupPage());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool bold = false,
    String? tag,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 18),
            Text(
              title,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (tag != null)
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
