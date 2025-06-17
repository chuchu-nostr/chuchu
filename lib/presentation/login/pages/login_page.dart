import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:flutter/material.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/manager/chuchu_user_info_manager.dart';
import 'create_account.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _privateKeyController = TextEditingController();
  bool _isObscured = true;

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 60,
              ),
              Column(
                children: [
                  CommonImage(size: 200, iconName: 'logo.png'),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'chuchu',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 32),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  TextFormField(
                    controller: _privateKeyController,
                    obscureText: _isObscured,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please input private key';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Private Key (hex)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: Icon(
                        Icons.vpn_key,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility_off : Icons.visibility,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onPressed: _toggleObscure,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _nescLogin,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide.none,
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  ChuChuNavigator.pushPage(context, (context) => CreateAccount());
                },
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ).setPadding(EdgeInsets.symmetric(horizontal: 16.0)),
        ),
      ),
    );
  }

  void _nescLogin() async {
    final input = _privateKeyController.text.trim();
    final privKey = UserDBISAR.decodePrivkey(input);

    if (privKey == null) {
      _showSnack('Invalid private key');
      return;
    }

    final pubKey = Account.getPublicKey(privKey);
    final ChuChuUserInfoManager instance = ChuChuUserInfoManager.sharedInstance;
    final currentUserPubKey = instance.currentUserInfo?.pubKey ?? '';

    await instance.initDB(pubKey);

    var userDB = await Account.sharedInstance.loginWithPriKey(privKey);
    userDB = await instance.handleSwitchFailures(
      userDB,
      currentUserPubKey,
    );

    if (userDB == null) {
      _showSnack('Private key validation failed');
      return;
    }

    ChuChuUserInfoManager.sharedInstance.loginSuccess(userDB);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
