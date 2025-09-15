import 'package:chuchu/core/relayGroups/relayGroup+member.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/common_toast.dart';
import '../../../core/account/account.dart';
import '../../../core/account/relays.dart';
import '../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../core/relayGroups/relayGroup.dart';
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
  double subscriptionPrice = 9.99;

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
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isPaidSubscription)
                      SubscriptionSettingsSection(
                      initialMonthlyPrice: subscriptionPrice,
                      onPriceChanged: (monthlyPrice) {
                        subscriptionPrice = monthlyPrice;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _createSettings,
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

  Future<void> _createSettings() async {
    try {
      if (_isPaidSubscription) {
        String cleanPriceText = subscriptionPrice.toString().replaceAll(RegExp(r'[^\d.]'), '');
        if (cleanPriceText.isEmpty) {
          CommonToast.instance.show(context, 'Please enter a valid price');
          return;
        }
      }
        // Create new subscription
      RelayGroupDBISAR? relayGroupDB = await RelayGroup.sharedInstance.createGroup(
        Relays.sharedInstance.recommendGroupRelays.first,
        Account.sharedInstance.currentPubkey,
        about: _aboutController.text.isNotEmpty ? _isPaidSubscription
            ? 'Premium content subscription - $subscriptionPrice per month'
            : 'Free subscription content' : '',
        closed: _isPaidSubscription,
        name: _nameController.text.isNotEmpty ? _nameController.text : '',
        subscriptionAmount: _isPaidSubscription ? int.tryParse(subscriptionPrice.toString()) ?? 9 : 0,
      );

      if(relayGroupDB != null){
        CommonToast.instance.show(context, 'Create Successfully !');
        Navigator.of(context).pop();
      }

    } catch (e) {
      CommonToast.instance.show(context, 'Error creating subscription: ${e.toString()}');
    }
  }
}
