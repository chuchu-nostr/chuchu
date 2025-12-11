import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../core/widgets/common_image.dart';

class FeedPersonalHeaderWidget extends StatefulWidget {
  final RelayGroupDBISAR relayGroupDB;
  final bool isShowAppBar;
  final Widget actionWidget;

  const FeedPersonalHeaderWidget({
    super.key,
    required this.relayGroupDB,
    required this.isShowAppBar,
    required this.actionWidget,
  });

  @override
  FeedPersonalHeaderWidgetState createState() =>
      FeedPersonalHeaderWidgetState();
}

class FeedPersonalHeaderWidgetState extends State<FeedPersonalHeaderWidget> {

  @override
  void initState() {
    super.initState();
    updateUserInfo();
  }

  void updateUserInfo()async {
    UserDBISAR? user = await Account.sharedInstance.getUserInfo(widget.relayGroupDB.groupId);
  }

  String _formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      double k = count / 1000;
      if (k % 1 == 0) {
        return '${k.toInt()}K';
      } else {
        return '${k.toStringAsFixed(1)}K';
      }
    } else {
      double m = count / 1000000;
      if (m % 1 == 0) {
        return '${m.toInt()}M';
      } else {
        return '${m.toStringAsFixed(1)}M';
      }
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RelayGroupDBISAR>(
      valueListenable: RelayGroup.sharedInstance.getRelayGroupNotifier(
        widget.relayGroupDB.groupId,
      ),
      builder: (context, user, child) {
        return Column(
          children: [
            personalPageHeader(user),
            personalOption(user),
            personalInfo(user),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget personalPageHeader(RelayGroupDBISAR user) {
    final badgeUrl = user.picture;
    return Container(
      width: double.infinity,
      height: widget.isShowAppBar ? 150 : 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: kGradientColors,
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          if (badgeUrl.isNotEmpty)
            Positioned.fill(
              child: ChuChuCachedNetworkImage(
                imageUrl: badgeUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: widget.isShowAppBar ? 150 : 220,
                placeholder: (_, __) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [kPrimary, kSecondary],
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [kPrimary, kSecondary],
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                _buildNavigationBar(user),
                // _buildDataRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(RelayGroupDBISAR user) {
    return Row(
      children: [
        IconButton(
          onPressed: () => ChuChuNavigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              Text(
                user.name,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.verified, color: Colors.white, size: 20),
            ],
          ),
        ),
        widget.actionWidget,
      ],
    );
  }

  Widget _buildDataRow() {
    Widget buildDot = Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
    return Container(
      margin: const EdgeInsets.only(left: 50),
      child: Row(
        children: [
          _buildStatItem(icon: Icons.landscape, value: '1.4K'),
          buildDot,
          _buildStatItem(icon: Icons.videocam, value: '334'),
          buildDot,
          _buildStatItem(icon: Icons.favorite, value: '621K'),
        ],
      ),
    );
  }

  Widget _buildStatItem({required IconData icon, required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget personalOption(RelayGroupDBISAR user) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildProfileImage(user),
          // _buildActionsRow(),
        ],
      ),
    );
  }

  Widget _buildProfileImage(RelayGroupDBISAR relayGroup) {
    // Define placeholder and error widget functions
    final placeholderWidget = (_, __) => FeedWidgetsUtils.badgePlaceholderImage(size: 100);
    final errorWidgetBuilder = (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(size: 100);


    return ValueListenableBuilder<UserDBISAR>(
      valueListenable: Account.sharedInstance.getUserNotifier(
        relayGroup.groupId,
      ),
      builder: (context, userInfo, child) {
        final imageUrl = userInfo.picture ?? '';

        return Positioned(
          top: -35,
          left: 18,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.2),
              //     blurRadius: 2,
              //     offset: Offset(0, 1),
              //   ),
              // ],
            ),
            child: GestureDetector(
              onTap: () {},
              child: FeedWidgetsUtils.clipImage(
                borderRadius: 100,
                imageSize: 100,
                child: imageUrl.isNotEmpty
                    ? ChuChuCachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: placeholderWidget,
                  errorWidget: errorWidgetBuilder,
                  width: 100,
                  height: 100,
                )
                    : FeedWidgetsUtils.badgePlaceholderImage(size: 100),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build actions row
  Widget _buildActionsRow() {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 8),
      child: Row(
        children: [const Expanded(child: SizedBox()), personalPageActions()],
      ),
    );
  }

  Widget personalPageActions() {
    return Row(
      children: [
        _buildIconButton(iconName: 'zaps_blue_icon.png', onTap: () {}),
        _buildIconButton(iconName: 'favorite_blue_icon.png', onTap: () {}),
        _buildIconButton(iconName: 'share_blue_icon.png', onTap: () {}),
      ],
    );
  }

  Widget _buildIconButton({
    required String iconName,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: KBorderColor, width: 1),
        ),
        child: Center(child: CommonImage(iconName: iconName, size: 24)),
      ),
    );
  }

  Widget personalInfo(RelayGroupDBISAR user) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 18, top: 8),
          child: Text(
            user.name,
            style: GoogleFonts.inter(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 18),
          child: Text(
            user.about,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Following and Followers stats
        ValueListenableBuilder<UserDBISAR>(
          valueListenable: Account.sharedInstance.getUserNotifier(
            user.groupId,
          ),
          builder: (context, userInfo, child) {
            final followingCount = userInfo.followingList?.length ?? 0;
            final followersCount = userInfo.followersList?.length ?? 0;

            return Container(
              margin: const EdgeInsets.only(left: 6),

              width: double.infinity,
              child: Row(
                children: [
                  // Following
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatCount(followingCount),
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Following',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
                  // Followers
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatCount(followersCount),
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Followers',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
