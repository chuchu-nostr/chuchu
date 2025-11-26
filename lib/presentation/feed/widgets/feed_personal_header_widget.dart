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
            _buildPersonalInfo(user),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget personalPageHeader(RelayGroupDBISAR user) {
    final badgeUrl = user.picture;
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

  Widget personalOption(RelayGroupDBISAR user) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildProfileImage(user),
        ],
      ),
    );
  }

  Widget _buildProfileImage(RelayGroupDBISAR user) {
    placeholder(_, __) => FeedWidgetsUtils.badgePlaceholderImage();
    errorWidget(_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage();
    return ValueListenableBuilder<UserDBISAR>(
      valueListenable: Account.sharedInstance.getUserNotifier(
        user.groupId,
      ),
      builder: (context, user, child) {
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
                  child: ChuChuCachedNetworkImage(
                    imageUrl: user.picture ?? '',
                    fit: BoxFit.cover,
                    placeholder: placeholder,
                    errorWidget: errorWidget,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPersonalInfo(RelayGroupDBISAR user) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 18, top: 8),
          child: Text(
            user.name,
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
