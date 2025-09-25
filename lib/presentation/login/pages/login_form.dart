import 'package:flutter/material.dart';
import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:chuchu/core/account/account.dart';
import 'package:chuchu/core/account/model/userDB_isar.dart';
import 'package:chuchu/core/manager/chuchu_user_info_manager.dart';
import 'package:chuchu/core/utils/feed_widgets_utils.dart';
import '../../home/pages/home_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _privateKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _privateKeyController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _privateKeyController.removeListener(_onTextChanged);
    _privateKeyController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      // Clear error when user starts typing
      if (_hasError && _privateKeyController.text.isNotEmpty) {
        _hasError = false;
        _errorMessage = '';
      }
    });
  }

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Input field
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
              hintText: 'Nsec',
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              filled: false,
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _hasError 
                    ? Theme.of(context).colorScheme.error 
                    : Theme.of(context).colorScheme.outline,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _hasError 
                    ? Theme.of(context).colorScheme.error 
                    : Theme.of(context).colorScheme.outline,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _hasError 
                    ? Theme.of(context).colorScheme.error 
                    : Theme.of(context).colorScheme.primary, 
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: _toggleObscure,
                  ),
                  if (_hasError)
                    Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
          
          // Error message
          if (_hasError) ...[
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _errorMessage,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          ],
          
          SizedBox(height: 24),
        
        // Sign in button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _privateKeyController.text.trim().isNotEmpty ? _nescLogin : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: _privateKeyController.text.trim().isNotEmpty 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.surfaceVariant,
              elevation: 0,
            ),
            child: Text(
              'SIGN IN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    ),);
  }

  void _nescLogin() async {
    final input = _privateKeyController.text.trim();
    
    // Validate input
    if (input.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Please input private key';
      });
      return;
    }
    
    try {
      final privKey = UserDBISAR.decodePrivkey(input);

      if (privKey == null) {
        FeedWidgetsUtils.showMessage(context, 'Invalid private key format. Please check your input and try again.');
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
        FeedWidgetsUtils.showMessage(context, 'Login failed. Please check your credentials and try again.');
        return;
      }

      ChuChuUserInfoManager.sharedInstance.loginSuccess(userDB);
      ChuChuNavigator.pushReplacement(context, const HomePage());
      
    } catch (e) {
      print('Login error: $e');
      FeedWidgetsUtils.showMessage(context, 'Login error occurred. Please check your private key format and try again.');
    }
  }


} 