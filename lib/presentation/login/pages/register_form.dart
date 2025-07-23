import 'package:flutter/material.dart';
import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:chuchu/core/account/account.dart';
import 'package:chuchu/core/account/account+profile.dart';
import 'package:chuchu/core/account/model/userDB_isar.dart';
import 'package:chuchu/core/manager/chuchu_user_info_manager.dart';
import 'package:chuchu/core/nostr_dart/src/keychain.dart';
import 'package:chuchu/core/nostr_dart/src/nips/nip_019.dart';
import '../../home/pages/home_page.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late Keychain _keychain;
  late String _pub;

  @override
  void initState() {
    super.initState();
    _initRegisterMode();
  }

  void _initRegisterMode() {
    _keychain = Account.generateNewKeychain();
    _pub = Account.getPublicKey(_keychain.private);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Public key display
        TextField(
          maxLines: 2,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            filled: false,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            enabled: false,
            hintStyle: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            labelText: 'Nostr pubkey',
            labelStyle: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            hintText: Nip19.encodePubkey(_pub),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          ),
        ),
        
        SizedBox(height: 24),
        
        // Create button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _createAccount,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 0,
            ),
            child: Text(
              'SIGN UP',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        
        SizedBox(height: 16),
        
        // Terms and Privacy Policy text
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            children: [
              TextSpan(text: 'By signing up you agree to our '),
              TextSpan(
                text: 'Terms of Service',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(text: ', and confirm that you are at least 18 years old.'),
            ],
          ),
        ),
      ],
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
} 