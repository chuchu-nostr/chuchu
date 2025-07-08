import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:flutter/material.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/utils/feed_utils.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../data/models/noted_ui_model.dart';
import '../widgets/feed_widget.dart';
import 'feed_info_page.dart';

class FeedReplyPage extends StatefulWidget {
  final NotedUIModel notedUIModel;
  const FeedReplyPage({super.key, required this.notedUIModel});

  @override
  State<FeedReplyPage> createState() => _FeedReplyPageState();
}

class _FeedReplyPageState extends State<FeedReplyPage> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0.5,
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                elevation: 0,
              ),
              child: const Text('Push', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quoted tweet card
          _momentItemWidget(),
          // Reply input area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonImage(iconName: 'icon_user_default.png',size: 40,),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      maxLines: null,
                      minLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Post your reply',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom toolbar
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 8.px,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.image), onPressed: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _momentItemWidget() {
    String pubKey = widget.notedUIModel.noteDB.author;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        ChuChuNavigator.pushPage(
          context,
              (context) => FeedInfoPage(
            notedUIModel: widget.notedUIModel,
            isShowReply: false,
          ),
        );
      },
      child: IntrinsicHeight(
        child: ValueListenableBuilder<UserDBISAR>(
          valueListenable: Account.sharedInstance.getUserNotifier(pubKey),
          builder: (context, value, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    FeedWidgetsUtils.clipImage(
                      borderRadius: 40.px,
                      imageSize: 40.px,
                      child: GestureDetector(
                        onTap: () {},
                        child: ChuChuCachedNetworkImage(
                          imageUrl: value.picture ?? '',
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) =>
                              FeedWidgetsUtils.badgePlaceholderImage(),
                          errorWidget:
                              (context, url, error) =>
                              FeedWidgetsUtils.badgePlaceholderImage(),
                          width: 40.px,
                          height: 40.px,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4.px),
                        width: 1.0,
                        color: Theme.of(context).dividerColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                ).setPaddingOnly(right: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _momentUserInfoWidget(value),
                      FeedWidget(
                        isShowOption: false,
                        feedWidgetLayout: EFeedWidgetLayout.fullScreen,
                        isShowAllContent: false,
                        isShowBottomBorder: false,
                        isShowReply: false,
                        notedUIModel: widget.notedUIModel,
                        isShowUserInfo: false,
                        clickMomentCallback: (
                            NotedUIModel? notedUIModel,
                            ) async {
                          await ChuChuNavigator.pushPage(
                            context,
                                (context) => FeedInfoPage(
                              notedUIModel: widget.notedUIModel,
                              isShowReply: false,
                            ),
                          );
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            'Reply ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.px,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '@${value.name}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14.px,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ).setPaddingOnly(left: 18.0,right:18.0);
  }

  Widget _momentUserInfoWidget(UserDBISAR userDB) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              userDB.name ?? '--',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14.px,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          FeedUtils.getUserMomentInfo(
            userDB,
            widget.notedUIModel!.createAtStr,
          )[0],
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 12.px,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

}