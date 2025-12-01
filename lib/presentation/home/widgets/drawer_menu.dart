import 'package:chuchu/core/relayGroups/model/relayGroupDB_isar.dart';
import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:chuchu/presentation/login/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/config/storage_key_tool.dart';
import '../../../core/manager/cache/chuchu_cache_manager.dart';
import '../../../core/manager/chuchu_user_info_manager.dart';
import 'package:nostr_core_dart/src/nips/nip_019.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
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

class _DrawerMenuState extends State<DrawerMenu> with SingleTickerProviderStateMixin {
  String get _getUserNupbStr {
    UserDBISAR? userInfo = ChuChuUserInfoManager.sharedInstance.currentUserInfo;
    if (userInfo == null) return '--';
    String pubkey = userInfo.pubKey;
    String nupKey = Nip19.encodePubkey(pubkey);
    return '${nupKey.substring(0, 6)}:${nupKey.substring(nupKey.length - 6)}';
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
                    final avatarSize = 40.0;
                    return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.of(context).pop(); // Close drawer first
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
                              (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
                          errorWidget:
                              (_, __, ___) =>
                              FeedWidgetsUtils.badgePlaceholderImage(),
                          width: avatarSize,
                          height: avatarSize,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.of(context).pop(); // Close drawer first
                            ChuChuNavigator.pushPage(
                              context,
                              (context) => MyProfilePage(),
                            );
                          },
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
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                _getUserNupbStr,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: theme.colorScheme.onBackground.withOpacity(
                                    0.6,
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          _showLogoutConfirmDialog(context);
                        },
                        child: Icon(Icons.logout, size: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
            _menuItem(
              context,
              Icons.article_outlined,
              "My Posts",
              onTap: () {
                RelayGroupDBISAR? myRelayGroup = RelayGroup.sharedInstance.myGroups[Account.sharedInstance.currentPubkey]?.value;
                if(myRelayGroup == null){
                  FeedWidgetsUtils.showBecomeCreatorDialog(context,callback:() {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        FeedWidgetsUtils.createSlideTransition(
                          pageBuilder: (context, animation, secondaryAnimation) => CreateCreatorPage(),
                        ),
                      );
                  });
                  return;
                }
                ChuChuNavigator.pushPage(
                  context,
                      (context) => FeedPersonalPage(
                    relayGroupDB: myRelayGroup,
                  ),
                );
              }
            ),
            _menuItem(
              context,
              Icons.account_balance_wallet,
              "Wallet",
              onTap: () {
                Navigator.of(context).pop(); // Close drawer first
                ChuChuNavigator.pushPage(
                  context,
                  (context) => WalletPage(),
                );
              }
            ),
            // _menuItem(
            //   context,
            //   Icons.dns,
            //   "Servers",
            //   onTap: () {
            //     Navigator.of(context).pop(); // Close drawer first
            //     ChuChuNavigator.pushPage(context, (context) => RelaysPage());
            //   },
            // ),
            _menuItem(
              context,
              Icons.search,
              "Search",
              onTap: () {
                Navigator.of(context).pop(); // Close drawer first
                ChuChuNavigator.pushPage(context, (context) => SearchPage());
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
            
            //
            // Divider(color: theme.dividerColor.withAlpha(50)),
            // _menuItem(
            //   context,
            //   Icons.lock_outline,
            //   "Back Up",
            //   onTap: () {
            //     Navigator.of(context).pop(); // Close drawer first
            //     ChuChuNavigator.pushPage(context, (context) => const BackupPage());
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding:EdgeInsets.symmetric(horizontal: 18.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: colorScheme.error,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Confirm Logout',
                style: theme.dialogTheme.titleTextStyle ?? theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to logout?',
                style: theme.dialogTheme.contentTextStyle ?? theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.error.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please make sure you have backed up your private key before logging out. You will need it to access your account again.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurface,
              ),
              child: Text(
                'Cancel',
                style: theme.textTheme.labelLarge,
              ),
            ),
            FilledButton.tonal(
              onPressed: () async {
                // Close dialog first
                Navigator.of(context).pop();
                
                // Wait a frame to ensure dialog is closed
                await Future.delayed(const Duration(milliseconds: 100));
                
                // Close drawer if still open
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
                
                // Wait another frame to ensure drawer is closed
                await Future.delayed(const Duration(milliseconds: 100));
                
                // Save user pubkey (clear it)
                await ChuChuCacheManager
                    .defaultOXCacheManager
                    .saveForeverData(
                  StorageKeyTool.CHUCHU_USER_PUBKEY,
                  '',
                );

                // Perform logout
                await ChuChuUserInfoManager.sharedInstance
                    .logout(needObserver: true);
                
                // Navigate to login page and clear entire navigation stack
                // Use global navigator key to ensure we navigate from root context
                final navigatorContext = ChuChuNavigator.navigatorKey.currentContext ?? context;
                Navigator.of(navigatorContext).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false, // Remove all previous routes
                );
              },
              child: Text(
                'Logout',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
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
