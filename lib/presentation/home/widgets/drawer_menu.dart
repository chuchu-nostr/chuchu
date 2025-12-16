import 'package:chuchu/core/relayGroups/model/relayGroupDB_isar.dart';
import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import 'package:nostr_core_dart/src/nips/nip_019.dart';
import '../../../core/manager/chuchu_user_info_manager.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../core/widgets/common_image.dart';
import '../../../core/widgets/logout_confirm_dialog.dart';
import '../../creator/pages/create_creator_page.dart';
import '../../feed/pages/feed_personal_page.dart';
import '../../profile/pages/my_profile_page.dart';
import '../../search/pages/search_page.dart';
import '../../wallet/wallet_page.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

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

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String _getFullNpub() {
    UserDBISAR? userInfo = ChuChuUserInfoManager.sharedInstance.currentUserInfo;
    if (userInfo == null) return '';
    String pubkey = userInfo.pubKey;
    return Nip19.encodePubkey(pubkey);
  }

  void _copyNpub() {
    final npub = _getFullNpub();
    if (npub.isEmpty) return;
    
    Clipboard.setData(ClipboardData(text: npub));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserDBISAR? userInfo = ChuChuUserInfoManager.sharedInstance.currentUserInfo;

    String? nikName = userInfo?.name ?? userInfo?.nickName ?? '';
    if (nikName.isEmpty) {
      nikName = _getUserNupbStr;
    }
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User profile section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 50,
                    bottom: 20,
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFDF2F8),
                        Color(0xFFFAF5FF),
                        Color(0xFFFFFFFF),
                      ],
                    ),
                  ),
                  child: ValueListenableBuilder<UserDBISAR>(
                    valueListenable: Account.sharedInstance.getUserNotifier(
                      ChuChuUserInfoManager
                              .sharedInstance
                              .currentUserInfo
                              ?.pubKey ??
                          '',
                    ),
                    builder: (context, user, child) {
                      final avatarSize = 70.0;
                      final borderWidth = 3.0;
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: avatarSize + borderWidth * 2,
                          height: avatarSize + borderWidth * 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: borderWidth,
                            ),
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.of(context).pop();
                              ChuChuNavigator.pushPage(
                                context,
                                (context) => MyProfilePage(),
                              );
                            },
                            child: FeedWidgetsUtils.clipImage(
                              borderRadius: avatarSize,
                              imageSize: avatarSize,
                              child: ChuChuCachedNetworkImage(
                                imageUrl: user.picture ?? '',
                                fit: BoxFit.cover,
                                placeholder:
                                    (_, __) =>
                                        FeedWidgetsUtils.badgePlaceholderImage(),
                                errorWidget:
                                    (_, __, ___) =>
                                        FeedWidgetsUtils.badgePlaceholderImage(),
                                width: avatarSize,
                                height: avatarSize,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),
                ValueListenableBuilder<UserDBISAR>(
                  valueListenable: Account.sharedInstance.getUserNotifier(
                    ChuChuUserInfoManager
                            .sharedInstance
                            .currentUserInfo
                            ?.pubKey ??
                        '',
                  ),
                  builder: (context, user, child) {
                    final followersCount = user.followersList?.length ?? 0;
                    final followingCount = user.followingList?.length ?? 0;

                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.of(context).pop();
                        ChuChuNavigator.pushPage(
                          context,
                          (context) => MyProfilePage(),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  nikName ?? '--',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: kTitleColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(Icons.bolt, size: 20, color: Colors.orange),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _getUserNupbStr,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _copyNpub(),
                                child: CommonImage(
                                  iconName: 'copy_icon.png',
                                  size: 16,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                _formatNumber(followersCount),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kTitleColor,
                                ),
                              ),
                              Text(
                                ' Followers',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                _formatNumber(followingCount),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kTitleColor,
                                ),
                              ),
                              Text(
                                ' Following',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ).setPadding(EdgeInsets.symmetric(horizontal: 20)),
              ],
            ),
            const SizedBox(height: 24),
            // _menuItem(
            //   context,
            //   Icons.person_outline,
            //   "Nostr profile",
            //   onTap: () {
            //     Navigator.of(context).pop(); // Close drawer first
            //     ChuChuNavigator.pushPage(
            //       context,
            //       (context) => MyProfilePage(),
            //     );
            //   }
            // ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),

                child: Column(
                  children: [
                    _menuItem(
                      context,
                      'post_bg_icon.png',
                      "My Posts",
                      onTap: () {
                        Navigator.of(context).pop();
                        RelayGroupDBISAR? myRelayGroup =
                            RelayGroup
                                .sharedInstance
                                .myGroups[Account.sharedInstance.currentPubkey]
                                ?.value;
                        if (myRelayGroup == null) {
                          FeedWidgetsUtils.showBecomeCreatorDialog(
                            context,
                            callback: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                FeedWidgetsUtils.createSlideTransition(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => CreateCreatorPage(),
                                ),
                              );
                            },
                          );
                          return;
                        }
                        ChuChuNavigator.pushPage(
                          context,
                          (context) =>
                              FeedPersonalPage(relayGroupDB: myRelayGroup),
                        );
                      },
                    ),
                    _menuItem(
                      context,
                      'wallet_bg_icon.png',
                      "Wallet",
                      onTap: () {
                        Navigator.of(context).pop();
                        ChuChuNavigator.pushPage(
                          context,
                          (context) => WalletPage(),
                        );
                      },
                    ),
                    _menuItem(
                      context,
                      'search_bg_icon.png',
                      "Search",
                      onTap: () {
                        Navigator.of(context).pop();
                        ChuChuNavigator.pushPage(
                          context,
                          (context) => SearchPage(),
                        );
                      },
                    ),

                    _menuItem(
                      context,
                      'settings_bg_icon.png',
                      "Settings",
                      onTap: () {
                        // TODO: Navigate to settings page
                        Navigator.of(context).pop(); // Close drawer first
                        ChuChuNavigator.pushPage(
                          context,
                          (context) => const MyProfilePage(),
                        );
                      },
                    ),
                    // _menuItem(
                    //   context,
                    //   Icons.subscriptions,
                    //   "Subscription Settings",
                    //   onTap: () {
                    //     Navigator.of(context).pop(); // Close drawer first
                    //     ChuChuNavigator.pushPage(context, (context) => const SubscriptionSettingsPage());
                    //   },
                    // ),
                    // _menuItem(
                    //   context,
                    //   Icons.star_outline,
                    //   "Creator Center",
                    //   onTap: () {
                    //     Navigator.of(context).pop(); // Close drawer first
                    //     ChuChuNavigator.pushPage(context, (context) => const CreateCreatorPage());
                    //   },
                    // ),
                    const Spacer(),
                    // Creator Pro upgrade box
                    Divider(color: theme.dividerColor.withOpacity(0.2)),
                    _menuItem(
                      context,
                      Icons.logout,
                      "Log Out",
                      iconColor: theme.colorScheme.onSurfaceVariant,
                      trailing: const SizedBox.shrink(),
                      onTap: () {
                        LogoutConfirmDialog.show(context, closeDrawer: true);
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _menuItem(
    BuildContext context,
    dynamic icon,
    String title, {
    bool bold = true,
    Widget? trailing,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        child: Row(
          children: [
            icon is String
                ? CommonImage(iconName: icon, size: 40)
                : Icon(
                  icon as IconData,
                  size: 24,
                  color: iconColor ?? theme.iconTheme.color,
                ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            if (trailing != null)
              trailing
            else
              Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
          ],
        ),
      ),
    );
  }
}
