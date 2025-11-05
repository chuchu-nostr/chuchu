import 'package:flutter/material.dart';
import 'package:chuchu/core/utils/navigator/navigator.dart';
import 'package:chuchu/core/account/account.dart';
import 'package:chuchu/core/account/account+nip46.dart';
import 'package:chuchu/core/account/model/userDB_isar.dart';
import 'package:chuchu/core/manager/chuchu_user_info_manager.dart';
import '../../home/pages/home_page.dart';

enum LoginMethod {
  privateKey,
  bunker,
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _privateKeyController = TextEditingController();
  final TextEditingController _bunkerUriController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  bool _hasError = false;
  String _errorMessage = '';
  LoginMethod _loginMethod = LoginMethod.privateKey;
  bool _isConnecting = false;
  NIP46ConnectionStatus? _connectionStatus;

  @override
  void initState() {
    super.initState();
    _privateKeyController.addListener(_onTextChanged);
    _bunkerUriController.addListener(_onTextChanged);
    // Set up NIP-46 connection status callback
    Account.sharedInstance.nip46connectionStatusCallback = (status) {
      if (mounted) {
        setState(() {
          _connectionStatus = status;
          if (status == NIP46ConnectionStatus.connected) {
            _isConnecting = false;
          } else if (status == NIP46ConnectionStatus.disconnected) {
            _isConnecting = false;
          } else if (status == NIP46ConnectionStatus.connecting) {
            _isConnecting = true;
          }
        });
      }
    };
  }

  @override
  void dispose() {
    _privateKeyController.removeListener(_onTextChanged);
    _bunkerUriController.removeListener(_onTextChanged);
    _privateKeyController.dispose();
    _bunkerUriController.dispose();
    // Clear callback
    Account.sharedInstance.nip46connectionStatusCallback = null;
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      // Clear error when user starts typing
      String currentText = _loginMethod == LoginMethod.privateKey 
          ? _privateKeyController.text 
          : _bunkerUriController.text;
      if (_hasError && currentText.isNotEmpty) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Login method selector
          Row(
            children: [
              Expanded(
                child: _buildMethodButton(
                  'Private Key',
                  LoginMethod.privateKey,
                  Icons.key,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMethodButton(
                  'Bunker/Signer',
                  LoginMethod.bunker,
                  Icons.vpn_key,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          
          // Input field based on selected method
          if (_loginMethod == LoginMethod.privateKey)
            _buildPrivateKeyInput()
          else
            _buildBunkerUriInput(),
          
          // Connection status indicator
          if (_loginMethod == LoginMethod.bunker && _connectionStatus != null) ...[
            SizedBox(height: 12),
            _buildConnectionStatus(),
          ],
          
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
            onPressed: _canLogin() && !_isConnecting ? _handleLogin : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: _canLogin() && !_isConnecting
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.surfaceVariant,
              elevation: 0,
            ),
            child: _isConnecting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(
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
    ),
    );
  }

  Widget _buildMethodButton(String label, LoginMethod method, IconData icon) {
    final isSelected = _loginMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _loginMethod = method;
          _hasError = false;
          _errorMessage = '';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivateKeyInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                if (_privateKeyController.text.isNotEmpty) ...[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _privateKeyController.clear();
                        _hasError = false;
                        _errorMessage = '';
                      });
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: _toggleObscure,
                  tooltip: _isObscured ? 'Show text' : 'Hide text',
                ),
                if (_hasError) ...[
                  Icon(
                    Icons.error,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
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
      ],
    );
  }

  Widget _buildBunkerUriInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _bunkerUriController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please input bunker URI';
            }
            if (!value.startsWith('bunker://') && !value.startsWith('nostrconnect://')) {
              return 'Invalid URI format. Must start with bunker:// or nostrconnect://';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'bunker://... or nostrconnect://...',
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
                if (_bunkerUriController.text.isNotEmpty) ...[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _bunkerUriController.clear();
                        _hasError = false;
                        _errorMessage = '';
                      });
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                if (_hasError) ...[
                  Icon(
                    Icons.error,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
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
      ],
    );
  }

  Widget _buildConnectionStatus() {
    String statusText = '';
    Color statusColor = Theme.of(context).colorScheme.onSurfaceVariant;
    IconData statusIcon = Icons.info_outline;

    switch (_connectionStatus) {
      case NIP46ConnectionStatus.connecting:
        statusText = 'Connecting...';
        statusColor = Theme.of(context).colorScheme.primary;
        statusIcon = Icons.sync;
        break;
      case NIP46ConnectionStatus.connected:
        statusText = 'Connected';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case NIP46ConnectionStatus.waitingForSigning:
        statusText = 'Waiting for approval...';
        statusColor = Theme.of(context).colorScheme.primary;
        statusIcon = Icons.hourglass_empty;
        break;
      case NIP46ConnectionStatus.approvedSigning:
        statusText = 'Approved';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case NIP46ConnectionStatus.disconnected:
        statusText = 'Disconnected';
        statusColor = Theme.of(context).colorScheme.error;
        statusIcon = Icons.error_outline;
        break;
      default:
        break;
    }

    return Row(
      children: [
        Icon(statusIcon, size: 16, color: statusColor),
        SizedBox(width: 8),
        Text(
          statusText,
          style: TextStyle(
            fontSize: 12,
            color: statusColor,
          ),
        ),
      ],
    );
  }

  bool _canLogin() {
    if (_loginMethod == LoginMethod.privateKey) {
      return _privateKeyController.text.trim().isNotEmpty;
    } else {
      final uri = _bunkerUriController.text.trim();
      return uri.isNotEmpty && 
             (uri.startsWith('bunker://') || uri.startsWith('nostrconnect://'));
    }
  }

  Future<void> _handleLogin() async {
    if (_loginMethod == LoginMethod.privateKey) {
      await _nescLogin();
    } else {
      await _bunkerLogin();
    }
  }

  Future<void> _nescLogin() async {
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
        setState(() {
          _hasError = true;
          _errorMessage = 'Invalid private key format';
        });
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
        setState(() {
          _hasError = true;
          _errorMessage = 'Login failed. Please check your credentials.';
        });
        return;
      }

      ChuChuUserInfoManager.sharedInstance.loginSuccess(userDB);
      ChuChuNavigator.pushReplacement(context, const HomePage());
      
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Login error: ${e.toString()}';
      });
    }
  }

  Future<void> _bunkerLogin() async {
    final uri = _bunkerUriController.text.trim();
    
    // Validate input
    if (uri.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Please input bunker URI';
      });
      return;
    }

    if (!uri.startsWith('bunker://') && !uri.startsWith('nostrconnect://')) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Invalid URI format. Must start with bunker:// or nostrconnect://';
      });
      return;
    }

    try {
      setState(() {
        _isConnecting = true;
        _hasError = false;
        _errorMessage = '';
      });

      // Initialize NIP-46 callbacks
      Account.sharedInstance.initNIP46Callback();

      // Login with bunker URI using extension method
      final userDB = await Account.sharedInstance.loginWithNip46URI(uri);

      if (userDB == null) {
        setState(() {
          _isConnecting = false;
          _hasError = true;
          _errorMessage = 'Failed to connect to remote signer. Please check your URI and try again.';
        });
        return;
      }

      // Initialize user info manager
      final ChuChuUserInfoManager instance = ChuChuUserInfoManager.sharedInstance;
      final currentUserPubKey = instance.currentUserInfo?.pubKey ?? '';
      await instance.initDB(userDB.pubKey);

      var finalUserDB = await instance.handleSwitchFailures(
        userDB,
        currentUserPubKey,
      );

      if (finalUserDB == null) {
        setState(() {
          _isConnecting = false;
          _hasError = true;
          _errorMessage = 'Login failed. Please try again.';
        });
        return;
      }

      ChuChuUserInfoManager.sharedInstance.loginSuccess(finalUserDB);
      ChuChuNavigator.pushReplacement(context, const HomePage());
      
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _hasError = true;
        _errorMessage = 'Connection error: ${e.toString()}';
      });
    }
  }
} 