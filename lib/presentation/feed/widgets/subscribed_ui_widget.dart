import 'package:chuchu/core/relayGroups/model/relayGroupDB_isar.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/config/subscription_config.dart';
import 'package:flutter/material.dart';

import '../../../core/wallet/wallet.dart';
import '../../../core/widgets/common_toast.dart';
import '../../../core/account/relays.dart';
import '../../../core/account/account.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/relayGroups/relayGroup+info.dart';
import '../../drawerMenu/subscription/widgets/subscription_payment_dialog.dart';

enum ESubscriptionStatus {
  unsubscribed('unsubscribed'),
  subscribed('subscribed'),
  free('free'),
  author('author');

  const ESubscriptionStatus(this.value);
  final String value;
}

class SubscribedOptionWidget extends StatefulWidget {
  final RelayGroupDBISAR relayGroup;
  final ESubscriptionStatus subscriptionStatus;
  final VoidCallback? onSubscriptionSuccess; // Callback for subscription success

  const SubscribedOptionWidget({
    super.key,
    required this.relayGroup,
    required this.subscriptionStatus,
    this.onSubscriptionSuccess,
  });

  @override
  State<SubscribedOptionWidget> createState() => SubscribedOptionWidgetState();
}

class SubscribedOptionWidgetState extends State<SubscribedOptionWidget> {
  bool _isBundlesExpanded = false;
  bool _isCreatingInvoice = false;
  String? _loadingButtonId; // Track which button is loading

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildSubscriptionSection(context),
        const SizedBox(height: 20),
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
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          _buildSubscriptionButton(context, monthlyPrice),
          const SizedBox(height: 8),
          _buildSubscriptionInfo(context, monthlyPrice),
          if (widget.subscriptionStatus ==
              ESubscriptionStatus.unsubscribed) ...[
            const SizedBox(height: 24),
            _buildSubscriptionBundles(context, monthlyPrice),
          ],
        ],
      ),
    );
  }

  /// Build subscription button based on status
  Widget _buildSubscriptionButton(BuildContext context, int monthlyPrice) {
    switch (widget.subscriptionStatus) {
      case ESubscriptionStatus.unsubscribed:
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: _isCreatingInvoice ? Colors.grey : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isCreatingInvoice ? null : () async{
                  await _updateSubscriptionSettings(1, buttonId: 'monthly');
              },
              borderRadius: BorderRadius.circular(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isCreatingInvoice && _loadingButtonId == 'monthly') ...[
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Creating Invoice...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else ...[
                    Text(
                      'SUBSCRIBE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$monthlyPrice ${SubscriptionConfig.currencyUnit} per month',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ).setPadding(EdgeInsets.symmetric(horizontal: 16.0)),
            ),
          ),
        );
      case ESubscriptionStatus.subscribed:
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).dividerColor.withAlpha(30),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SUBSCRIBED',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$monthlyPrice ${SubscriptionConfig.currencyUnit} per month',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ).setPadding(EdgeInsets.symmetric(horizontal: 16.0)),
          ),
        );
      case ESubscriptionStatus.free:
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
                Text(
                  'FOR FREE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ).setPadding(EdgeInsets.symmetric(horizontal: 16.0)),
          ),
        );
      case ESubscriptionStatus.author:
        return const SizedBox();
    }
  }

  Widget _buildSubscriptionInfo(BuildContext context, int monthlyPrice) {
    switch (widget.subscriptionStatus) {
      case ESubscriptionStatus.unsubscribed:
        return Row(
          children: [
            Text(
              'Renews for $monthlyPrice ${SubscriptionConfig.currencyUnit} / month',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const Spacer(),
            Text(
              _getNextMonthDate(),
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        );
      case ESubscriptionStatus.subscribed:
        return Row(
          children: [
            Text(
              'Renews for $monthlyPrice ${SubscriptionConfig.currencyUnit} / month',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const Spacer(),
            Text(
              _getNextMonthDate(),
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        );
      case ESubscriptionStatus.free:
        return const SizedBox();
      case ESubscriptionStatus.author:
        return const SizedBox();
    }
  }

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
                _isBundlesExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
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
                final discountPercent =
                    SubscriptionConfig.getDiscountPercentage(duration);
                final totalPrice = SubscriptionConfig.calculatePriceForDuration(
                  monthlyPrice,
                  duration,
                );
                final displayName = _getDurationDisplayName(duration);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildBundleButton(
                    title:
                        '${displayName.toUpperCase()} ($discountPercent% off)',
                    price:
                        '$totalPrice ${SubscriptionConfig.currencyUnit} total',
                    buttonId: duration.name, // Use duration name as button ID
                    onTap: () async{
                      int? moths = SubscriptionConfig.durationMultipliers[duration];
                      if(moths != null){
                        await _updateSubscriptionSettings(moths, buttonId: duration.name);
                      }
                    },
                  ),
                );
              }),
        ],
      ],
    );
  }

  Widget _buildBundleButton({
    required String title,
    required String price,
    required String buttonId,
    required VoidCallback onTap,
  }) {
    final isThisButtonLoading = _isCreatingInvoice && _loadingButtonId == buttonId;
    
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: _isCreatingInvoice ? Colors.grey : Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isCreatingInvoice ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: isThisButtonLoading
                      ? Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Creating Invoice...',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              if (!_isCreatingInvoice)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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

  String _getNextMonthDate() {
    // Get current user's pubkey
    final currentPubkey = Account.sharedInstance.currentPubkey;
    
    // Get subscription expiry from memberSubscriptionExpiry
    final memberSubscriptionExpiry = widget.relayGroup.memberSubscriptionExpiry;
    
    if (memberSubscriptionExpiry != null && 
        memberSubscriptionExpiry.containsKey(currentPubkey)) {
      // Get timestamp for current user
      final timestamp = memberSubscriptionExpiry[currentPubkey];
      
      if (timestamp != null) {
        // Convert timestamp to DateTime
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        
        return '${months[expiryDate.month - 1]} ${expiryDate.day}, ${expiryDate.year}';
      }
    }
    
    // Fallback to next month calculation if no expiry data found
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, now.day);

    final adjustedNextMonth = DateTime(
      nextMonth.year + (nextMonth.month > 12 ? 1 : 0),
      nextMonth.month > 12 ? nextMonth.month - 12 : nextMonth.month,
      nextMonth.day,
    );

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[adjustedNextMonth.month - 1]} ${adjustedNextMonth.day}, ${adjustedNextMonth.year}';
  }


  Future<void> _updateSubscriptionSettings(int months, {String? buttonId}) async {
    try {

      String groupId = widget.relayGroup.groupId;

      if (groupId.isEmpty) {
        CommonToast.instance.show(context, 'No active subscription found');
        return;
      }

      setState(() {
        _isCreatingInvoice = true;
        _loadingButtonId = buttonId;
      });

      await _createSubscriptionInvoice(groupId, months);

    } catch (e) {
      CommonToast.instance.show(context, 'Error updating subscription: ${e.toString()}');
    } finally {
      // Clear loading state
      if (mounted) {
        setState(() {
          _isCreatingInvoice = false;
          _loadingButtonId = null;
        });
      }
    }
  }

  Future<void> _createSubscriptionInvoice(String groupId, int months) async {
    try {
      final wallet = Wallet();

      if (!wallet.isConnected) {
        await wallet.connectToWallet();
      }

      if (!wallet.isConnected) {
        CommonToast.instance.show(context, 'Wallet not connected. Please try again.');
        return;
      }


      final relayPubkey = SubscriptionConfig.relayPubkey;

      final result = await wallet.makeSubscriptionInvoice(
        groupId: groupId,
        month: months,
        relayPubkey: relayPubkey,
      );

      if (result != null && !result.containsKey('error')) {
        final bolt11 = result['invoice'] as String?;  // NIP-47 uses 'invoice' field
        final amount = result['amount'] as int?;
        final paymentHash = result['payment_hash'] as String?;
        final expiresAt = result['expires_at'] as int?;

        if (bolt11 != null && amount != null) {

          // Show payment dialog
          if (mounted) {
            // Clear loading state before showing dialog
            setState(() {
              _isCreatingInvoice = false;
            });
            
            showDialog(
              context: context,
              builder: (context) => SubscriptionPaymentDialog(
                invoice: paymentHash ?? '',
                bolt11: bolt11,
                amount: amount,
                description: 'Subscription for $months month(s)',
                expiresAt: expiresAt != null
                    ? DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000)
                    : DateTime.now().add(const Duration(minutes: 15)),
                onPaymentSuccess:(){
                  _handlePaymentSuccess(groupId, months);
                }
              ),
            );
          }
        } else {
          CommonToast.instance.show(context, 'Invalid invoice data received');
        }
      } else {
        final errorMessage = result?['message'] ?? 'Failed to create subscription invoice';
        CommonToast.instance.show(context, errorMessage);
      }
    } catch (e) {
      print('Error creating subscription invoice: $e');
      CommonToast.instance.show(context, 'Error creating subscription invoice: ${e.toString()}');
    }
  }

  /// Handle successful payment
  void _handlePaymentSuccess(String groupId, int months) async {
    try {
      print('Payment successful for group $groupId, months: $months');
      
      // Sync my groups from relays to get the latest data
      await _syncMyGroupsFromRelays();
      
      CommonToast.instance.show(context, 'Subscription payment successful!');
      
      if (widget.onSubscriptionSuccess != null) {
        widget.onSubscriptionSuccess!();
      }
      
      Navigator.pop(context);
    } catch (e) {
      print('Error handling payment success: $e');
      CommonToast.instance.show(context, 'Payment successful but failed to sync groups');
      Navigator.pop(context);
    }
  }

  /// Sync my groups from relays
  Future<void> _syncMyGroupsFromRelays() async {
    try {
      // Get the recommend group relays
      final relays = Relays.sharedInstance.recommendGroupRelays;
      
      if (relays.isNotEmpty) {
        // Call searchMyGroupsMetadataFromRelays to sync my groups
        // This method will automatically sync myGroups
        final groups = await RelayGroup.sharedInstance.searchMyGroupsMetadataFromRelays(
          relays,
          (groups) {
            print('Synced ${groups.length} groups from relays');
          },
        );
        print('Successfully synced ${groups.length} groups from relays');
      }
    } catch (e) {
      print('Error syncing my groups from relays: $e');
      rethrow;
    }
  }
}
