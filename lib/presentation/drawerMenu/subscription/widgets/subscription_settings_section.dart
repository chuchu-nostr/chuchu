import 'package:flutter/material.dart';

/// Subscription tiers model
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

/// Subscription settings section widget
/// onDone will be called after create/update flow succeeds
class SubscriptionSettingsSection extends StatefulWidget {
  /// Required subscription tiers
  final List<SubscriptionTier> subscriptionTiers;
  /// Callback when price changes, receives (isPaid, price, selectedTier)
  final Function(bool isPaid, double price, SubscriptionTier? selectedTier)? onPriceChanged;

  const SubscriptionSettingsSection({
    super.key,
    required this.subscriptionTiers,
    this.onPriceChanged,
  });

  @override
  State<SubscriptionSettingsSection> createState() => _SubscriptionSettingsSectionState();
}

class _SubscriptionSettingsSectionState extends State<SubscriptionSettingsSection> {
  final TextEditingController _priceController = TextEditingController();

  bool _isPaidSubscription = true;
  final Map<String, String> _customPrices = {};

  late final List<SubscriptionTier> _subscriptionTiers;

  SubscriptionTier? _selectedTier;

  @override
  void initState() {
    super.initState();
    _subscriptionTiers = widget.subscriptionTiers;
    _selectedTier = _subscriptionTiers.firstWhere((tier) => tier.isDefault);
    _priceController.text = (_selectedTier!.price / 100).toStringAsFixed(2);
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModeCard(context),
        const SizedBox(height: 24),
        if (_isPaidSubscription) ...[
          _buildPriceControls(context),
        ] else ...[
          _buildFreeInfo(context),
        ],
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

  Widget _buildModeCard(BuildContext context) {
    return Container(
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                _isPaidSubscription
                    ? 'Users pay to access your content'
                    : 'Users can access your content for free',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
              _notifyPriceChanged();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceControls(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set Subscription Price',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (final tier in _subscriptionTiers)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildDurationOption(context, tier),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Custom Price (USD)',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_selectedTier != null) {
                    final suggested = (_selectedTier!.price / 100).toStringAsFixed(2);
                    _priceController.text = suggested;
                    _customPrices[_selectedTier!.name] = suggested;
                  }
                });
              },
              child: Text(
                'Use Suggested: \$${((_selectedTier?.price ?? 999) / 100).toStringAsFixed(2)}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            setState(() {
              if (_selectedTier != null) {
                _customPrices[_selectedTier!.name] = value;
              }
            });
            _notifyPriceChanged();
          },
          decoration: InputDecoration(
            prefixText: '\$ ',
            hintText: '0.00',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationOption(BuildContext context, SubscriptionTier tier) {
    final bool isSelected = _selectedTier?.name == tier.name;
    String displayPrice;
    if (_customPrices.containsKey(tier.name) && _customPrices[tier.name]!.isNotEmpty) {
      String customPrice = _customPrices[tier.name]!.replaceAll(RegExp(r'[^\d.]'), '');
      if (customPrice.isNotEmpty) {
        try {
          double p = double.parse(customPrice);
          displayPrice = '\$${p.toStringAsFixed(2)} per ${tier.duration}';
        } catch (_) {
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
        _notifyPriceChanged();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
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

  Widget _buildFreeInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor.withAlpha(60)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 24),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ],
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

  void _notifyPriceChanged() {
    if (widget.onPriceChanged != null) {
      double price = 0.0;
      if (_isPaidSubscription && _priceController.text.isNotEmpty) {
        final clean = _priceController.text.replaceAll(RegExp(r'[^\d.]'), '');
        if (clean.isNotEmpty) {
          try {
            price = double.parse(clean);
          } catch (_) {
            price = 0.0;
          }
        }
      }
      widget.onPriceChanged!(_isPaidSubscription, price, _selectedTier);
    }
  }
}


