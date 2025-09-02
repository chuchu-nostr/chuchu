import 'package:chuchu/core/account/account.dart';
import 'package:chuchu/core/relayGroups/relayGroup+member.dart';
import 'package:flutter/material.dart';
import '../../../../core/account/relays.dart';
import '../../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../../core/relayGroups/relayGroup.dart';
import '../../../../core/widgets/common_toast.dart';

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
  bool _isLoading = false;
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
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _createSettings() async {
    if (_isPaidSubscription && _priceController.text.isEmpty) {
      CommonToast.instance.show(context, 'Please set a subscription price');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      double price = 0.0;
      String priceText = 'Free';
      
      if (_isPaidSubscription) {
        String cleanPriceText = _priceController.text.replaceAll(RegExp(r'[^\d.]'), '');
        if (cleanPriceText.isEmpty) {
          CommonToast.instance.show(context, 'Please enter a valid price');
          setState(() {
            _isLoading = false;
          });
          return;
        }
        
        price = double.parse(cleanPriceText);
        priceText = '\$${price.toStringAsFixed(2)}';
      }
      
      RelayGroupDBISAR? relayGroupDB = await RelayGroup.sharedInstance.createGroup(
        _subscriptionRelay,
        Account.sharedInstance.currentPubkey,
        about: _isPaidSubscription 
            ? 'Premium content subscription - $priceText per ${_selectedTier?.duration ?? 'month'}'
            : 'Free subscription content',
        closed: _isPaidSubscription,
      );

      if(relayGroupDB != null){
        String message = _isPaidSubscription 
            ? 'Premium subscription created successfully at $priceText'
            : 'Free subscription created successfully';
        CommonToast.instance.show(context, message);
        Navigator.pop(context);
      } else {
        CommonToast.instance.show(context, 'Failed to create subscription');
      }
    } catch (e) {
      CommonToast.instance.show(context, 'Error creating subscription: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                    onPressed: _isLoading ? null : _createSettings,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            'Create Subscription',
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
}
