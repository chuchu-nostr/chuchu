import 'package:flutter/material.dart';
import '../../../../core/widgets/common_toast.dart';
import '../../drawerMenu/subscription/widgets/subscription_settings_section.dart';

class CreateCreatorPage extends StatefulWidget {
  const CreateCreatorPage({super.key});

  @override
  State<CreateCreatorPage> createState() => CreateCreatorPageState();
}

class CreateCreatorPageState extends State<CreateCreatorPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  bool _isPaidSubscription = true;

  final List<SubscriptionTier> _subscriptionTiers = [
    SubscriptionTier(name: 'Monthly', duration: 'month', price: 999, isDefault: true),
    SubscriptionTier(name: '3 Months', duration: '3 months', price: 2499, isDefault: false),
    SubscriptionTier(name: '6 Months', duration: '6 months', price: 4499, isDefault: false),
    SubscriptionTier(name: '12 Months', duration: 'year', price: 7999, isDefault: false),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Creator'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
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
                    Text(
                      'Circle Name',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your circle name',
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
                    const SizedBox(height: 16),
                    Text(
                      'Introduction',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _aboutController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Circle introduction',
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
                    const SizedBox(height: 24),
                    SubscriptionSettingsSection(
                      subscriptionTiers: _subscriptionTiers,
                      onPriceChanged: (isPaid, price, selectedTier) {
                        _isPaidSubscription = isPaid;

                        if (selectedTier != null && price > 0) {
                          final index = _subscriptionTiers.indexWhere((tier) => tier.name == selectedTier.name);
                          if (index != -1) {
                            _subscriptionTiers[index] = SubscriptionTier(
                              name: selectedTier.name,
                              duration: selectedTier.duration,
                              price: (price * 100).round(),
                              isDefault: selectedTier.isDefault,
                            );
                          }
                        }

                        print('Price changed: isPaid=$isPaid, price=$price, tier=${selectedTier?.name}');
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _onSubmit,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Create',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (_nameController.text.trim().isEmpty) {
      CommonToast.instance.show(context, 'Please enter a circle name');
      return;
    }

    if (_aboutController.text.trim().isEmpty) {
      CommonToast.instance.show(context, 'Please enter a circle introduction');
      return;
    }

    if (_isPaidSubscription) {
      final hasValidPrice = _subscriptionTiers.any((tier) => tier.price > 0);
      if (!hasValidPrice) {
        CommonToast.instance.show(context, 'Please set a valid subscription price');
        return;
      }
    }

    String priceText = _isPaidSubscription ? 'Paid' : 'Free';
    String tierText = _subscriptionTiers.firstWhere((tier) => tier.isDefault).name;

    print('=== Creator Setup Data ===');
    print('Circle Name: ${_nameController.text.trim()}');
    print('Circle About: ${_aboutController.text.trim()}');
    print('Is Paid Subscription: $_isPaidSubscription');
    print('Price Type: $priceText');
    print('Default Tier: $tierText');
    print('All Subscription Tiers:');
    for (int i = 0; i < _subscriptionTiers.length; i++) {
      final tier = _subscriptionTiers[i];
      print('  ${i + 1}. ${tier.name}: \$${(tier.price / 100).toStringAsFixed(2)} per ${tier.duration} (Default: ${tier.isDefault})');
    }
    print('========================');
  }
}
