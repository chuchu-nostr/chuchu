import 'package:chuchu/core/account/account.dart';
import 'package:chuchu/core/relayGroups/relayGroup+member.dart';
import 'package:flutter/material.dart';
import '../../../../core/account/relays.dart';
import '../../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../../core/relayGroups/relayGroup.dart';
import '../../../../core/widgets/common_toast.dart';
import '../../../../core/wallet/wallet.dart';
import '../widgets/subscription_payment_dialog.dart';

class SubscriptionTier {
  final String name;
  final String duration;
  final int price;
  final bool isDefault;

  SubscriptionTier({
    required this.name,
    required this.duration,
    required this.price,
    required this.isDefault,
  });

  String get formattedPrice => '\$${(price / 100).toStringAsFixed(2)}';
  String get priceText => '$formattedPrice per $duration';
}

class SubscriptionSettingsPage extends StatefulWidget {
  const SubscriptionSettingsPage({super.key});

  @override
  State<SubscriptionSettingsPage> createState() => _SubscriptionSettingsPageState();
}

class _SubscriptionSettingsPageState extends State<SubscriptionSettingsPage> {
  final TextEditingController _priceController = TextEditingController();

  bool _isPaidSubscription = true;
  final Map<String, String> _customPrices = {};

  String _subscriptionRelay = Relays.sharedInstance.recommendGroupRelays.first;
  
  final List<SubscriptionTier> _subscriptionTiers = [
    SubscriptionTier(
      name: 'Monthly',
      duration: 'month',
      price: 999,
      isDefault: true,
    ),
    SubscriptionTier(
      name: '3 Months',
      duration: '3 months',
      price: 2499,
      isDefault: false,
    ),
    SubscriptionTier(
      name: '6 Months',
      duration: '6 months',
      price: 4499,
      isDefault: false,
    ),
    SubscriptionTier(
      name: '12 Months',
      duration: 'year',
      price: 7999,
      isDefault: false,
    ),
  ];
  
  SubscriptionTier? _selectedTier;

  @override
  void initState() {
    super.initState();
    _selectedTier = _subscriptionTiers.firstWhere((tier) => tier.isDefault);
    _priceController.text = (_selectedTier!.price / 100).toStringAsFixed(2);
    init();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  bool _hasExistingGroup = false;
  
  void init(){
    Map<String, ValueNotifier<RelayGroupDBISAR>>? groups = RelayGroup.sharedInstance.myGroups;
    if(groups[Account.sharedInstance.currentPubkey] != null){
      _hasExistingGroup = true;
    }
  }

  Future<void> _createSettings() async {
    if (_isPaidSubscription && _priceController.text.isEmpty) {
      CommonToast.instance.show(context, 'Please set a subscription price');
      return;
    }

    try {
      double price = 0.0;
      String priceText = 'Free';
      
      if (_isPaidSubscription) {
        String cleanPriceText = _priceController.text.replaceAll(RegExp(r'[^\d.]'), '');
        if (cleanPriceText.isEmpty) {
          CommonToast.instance.show(context, 'Please enter a valid price');
          return;
        }
        
        price = double.parse(cleanPriceText);
        priceText = '\$${price.toStringAsFixed(2)}';
      }
      
      if (_hasExistingGroup) {
        // Update existing subscription settings
        int months = _getSelectedMonths();
        await _updateSubscriptionSettings(months);
      } else {
        // Create new subscription
        RelayGroupDBISAR? relayGroupDB = await RelayGroup.sharedInstance.createGroup(
          _subscriptionRelay,
          Account.sharedInstance.currentPubkey,
          about: _isPaidSubscription 
              ? 'Premium content subscription - $priceText per ${_selectedTier?.duration ?? 'month'}'
              : 'Free subscription content',
          closed: _isPaidSubscription,
        );

        if(relayGroupDB != null){
          // If it's a paid subscription, create subscription invoice
          if (_isPaidSubscription) {
            int months = _getSelectedMonths();
            await _createSubscriptionInvoice(relayGroupDB.id.toString(), months);
          }
          
          String message = _isPaidSubscription 
              ? 'Premium subscription created successfully at $priceText'
              : 'Free subscription created successfully';
          CommonToast.instance.show(context, message);
          Navigator.pop(context);
        } else {
          CommonToast.instance.show(context, 'Failed to create subscription');
        }
      }
    } catch (e) {
      CommonToast.instance.show(context, 'Error ${_hasExistingGroup ? 'updating' : 'creating'} subscription: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Subscription'),
        elevation: 0,
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
                    Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Theme.of(context).dividerColor.withAlpha(60)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isPaidSubscription ? 'Premium Subscription' : 'Free Subscription',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _isPaidSubscription 
                                      ? 'Users pay to access your content'
                                      : 'Users can access your content for free',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _isPaidSubscription,
                              onChanged: (value) {
                                setState(() {
                                  _isPaidSubscription = value;
                                  if (_isPaidSubscription) {
                                    _selectedTier = _subscriptionTiers.firstWhere((tier) => tier.isDefault);
                                    if (_priceController.text.isEmpty) {
                                      _priceController.text = (_selectedTier!.price / 100).toStringAsFixed(2);
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      if (_isPaidSubscription) ...[
                        Text(
                          'Set Subscription Price',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Text(
                          'Subscription Duration',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        for (int i = 0; i < _subscriptionTiers.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildDurationOption(_subscriptionTiers[i]),
                          ),
                        
                        const SizedBox(height: 16),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Custom Price (USD)',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  if (_selectedTier != null) {
                                    String suggestedPrice = (_selectedTier!.price / 100).toStringAsFixed(2);
                                    _priceController.text = suggestedPrice;
                                    _customPrices[_selectedTier!.name] = suggestedPrice;
                                  }
                                });
                              },
                              child: Text(
                                'Use Suggested: \$${((_selectedTier?.price ?? 999) / 100).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            setState(() {
                              if (_selectedTier != null) {
                                _customPrices[_selectedTier!.name] = value;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            prefixText: '\$ ',
                            hintText: '0.00',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Theme.of(context).dividerColor.withAlpha(60)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Free Subscription',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Users can access your content without payment',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'What subscribers get:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildBenefitItem('Exclusive content access'),
                      _buildBenefitItem('Direct messaging with you'),
                      _buildBenefitItem('Early access to new posts'),
                      _buildBenefitItem('Cancel anytime'),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
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
                    onPressed: _createSettings,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _hasExistingGroup ? 'Update Subscription' : 'Create Subscription',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimary,
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
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationOption(SubscriptionTier tier) {
    final isSelected = _selectedTier == tier;
    
    String displayPrice;
    if (_customPrices.containsKey(tier.name) && _customPrices[tier.name]!.isNotEmpty) {
      String customPrice = _customPrices[tier.name]!.replaceAll(RegExp(r'[^\d.]'), '');
      if (customPrice.isNotEmpty) {
        try {
          double price = double.parse(customPrice);
          displayPrice = '\$${price.toStringAsFixed(2)} per ${tier.duration}';
        } catch (e) {
          displayPrice = tier.priceText;
        }
      } else {
        displayPrice = tier.priceText;
      }
    } else {
      displayPrice = tier.priceText;
    }
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTier = tier;
          if (_customPrices.containsKey(tier.name)) {
            _priceController.text = _customPrices[tier.name]!;
          } else {
            _priceController.text = (tier.price / 100).toStringAsFixed(2);
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tier.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              displayPrice,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Create subscription invoice using NIP-47
  Future<void> _createSubscriptionInvoice(String groupId, int months) async {
    try {
      // Get wallet instance
      final wallet = Wallet();
      
      // Ensure wallet is connected
      if (!wallet.isConnected) {
        await wallet.connectToWallet();
      }
      
      if (!wallet.isConnected) {
        CommonToast.instance.show(context, 'Wallet not connected. Please try again.');
        return;
      }

      // Use the months parameter passed to the method

      // Get relay pubkey (using the subscription relay)
      final relayPubkey = _getRelayPubkey();
      
      // Create subscription invoice
      final result = await wallet.makeSubscriptionInvoice(
        groupId: groupId,
        month: months,
        relayPubkey: relayPubkey,
      );

      if (result != null) {
        // TODO: Send the event to the relay and get response
        // For now, simulate getting invoice from relay
        double price = _getSelectedPrice();
        await _simulateInvoiceFromRelay(groupId, months, price);
        
        // Log the event for debugging
        print('Subscription invoice event created: ${result['event']}');
      } else {
        CommonToast.instance.show(context, 'Failed to create subscription invoice');
      }
    } catch (e) {
      print('Error creating subscription invoice: $e');
      CommonToast.instance.show(context, 'Error creating subscription invoice: ${e.toString()}');
    }
  }

  /// Simulate getting invoice from relay (for testing)
  Future<void> _simulateInvoiceFromRelay(String groupId, int months, double price) async {
    try {
      // Simulate delay for relay processing
      await Future.delayed(const Duration(seconds: 1));
      
      // Create a mock invoice for testing
      final mockInvoice = _createMockInvoice(price, months);
      
      // Show payment dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => SubscriptionPaymentDialog(
            invoice: mockInvoice['payment_hash'],
            bolt11: mockInvoice['bolt11'],
            amount: mockInvoice['amount'],
            description: mockInvoice['description'],
            expiresAt: mockInvoice['expires_at'],
            onPaymentSuccess: () {
              CommonToast.instance.show(context, 'Subscription payment successful!');
              Navigator.of(context).pop(); // Close payment dialog
              Navigator.of(context).pop(); // Close subscription settings
            },
          ),
        );
      }
    } catch (e) {
      CommonToast.instance.show(context, 'Failed to get invoice from relay: ${e.toString()}');
    }
  }

  /// Create mock invoice for testing
  Map<String, dynamic> _createMockInvoice(double price, int months) {
    // Convert price to sats (assuming price is in USD, 1 USD = 1000 sats for demo)
    final amountSats = (price * 1000).round();
    
    // Create a mock BOLT11 invoice
    final mockBolt11 = 'lnbc${amountSats}u1p${DateTime.now().millisecondsSinceEpoch}...';
    
    // Set expiration time to 15 minutes from now
    final expiresAt = DateTime.now().add(const Duration(minutes: 15));
    
    return {
      'payment_hash': 'mock_payment_hash_${DateTime.now().millisecondsSinceEpoch}',
      'bolt11': mockBolt11,
      'amount': amountSats,
      'description': 'Subscription for $months month${months > 1 ? 's' : ''} - \$${price.toStringAsFixed(2)}',
      'expires_at': expiresAt,
    };
  }

  /// Update existing subscription settings
  Future<void> _updateSubscriptionSettings(int months) async {
    try {
      // Get the current group ID (assuming we have access to it)
      // In a real implementation, you would get this from the current subscription
      String groupId = _getCurrentGroupId();
      
      if (groupId.isEmpty) {
        CommonToast.instance.show(context, 'No active subscription found');
        return;
      }

      // If it's a paid subscription, create a new subscription invoice
      if (_isPaidSubscription) {
        await _createSubscriptionInvoice(groupId, months);
      } else {
        // For free subscription updates, just show success message
        String message = 'Subscription settings updated to free';
        CommonToast.instance.show(context, message);
        Navigator.pop(context);
      }
    } catch (e) {
      CommonToast.instance.show(context, 'Error updating subscription: ${e.toString()}');
    }
  }

  /// Get selected months based on the current subscription tier
  int _getSelectedMonths() {
    if (_selectedTier != null) {
      if (_selectedTier!.duration.contains('3')) {
        return 3;
      } else if (_selectedTier!.duration.contains('6')) {
        return 6;
      } else if (_selectedTier!.duration.contains('12')) {
        return 12;
      }
    }
    return 1; // Default to 1 month
  }

  /// Get selected price based on the current subscription tier
  double _getSelectedPrice() {
    if (_selectedTier != null) {
      // Check if there's a custom price for this tier
      if (_customPrices.containsKey(_selectedTier!.name)) {
        String customPriceText = _customPrices[_selectedTier!.name]!;
        String cleanPriceText = customPriceText.replaceAll(RegExp(r'[^\d.]'), '');
        if (cleanPriceText.isNotEmpty) {
          return double.parse(cleanPriceText);
        }
      }
      // Use the tier's default price
      return _selectedTier!.price / 100.0;
    }
    return 9.99; // Default price
  }

  /// Get current group ID for the active subscription
  String _getCurrentGroupId() {
    // In a real implementation, you would get this from the current subscription state
    // For now, return a placeholder or get it from the UI state
    return 'current_group_id'; // This should be replaced with actual group ID
  }

  /// Get relay pubkey for the selected subscription relay
  String _getRelayPubkey() {
    // For now, return a default relay pubkey
    // In a real implementation, you would get this from the relay configuration
    // Note: NIP-4 encryption expects pubkey without the '02' or '03' prefix
    return '8a9e56512ec98da2b5789761f7af8f280baf98a09282360cd6ff1381b5e889bf';
  }
}
