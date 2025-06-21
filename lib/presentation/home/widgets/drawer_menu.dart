import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:flutter/material.dart';

import '../../../core/account/model/userDB_isar.dart';
import '../../../core/manager/chuchu_user_info_manager.dart';
import '../../../core/nostr_dart/src/nips/nip_019.dart';
import '../../drawerMenu/follows/pages/follows_pages.dart';
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
    return '${nupKey.substring(0, 8)}:${nupKey.substring(nupKey.length - 8)}';
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
      color: theme.colorScheme.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                const CircleAvatar(radius: 24),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: theme.colorScheme.onBackground.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Icon(Icons.person_add_alt_1_outlined,size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _menuItem(context, Icons.person_outline, "Profile", onTap: widget.onProfileTap),
            _menuItem(context, Icons.link, "Relays",onTap: () {
              ChuChuNavigator.pushPage(context, (context) => RelaysPage());
            }),
            _menuItem(context, Icons.list_alt, "Follows",onTap: () {
              ChuChuNavigator.pushPage(context, (context) => FollowsPages());


            }),

            const SizedBox(height: 30),
            Divider(color: theme.dividerColor),
            _menuItem(context, Icons.settings_outlined, "Settings"),
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
                color: Theme.of(context).textTheme.bodyLarge?.color,
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
                  style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
