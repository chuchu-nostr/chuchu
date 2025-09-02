import 'package:chuchu/core/account/account.dart';
import 'package:chuchu/core/relayGroups/relayGroup+member.dart';
import 'package:flutter/material.dart';
import '../../../../core/account/relays.dart';
import '../../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../../core/relayGroups/relayGroup.dart';
import '../../../../core/widgets/common_toast.dart';
import '../../../../core/config/storage_key_tool.dart';
import '../../../../core/manager/cache/chuchu_cache_manager.dart';

class SubscriptionTier {
  final String name;
  final String duration;
  final int originalPrice; // in cents
  final int discountedPrice; // in cents
  final int discount; // percentage
  final bool isDefault;

  SubscriptionTier({
    required this.name,
    required this.duration,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discount,
    required this.isDefault,
  });

  String get formattedPrice => '\$${(discountedPrice / 100).toStringAsFixed(2)}';
  String get formattedOriginalPrice => '\$${(originalPrice / 100).toStringAsFixed(2)}';
  String get discountText => discount > 0 ? '($discount% off)' : '';
  String get totalText => discount > 0 ? '$formattedPrice total' : '$formattedPrice per month';
}

class SubscriptionSettingsPage extends StatefulWidget {
  const SubscriptionSettingsPage({super.key});

  @override
  State<SubscriptionSettingsPage> createState() => _SubscriptionSettingsPageState();
}

class _SubscriptionSettingsPageState extends State<SubscriptionSettingsPage> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  bool _showDiscountOptions = false;

  String _subscriptionRelay = Relays.sharedInstance.recommendGroupRelays.first;
  
  // Subscription tiers with discounts
  final List<SubscriptionTier> _subscriptionTiers = [
    SubscriptionTier(
      name: 'Monthly',
      duration: '1 month',
      originalPrice: 999, // $9.99 in cents
      discountedPrice: 999,
      discount: 0,
      isDefault: true,
    ),
    SubscriptionTier(
      name: '3 Months',
      duration: '3 months',
      originalPrice: 2997, // 3 * $9.99
      discountedPrice: 2898, // 5% off
      discount: 5,
      isDefault: false,
    ),
    SubscriptionTier(
      name: '6 Months',
      duration: '6 months',
      originalPrice: 5994, // 6 * $9.99
      discountedPrice: 5398, // 10% off
      discount: 10,
      isDefault: false,
    ),
    SubscriptionTier(
      name: '12 Months',
      duration: '12 months',
      originalPrice: 11988, // 12 * $9.99
      discountedPrice: 5994, // 50% off
      discount: 50,
      isDefault: false,
    ),
  ];
  
  SubscriptionTier? _selectedTier;

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
    // Set default tier
    _selectedTier = _subscriptionTiers.firstWhere((tier) => tier.isDefault);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentSettings() async {
    try {
      final savedTierIndex = await ChuChuCacheManager.defaultOXCacheManager
          .getForeverData(StorageKeyTool.SUBSCRIPTION_TIER_INDEX);
      final savedDescription = await ChuChuCacheManager.defaultOXCacheManager
          .getForeverData(StorageKeyTool.SUBSCRIPTION_DESCRIPTION);

      if (mounted) {
        setState(() {
          if (savedTierIndex != null) {
            final index = int.tryParse(savedTierIndex);
            if (index != null && index >= 0 && index < _subscriptionTiers.length) {
              _selectedTier = _subscriptionTiers[index];
            }
          }
          _descriptionController.text = savedDescription ?? '';
        });
      }
    } catch (e) {
      print('Failed to load subscription settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    RelayGroupDBISAR? relayGroupDB = await RelayGroup.sharedInstance.createGroup(
      _subscriptionRelay,
      Account.sharedInstance.currentPubkey,
      about: _descriptionController.text,
      closed: false,
    );

    if(relayGroupDB != null){
      CommonToast.instance.show(context, 'Create successfully');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subscription Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Text(
                      'SUBSCRIBE AND GET THESE BENEFITS:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Benefits list
                    _buildBenefitItem('Full access to this user\'s content'),
                    _buildBenefitItem('Direct message with this user'),
                    _buildBenefitItem('Cancel your subscription at any time'),
                    const SizedBox(height: 24),
                    
                    // Monthly subscription option
                    _buildSubscriptionButton(_subscriptionTiers[0], isDefault: true),
                    const SizedBox(height: 8),
                    
                    // Renewal info
                    Row(
                      children: [
                        Text(
                          'This subscription renews at ${_subscriptionTiers[0].formattedPrice}.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            // Show renewal info dialog
                          },
                          child: const Text(
                            'Renewal info',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Discounted options
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showDiscountOptions = !_showDiscountOptions;
                        });
                      },
                      child: Row(
                        children: [
                          const Text(
                            'Discounted longer subscription options',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _showDiscountOptions ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Discounted subscription options
                    if (_showDiscountOptions) ...[
                      for (int i = 1; i < _subscriptionTiers.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildSubscriptionButton(_subscriptionTiers[i]),
                        ),
                    ],
                    
                    const SizedBox(height: 24),
                    
                    // Description input
                    const Text(
                      'Description (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Describe what subscribers will get...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Create Button
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Create',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionButton(SubscriptionTier tier, {bool isDefault = false}) {
    final isSelected = _selectedTier == tier;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTier = tier;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.blue[100],
          borderRadius: BorderRadius.circular(12),
          border: isSelected 
              ? Border.all(color: Colors.blue, width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tier.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (tier.discount > 0)
                  Text(
                    tier.discountText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
              ],
            ),
            Text(
              tier.totalText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
