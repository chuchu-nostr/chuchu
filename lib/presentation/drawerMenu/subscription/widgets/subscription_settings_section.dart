import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chuchu/core/config/subscription_config.dart';

class SubscriptionTier {
  final String name;
  final SubscriptionDuration duration;
  final bool isDefault;

  const SubscriptionTier({
    required this.name,
    required this.duration,
    required this.isDefault,
  });
}

class SubscriptionSettingsSection extends StatefulWidget {
  final int initialMonthlyPrice;
  final Function(int monthlyPrice)? onPriceChanged;

  const SubscriptionSettingsSection({
    super.key,
    this.initialMonthlyPrice = SubscriptionConfig.defaultSubscriptionPrice,
    this.onPriceChanged,
  });

  static int calculatePriceForDuration(int monthlyPrice, SubscriptionDuration duration) {
    return SubscriptionConfig.calculatePriceForDuration(monthlyPrice, duration);
  }

  @override
  State<SubscriptionSettingsSection> createState() => _SubscriptionSettingsSectionState();
}

class _SubscriptionSettingsSectionState extends State<SubscriptionSettingsSection> {
  final TextEditingController _monthlyPriceController = TextEditingController();
  
  List<SubscriptionTier> get _subscriptionTiers {
    return SubscriptionConfig.availableDurations.map((duration) {
      return SubscriptionTier(
        name: _getDurationDisplayName(duration),
        duration: duration,
        isDefault: duration == SubscriptionDuration.month,
      );
    }).toList();
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
  
  int _getCurrentMonthlyPrice() {
    if (_monthlyPriceController.text.isNotEmpty) {
      try {
        return int.parse(_monthlyPriceController.text);
      } catch (_) {
        return SubscriptionConfig.defaultSubscriptionPrice;
      }
    }
    return SubscriptionConfig.defaultSubscriptionPrice;
  }

  @override
  void initState() {
    super.initState();
    _monthlyPriceController.text = widget.initialMonthlyPrice.toString();
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
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  setState(() {});
                  _notifyPriceChanged();
                },
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  prefixText: '${SubscriptionConfig.currencyUnit} ',
                  prefixStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,

                  ),
                  hintText: '',
                  labelText: 'Monthly Price (${SubscriptionConfig.currencyUnit})',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,

                  ),
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
    final discountPercent = SubscriptionConfig.getDiscountPercentage(tier.duration);
    
    String displayPrice = '$calculatedPrice ${SubscriptionConfig.currencyUnit}';
    String durationText = tier.duration == SubscriptionDuration.year ? 'year' : tier.duration.value;
    
    final isMonthlyTier = tier.duration == SubscriptionDuration.month;
    
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

  int _calculatePrice(SubscriptionDuration duration) {
    final monthlyPrice = _getCurrentMonthlyPrice();
    return SubscriptionSettingsSection.calculatePriceForDuration(monthlyPrice, duration);
  }
  
  void _notifyPriceChanged() {
    if (widget.onPriceChanged != null) {
      int monthlyPrice = 0;
      if (_monthlyPriceController.text.isNotEmpty) {
        try {
          monthlyPrice = int.parse(_monthlyPriceController.text);
        } catch (_) {
          monthlyPrice = 0;
        }
      }
      widget.onPriceChanged!(monthlyPrice);
    }
  }
}


