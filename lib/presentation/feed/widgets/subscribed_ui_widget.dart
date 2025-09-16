import 'package:chuchu/core/account/account.dart';
import 'package:chuchu/core/relayGroups/model/relayGroupDB_isar.dart';
import 'package:chuchu/core/relayGroups/relayGroup+info.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/config/subscription_config.dart';
import 'package:chuchu/presentation/feed/widgets/locked_content_section.dart';
import 'package:flutter/material.dart';

import '../../../core/account/relays.dart';
import '../../../core/relayGroups/relayGroup.dart';

/// Subscription status enum
enum SubscriptionStatus {
  unsubscribed('unsubscribed'),
  subscribed('subscribed'),
  free('free');

  const SubscriptionStatus(this.value);
  final String value;
}

class SubscribedOptionWidget extends StatefulWidget {
  final RelayGroupDBISAR relayGroup;

  const SubscribedOptionWidget({
    super.key,
    required this.relayGroup,
  });

  @override
  State<SubscribedOptionWidget> createState() => SubscribedOptionWidgetState();
}

class SubscribedOptionWidgetState extends State<SubscribedOptionWidget> {
  bool _isBundlesExpanded = false;

  SubscriptionStatus subscriptionStatus = SubscriptionStatus.unsubscribed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async{
      RelayGroupDBISAR? relayGroup = await RelayGroup.sharedInstance.getGroupMetadataFromRelay(
        widget.relayGroup.groupId,
        relay: Relays.sharedInstance.recommendGroupRelays.first,
        author: widget.relayGroup.author
    );
      subscriptionStatus = SubscriptionStatus.free;
      if(relayGroup != null && relayGroup.subscriptionAmount > 0 && relayGroup.members != null){
        if(relayGroup.members!.contains(Account.sharedInstance.currentPubkey) ){
          subscriptionStatus = SubscriptionStatus.subscribed;
        }else{
          subscriptionStatus = SubscriptionStatus.unsubscribed;
        }
      }

      setState(() {});
    }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSubscriptionSection(context),
        const SizedBox(height: 20),
        _buildContentSection(context),
      ],
    );
  }

  /// Build content section based on subscription status
  Widget _buildContentSection(BuildContext context) {
    switch (subscriptionStatus) {
      case SubscriptionStatus.unsubscribed:
        return LockedContentSection(
          onSubscribeToSeeContent: () {
            // TODO: Implement subscribe to see content action
          },
        );
      case SubscriptionStatus.subscribed:
        return _buildSubscribedContent(context);
      case SubscriptionStatus.free:
        return _buildFreeContent(context);
    }
  }

  /// Build content for subscribed users
  Widget _buildSubscribedContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          // Content tabs
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                ),
                child: const Text(
                  '335 POSTS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Text(
                '1212 MEDIA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // Unlock icon
          Icon(
            Icons.lock_open,
            size: 80,
            color: Colors.green[400],
          ),
          
          const SizedBox(height: 24),
          
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem(icon: Icons.landscape, value: '1.4K'),
              const SizedBox(width: 32),
              _buildStatItem(icon: Icons.videocam, value: '334'),
              const SizedBox(width: 32),
              _buildStatItem(icon: Icons.favorite, value: '621K'),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // Access content button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // TODO: Implement access content action
                },
                borderRadius: BorderRadius.circular(8),
                child: const Center(
                  child: Text(
                    'ACCESS CONTENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Build content for free users
  Widget _buildFreeContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          // Content tabs
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                ),
                child: const Text(
                  '335 POSTS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Text(
                '1212 MEDIA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // Free access icon
          Icon(
            Icons.public,
            size: 80,
            color: Colors.blue[400],
          ),
          
          const SizedBox(height: 24),
          
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem(icon: Icons.landscape, value: '1.4K'),
              const SizedBox(width: 32),
              _buildStatItem(icon: Icons.videocam, value: '334'),
              const SizedBox(width: 32),
              _buildStatItem(icon: Icons.favorite, value: '621K'),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // Free access button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // TODO: Implement free access action
                },
                borderRadius: BorderRadius.circular(8),
                child: const Center(
                  child: Text(
                    'VIEW FREE CONTENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Build stat item
  Widget _buildStatItem({required IconData icon, required String value}) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionSection(BuildContext context) {
    int monthlyPrice = widget.relayGroup.subscriptionAmount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUBSCRIPTION',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSubscriptionButton(context, monthlyPrice),
          const SizedBox(height: 8),
          _buildSubscriptionInfo(context, monthlyPrice),
          if (subscriptionStatus == SubscriptionStatus.unsubscribed) ...[
            const SizedBox(height: 24),
            _buildSubscriptionBundles(context, monthlyPrice),
          ],
        ],
      ),
    );
  }

  /// Build subscription button based on status
  Widget _buildSubscriptionButton(BuildContext context, int monthlyPrice) {
    switch (subscriptionStatus) {
      case SubscriptionStatus.unsubscribed:
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){},
              borderRadius: BorderRadius.circular(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SUBSCRIBE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    child: Text(
                      '$monthlyPrice ${SubscriptionConfig.currencyUnit} per month',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ).setPadding(EdgeInsets.symmetric(horizontal: 16.0)),
            ),
          ),
        );
      case SubscriptionStatus.subscribed:
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SUBSCRIBED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  child: Text(
                    '$monthlyPrice ${SubscriptionConfig.currencyUnit} per month',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ).setPadding(EdgeInsets.symmetric(horizontal: 16.0)),
          ),
        );
      case SubscriptionStatus.free:
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SUBSCRIBE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  child: Text(
                    'FOR FREE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ).setPadding(EdgeInsets.symmetric(horizontal: 16.0)),
          ),
        );
    }
  }

  /// Build subscription info based on status
  Widget _buildSubscriptionInfo(BuildContext context, int monthlyPrice) {
    switch (subscriptionStatus) {
      case SubscriptionStatus.unsubscribed:
        return Row(
          children: [
            Text(
              'Renews for $monthlyPrice ${SubscriptionConfig.currencyUnit} / month',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Text(
              _getNextMonthDate(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        );
      case SubscriptionStatus.subscribed:
        return Row(
          children: [
            Text(
              'Next billing: $monthlyPrice ${SubscriptionConfig.currencyUnit}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Text(
              _getNextMonthDate(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        );
      case SubscriptionStatus.free:
        return const SizedBox();
    }
  }

  /// Build subscription bundles (only for unsubscribed users)
  Widget _buildSubscriptionBundles(BuildContext context, int monthlyPrice) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'SUBSCRIPTION BUNDLES',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isBundlesExpanded = !_isBundlesExpanded;
                });
              },
              child: Icon(
                _isBundlesExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                color: Colors.grey[600],
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isBundlesExpanded) ...[
          ...SubscriptionConfig.availableDurations
              .where((duration) => duration != SubscriptionDuration.month)
              .map((duration) {
            final discountPercent = SubscriptionConfig.getDiscountPercentage(duration);
            final totalPrice = SubscriptionConfig.calculatePriceForDuration(monthlyPrice, duration);
            final displayName = _getDurationDisplayName(duration);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildBundleButton(
                title: '${displayName.toUpperCase()} (${discountPercent}% off)',
                price: '$totalPrice ${SubscriptionConfig.currencyUnit} total',
                onTap: (){},
              ),
            );
          }).toList(),
        ],
      ],
    );
  }

  Widget _buildBundleButton({
    required String title,
    required String price,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Get duration display name for UI
  String _getDurationDisplayName(SubscriptionDuration duration) {
    switch (duration) {
      case SubscriptionDuration.month:
        return 'Monthly';
      case SubscriptionDuration.threeMonths:
        return '3 Months';
      case SubscriptionDuration.sixMonths:
        return '6 Months';
      case SubscriptionDuration.year:
        return '12 Months';
    }
  }

  /// Get next month date in format 'MMM d, yyyy'
  String _getNextMonthDate() {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, now.day);

    // Handle year rollover
    final adjustedNextMonth = DateTime(
      nextMonth.year + (nextMonth.month > 12 ? 1 : 0),
      nextMonth.month > 12 ? nextMonth.month - 12 : nextMonth.month,
      nextMonth.day,
    );

    // Format the date
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return '${months[adjustedNextMonth.month - 1]} ${adjustedNextMonth.day}, ${adjustedNextMonth.year}';
  }
}
