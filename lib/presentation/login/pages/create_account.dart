import 'package:chuchu/core/account/account+profile.dart';
import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:flutter/material.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/manager/chuchu_user_info_manager.dart';
import '../../../core/nostr_dart/src/keychain.dart';
import '../../../core/nostr_dart/src/nips/nip_019.dart';
import '../../home/pages/home_page.dart';


class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {

  late Keychain _keychain;
  late String _pub;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(
              'Create account',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      maxLines :2,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondaryContainer,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabled: false,
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        labelText: 'Nostr pubkey',
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        hintText: Nip19.encodePubkey(_pub),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(12), //
                      ),
                    ),
                    FilledButton.tonal(
                      onPressed: _createAccount,
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: Text(
                          'Create',
                          style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ).setPaddingOnly(top: 20.0),
                  ],
                ).setPadding(const EdgeInsets.symmetric(horizontal: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _createAccount() async {
    String pubkey = Account.getPublicKey(_keychain.private);
    await ChuChuUserInfoManager.sharedInstance.initDB(pubkey);

    UserDBISAR userDB = await Account.newAccount(user: _keychain);
    userDB = await Account.sharedInstance.loginWithPriKey(_keychain.private) ?? userDB;

    Account.sharedInstance.updateProfile(userDB);
    await ChuChuUserInfoManager.sharedInstance.loginSuccess(userDB);
    ChuChuNavigator.pushReplacement(context, const HomePage());
  }

  void _init(){
    _keychain = Account.generateNewKeychain();
    _pub = Account.getPublicKey(_keychain.private);
    setState(() {});
  }
}
