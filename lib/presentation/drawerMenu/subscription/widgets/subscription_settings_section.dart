import 'package:flutter/material.dart';

class SubscriptionTier {
  final String name;
  final String duration;
  final int price;
  final bool isDefault;

  const SubscriptionTier({
    required this.name,
    required this.duration,
    required this.price,
    required this.isDefault,
  });

  String get formattedPrice => '\$${(price / 100).toStringAsFixed(2)}';
  String get priceText => '\$formattedPrice per $duration';
}

class SubscriptionSettingsSection extends StatefulWidget {
  final double initialMonthlyPrice;
  final Function(double monthlyPrice)? onPriceChanged;

  const SubscriptionSettingsSection({
    super.key,
    this.initialMonthlyPrice = 9.99,
    this.onPriceChanged,
  });

  static double calculatePriceForDuration(double monthlyPrice, String duration) {
    const Map<String, double> discountRates = {
      'month': 1.0,
      '3 months': 0.95,
      '6 months': 0.90,
      'year': 0.80,
    };
    
    const Map<String, int> durationMultipliers = {
      'month': 1,
      '3 months': 3,
      '6 months': 6,
      'year': 12,
    };
    
    final multiplier = durationMultipliers[duration] ?? 1;
    final discountRate = discountRates[duration] ?? 1.0;
    
    return monthlyPrice * multiplier * discountRate;
  }

  @override
  State<SubscriptionSettingsSection> createState() => _SubscriptionSettingsSectionState();
}

class _SubscriptionSettingsSectionState extends State<SubscriptionSettingsSection> {
  final TextEditingController _monthlyPriceController = TextEditingController();
  
  static const List<SubscriptionTier> _subscriptionTiers = [
    SubscriptionTier(name: 'Monthly', duration: 'month', price: 999, isDefault: true),
    SubscriptionTier(name: '3 Months', duration: '3 months', price: 2499, isDefault: false),
    SubscriptionTier(name: '6 Months', duration: '6 months', price: 4499, isDefault: false),
    SubscriptionTier(name: '12 Months', duration: 'year', price: 7999, isDefault: false),
  ];

  @override
  void initState() {
    super.initState();
    _monthlyPriceController.text = widget.initialMonthlyPrice.toStringAsFixed(2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyPriceChanged();
    });
  }

  @override
  void dispose() {
    _monthlyPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPriceControls(context),
        const SizedBox(height: 24),
        Text(
          'What subscribers get:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildBenefitItem(context, 'Exclusive content access'),
        _buildBenefitItem(context, 'Direct messaging with you'),
        _buildBenefitItem(context, 'Early access to new posts'),
        _buildBenefitItem(context, 'Cancel anytime'),
      ],
    );
  }


  Widget _buildPriceControls(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set Monthly Subscription Price',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _monthlyPriceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {});
                  _notifyPriceChanged();
                },
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  hintText: '9.99',
                  labelText: 'Monthly Price',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Subscription Options',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'All available subscription options with automatic discounts:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        for (final tier in _subscriptionTiers)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildDurationDisplay(context, tier),
          ),
      ],
    );
  }

  Widget _buildDurationDisplay(BuildContext context, SubscriptionTier tier) {
    final calculatedPrice = _calculatePrice(tier.duration);
    const Map<String, double> discountRates = {
      'month': 1.0,
      '3 months': 0.95,
      '6 months': 0.90,
      'year': 0.80,
    };
    final discountRate = discountRates[tier.duration] ?? 1.0;
    final discountPercent = ((1.0 - discountRate) * 100).toInt();
    
    String displayPrice = '\$${calculatedPrice.toStringAsFixed(2)}';
    String durationText = tier.duration == 'year' ? 'year' : tier.duration;
    
    final isMonthlyTier = tier.duration == 'month';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMonthlyTier 
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMonthlyTier 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor,
          width: isMonthlyTier ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tier.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isMonthlyTier
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (discountPercent > 0)
                  Text(
                    'Save $discountPercent%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isMonthlyTier
                          ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.9)
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '$displayPrice per $durationText',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isMonthlyTier
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBenefitItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }

  double _calculatePrice(String duration) {
    double monthlyPrice = 0.0;
    if (_monthlyPriceController.text.isNotEmpty) {
      final clean = _monthlyPriceController.text.replaceAll(RegExp(r'[^\d.]'), '');
      if (clean.isNotEmpty) {
        try {
          monthlyPrice = double.parse(clean);
        } catch (_) {
          monthlyPrice = 0.0;
        }
      }
    }
    
    return SubscriptionSettingsSection.calculatePriceForDuration(monthlyPrice, duration);
  }
  
  void _notifyPriceChanged() {
    if (widget.onPriceChanged != null) {
      double monthlyPrice = 0.0;
      if (_monthlyPriceController.text.isNotEmpty) {
        final clean = _monthlyPriceController.text.replaceAll(RegExp(r'[^\d.]'), '');
        if (clean.isNotEmpty) {
          try {
            monthlyPrice = double.parse(clean);
          } catch (_) {
            monthlyPrice = 0.0;
          }
        }
      }
      widget.onPriceChanged!(monthlyPrice);
    }
  }
}


