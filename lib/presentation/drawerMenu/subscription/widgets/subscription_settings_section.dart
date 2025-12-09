import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chuchu/core/config/subscription_config.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

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
  final int? initialMonthlyPrice;
  final Function(int monthlyPrice)? onPriceChanged;

  const SubscriptionSettingsSection({
    super.key,
    this.initialMonthlyPrice,
    this.onPriceChanged,
  });

  static int calculatePriceForDuration(
    int monthlyPrice,
    SubscriptionDuration duration,
  ) {
    return SubscriptionConfig.calculatePriceForDuration(monthlyPrice, duration);
  }

  @override
  State<SubscriptionSettingsSection> createState() =>
      _SubscriptionSettingsSectionState();
}

class _SubscriptionSettingsSectionState
    extends State<SubscriptionSettingsSection> {
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
    if (widget.initialMonthlyPrice != null) {
      _monthlyPriceController.text = widget.initialMonthlyPrice.toString();
    }
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
        // Text(
        //   'What subscribers get:',
        //   style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        // ),
        // const SizedBox(height: 16),
        // _buildBenefitItem(context, 'Exclusive content access'),
        // _buildBenefitItem(context, 'Direct messaging with you'),
        // _buildBenefitItem(context, 'Early access to new posts'),
        // _buildBenefitItem(context, 'Cancel anytime'),
      ],
    );
  }

  Widget _buildPriceControls(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set Monthly Subscription Price',
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withAlpha(50),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _monthlyPriceController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    setState(() {});
                    _notifyPriceChanged();
                  },
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: '1',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    suffixText: 'SATS',
                    suffixStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 20, right: 16, top: 12, bottom: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          'Subscription Options',
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
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
    final discountPercent = SubscriptionConfig.getDiscountPercentage(
      tier.duration,
    );

    String displayPrice = '$calculatedPrice ${SubscriptionConfig.currencyUnit}';
    String durationText;
    if (tier.duration == SubscriptionDuration.year) {
      durationText = 'year';
    } else if (tier.duration == SubscriptionDuration.month) {
      durationText = 'month';
    } else {
      durationText = tier.duration.value;
    }

    final isMonthlyTier = tier.duration == SubscriptionDuration.month;

    return Container(
      height: isMonthlyTier ? 55 : 73,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        // gradient: isMonthlyTier ? getBrandGradientHorizontal() : null,
        color: isMonthlyTier ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isMonthlyTier
                  ? Colors.transparent
                  : Theme.of(context).dividerColor.withAlpha(50),
          width: isMonthlyTier ? 0 : 1,
        ),
        boxShadow: isMonthlyTier
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tier.name,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color:
                        isMonthlyTier
                            ? Colors.white
                            : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                if (discountPercent > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Save $discountPercent%',
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '$displayPrice per $durationText',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color:
                  isMonthlyTier
                      ? Colors.white
                      : Colors.black87,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  int _calculatePrice(SubscriptionDuration duration) {
    final monthlyPrice = _getCurrentMonthlyPrice();
    return SubscriptionSettingsSection.calculatePriceForDuration(
      monthlyPrice,
      duration,
    );
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
