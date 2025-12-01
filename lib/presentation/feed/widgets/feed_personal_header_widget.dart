import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget personalPageHeader(RelayGroupDBISAR user) {
    final badgeUrl = user.picture ?? '';
    DecorationImage? image;
    if (badgeUrl.isNotEmpty) {
      image = DecorationImage(
        image: CachedNetworkImageProvider(badgeUrl),
        fit: BoxFit.cover,
        onError: (_, __) {},
      );
    }
    return Container(
      width: double.infinity,
      height: widget.isShowAppBar ? 150 : 220,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        image: image,
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildNavigationBar(user),
            // _buildDataRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar(RelayGroupDBISAR user) {
    return Row(
      children: [
        IconButton(
          onPressed: () => ChuChuNavigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              border: Border.all(color: Colors.white, width: 0.5),
            ),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.pink.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
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
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 18, top: 8),
          child: Text(
            user.name ?? '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 18),
          child: Text(
            user.about,
            style: const TextStyle(color: kIconState, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
