import 'package:chuchu/core/relayGroups/relayGroup+member.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/common_toast.dart';
import '../../../core/account/account.dart';
import '../../../core/config/config.dart';
import '../../../core/config/subscription_config.dart';
import '../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/wallet/wallet.dart';
import '../../../core/widgets/chuchu_Loading.dart';
import '../../../core/utils/ui_refresh_mixin.dart';
import '../../drawerMenu/subscription/widgets/subscription_settings_section.dart';

class CreateCreatorPage extends StatefulWidget {
  const CreateCreatorPage({super.key});

  @override
  State<CreateCreatorPage> createState() => CreateCreatorPageState();
}

class CreateCreatorPageState extends State<CreateCreatorPage> with ChuChuUIRefreshMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  bool _isPaidSubscription = true;
  int subscriptionPrice = SubscriptionConfig.defaultSubscriptionPrice;

  @override
  Widget buildBody(BuildContext context) {
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
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Poster name',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your Poster name',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
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
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Poster introduction',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 16),
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
                                padding: EdgeInsets.zero,
                                value: _isPaidSubscription,
                                onChanged: (value) {
                                  setState(() {
                                    _isPaidSubscription = value;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (_isPaidSubscription)
                          SubscriptionSettingsSection(
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
            )
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

      ChuChuLoading.show();
      // Get wallet instance
      final wallet = Wallet();

      // Ensure wallet is connected
      if (!wallet.isConnected) {
        await wallet.connectToWallet();
      }

      if (!wallet.isConnected) {
        CommonToast.instance.show(context, 'Wallet not connected. Please try again.');
        ChuChuLoading.dismiss();

        return;
      }

      if(wallet.walletInfo?.walletId == null) {
        CommonToast.instance.show(context, 'Wallet id is not fund.');
        ChuChuLoading.dismiss();

        return;
      }

        // Create new subscription
      RelayGroupDBISAR? relayGroupDB = await RelayGroup.sharedInstance.createGroup(
        Config.sharedInstance.recommendGroupRelays.first,
        Account.sharedInstance.currentPubkey,
        about: _aboutController.text,
        closed: _isPaidSubscription,
        name: _nameController.text.isNotEmpty ? _nameController.text : '',
        subscriptionAmount: _isPaidSubscription ? subscriptionPrice : 0,
        groupWalletId: wallet.walletInfo?.walletId ?? '',
      );
      //
      print('=====>relayGroupDB==$relayGroupDB');
      if(relayGroupDB != null){
        CommonToast.instance.show(context, 'Create Successfully !');
        ChuChuLoading.dismiss();

        Navigator.of(context).pop(true);
      }

    } catch (e) {
      CommonToast.instance.show(context, 'Error creating subscription: ${e.toString()}');
      ChuChuLoading.dismiss();

    }
  }
}
