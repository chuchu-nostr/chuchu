enum SubscriptionDuration {
  month('month'),
  threeMonths('3 months'),
  sixMonths('6 months'),
  year('year');

  const SubscriptionDuration(this.value);
  final String value;
}

class SubscriptionConfig {
  static const String currencyUnit = 'Sats';
  static const int defaultSubscriptionPrice = 1000;
  static const Map<SubscriptionDuration, double> discountRates = {
    SubscriptionDuration.month: 1.0,
    SubscriptionDuration.threeMonths: 0.95,
    SubscriptionDuration.sixMonths: 0.90,
    SubscriptionDuration.year: 0.80,
  };
  
  static const Map<SubscriptionDuration, int> durationMultipliers = {
    SubscriptionDuration.month: 1,
    SubscriptionDuration.threeMonths: 3,
    SubscriptionDuration.sixMonths: 6,
    SubscriptionDuration.year: 12,
  };
  
  static int calculatePriceForDuration(int monthlyPrice, SubscriptionDuration duration) {
    final multiplier = durationMultipliers[duration] ?? 1;
    final discountRate = discountRates[duration] ?? 1.0;
    
    return (monthlyPrice * multiplier * discountRate).round();
  }
  
  static int getDiscountPercentage(SubscriptionDuration duration) {
    final discountRate = discountRates[duration] ?? 1.0;
    return ((1.0 - discountRate) * 100).toInt();
  }
  
  static List<SubscriptionDuration> get availableDurations => discountRates.keys.toList();
  
  static bool hasDiscount(SubscriptionDuration duration) {
    return getDiscountPercentage(duration) > 0;
  }
  
  static SubscriptionDuration? fromString(String value) {
    for (final duration in SubscriptionDuration.values) {
      if (duration.value == value) {
        return duration;
      }
    }
    return null;
  }
}
