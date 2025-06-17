import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:flutter/material.dart';

import '../../../core/account/model/userDB_isar.dart';
import '../../../core/manager/chuchu_user_info_manager.dart';
import '../../../core/nostr_dart/src/nips/nip_019.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white,
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
                          color: Colors.black,
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
                              color: Colors.grey,
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
            _menuItem(Icons.person_outline, "Profile", onTap: widget.onProfileTap),
            _menuItem(Icons.link, "Relays",onTap: () {
              ChuChuNavigator.pushPage(context, (context) => RelaysPage());
            }),
            _menuItem(Icons.list_alt, "Contacts"),

            const SizedBox(height: 30),
            Divider(),
            _menuItem(Icons.settings_outlined, "Settings"),
          ],
        ),
      ),
    );
  }

  static Widget _menuItem(
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
            Icon(icon, size: 24),
            const SizedBox(width: 18),
            Text(
              title,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            if (tag != null)
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(fontSize: 10, color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
