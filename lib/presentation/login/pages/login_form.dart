import 'package:flutter/material.dart';
import 'package:chuchu/core/utils/navigator/navigator.dart';
// Conditional import for Platform class
import 'dart:io' if (dart.library.html) 'package:chuchu/core/account/platform_stub.dart' show Platform;
import 'package:chuchu/core/account/account.dart';
import 'package:chuchu/core/account/account+nip46.dart';
import 'package:chuchu/core/account/secure_account_storage.dart';
import 'package:chuchu/core/account/model/userDB_isar.dart';
import 'package:chuchu/core/manager/chuchu_user_info_manager.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:nostr_core_dart/src/signer/signer_config.dart';
import 'package:nostr_core_dart/src/channel/core_method_channel.dart';
import '../../../core/widgets/chuchu_Loading.dart';
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
  bool _isConnecting = false;
  NIP46ConnectionStatus? _connectionStatus;

  @override
  void initState() {
    super.initState();
    _privateKeyController.addListener(_onTextChanged);
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
    _privateKeyController.dispose();
    // Clear callback
    Account.sharedInstance.nip46connectionStatusCallback = null;
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      // Clear error when user starts typing
      String currentText = _privateKeyController.text;
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
          // Unified input field for nsec & bunker
          _buildUnifiedInput(),
          
          // Connection status indicator (show when input is bunker URI)
          if (_connectionStatus != null && 
              (_privateKeyController.text.trim().startsWith('bunker://') || 
               _privateKeyController.text.trim().startsWith('nostrconnect://'))) ...[
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
          
          SizedBox(height: 12),
          
          // Sign in with signer button (Android only)
          if (Platform.isAndroid) ...[
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: !_isConnecting ? _handleSignerLogin : null,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                side: BorderSide(
                  color: !_isConnecting
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                ),
                elevation: 0,
              ),
              child: _isConnecting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  : Text(
                      'SIGN IN WITH SIGNER',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: !_isConnecting
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUnifiedInput() {
    final isBunkerUri = _privateKeyController.text.trim().startsWith('bunker://') || 
                        _privateKeyController.text.trim().startsWith('nostrconnect://');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _privateKeyController,
          obscureText: !isBunkerUri && _isObscured,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please input nsec or bunker URI';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'nsec & bunker',
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
                if (!isBunkerUri) ...[
                  IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: _toggleObscure,
                    tooltip: _isObscured ? 'Show text' : 'Hide text',
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
    final text = _privateKeyController.text.trim();
    if (text.isEmpty) return false;
    
    // Check if it's a bunker URI
    if (text.startsWith('bunker://') || text.startsWith('nostrconnect://')) {
      return true;
    }
    
    // Otherwise treat as nsec
    return true;
  }

  Future<void> _handleLogin() async {
    final text = _privateKeyController.text.trim();
    
    // Check if it's a bunker URI
    if (text.startsWith('bunker://') || text.startsWith('nostrconnect://')) {
      await _bunkerLogin(text);
    } else {
      await _nescLogin();
    }
  }

  Future<void> _handleSignerLogin() async {
    // NIP-55 login: Use external signer app to get public key
    if (!Platform.isAndroid) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Signer login is only available on Android';
      });
      return;
    }

    // Show signer selection dialog
    String? selectedSignerKey = await _showSignerSelectionDialog();
    if (selectedSignerKey == null) {
      return; // User cancelled
    }

    try {
      setState(() {
        _isConnecting = true;
        _hasError = false;
        _errorMessage = '';
      });

      // Initialize external signer tool
      await ExternalSignerTool.initialize();
      
      // Set selected signer
      await ExternalSignerTool.setSigner(selectedSignerKey);

      // Get public key from external signer app (this will launch the signer app)
      String? pubkey = await ExternalSignerTool.getPubKey();

      if (pubkey == null || pubkey.isEmpty) {
        setState(() {
          _isConnecting = false;
          _hasError = true;
          _errorMessage = 'Failed to get public key from signer app';
        });
        return;
      }

      // Convert npub to hex if needed
      String hexPubkey = pubkey;
      if (pubkey.startsWith('npub')) {
        String? decoded = UserDBISAR.decodePubkey(pubkey);
        if (decoded == null || decoded.isEmpty) {
          setState(() {
            _isConnecting = false;
            _hasError = true;
            _errorMessage = 'Failed to decode npub format';
          });
          return;
        }
        hexPubkey = decoded;
      }

      // Login with the public key using androidSigner
      final ChuChuUserInfoManager instance = ChuChuUserInfoManager.sharedInstance;
      final currentUserPubKey = instance.currentUserInfo?.pubKey ?? '';
      await instance.initDB(hexPubkey);

      var userDB = await Account.sharedInstance.loginWithPubKey(
        hexPubkey, 
        SignerApplication.androidSigner,
        androidSignerKey: selectedSignerKey,
      );
      userDB = await instance.handleSwitchFailures(
        userDB,
        currentUserPubKey,
      );

      if (userDB == null) {
        setState(() {
          _isConnecting = false;
          _hasError = true;
          _errorMessage = 'Login failed. Please try again.';
        });
        return;
      }

      ChuChuUserInfoManager.sharedInstance.loginSuccess(userDB);
      if (mounted) {
        ChuChuNavigator.pushReplacement(context, const HomePage());
      }
      
    } catch (e) {
      if (mounted) {
        setState(() {
          _isConnecting = false;
          _hasError = true;
          _errorMessage = 'Signer login error: ${e.toString()}';
        });
      }
    }
  }

  Future<String?> _showSignerSelectionDialog() async {
    // Get all available signer configurations
    Map<String, SignerConfig> allConfigs = SignerConfigs.getAllConfigs();
    List<MapEntry<String, SignerConfig>> verifiedSigners = [];
    List<MapEntry<String, SignerConfig>> allSigners = allConfigs.entries.toList();

    // Try to check which signers are installed (but don't rely on it 100%)
    for (var entry in allConfigs.entries) {
      try {
        bool isInstalled = await CoreMethodChannel.isAppInstalled(entry.value.packageName);
        if (isInstalled) {
          verifiedSigners.add(entry);
        }
      } catch (e) {
        // Ignore errors in detection
      }
    }

    // If we found verified signers, use them; otherwise show all signers
    // (Android Intent will handle the actual selection if app is not installed)
    List<MapEntry<String, SignerConfig>> signersToShow = verifiedSigners.isNotEmpty 
        ? verifiedSigners 
        : allSigners;

    // If only one signer to show, use it directly
    if (signersToShow.length == 1) {
      return signersToShow.first.key;
    }

    // Show selection dialog with all signers
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Signer App'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: signersToShow.length,
              itemBuilder: (context, index) {
                final entry = signersToShow[index];
                final config = entry.value;
                return Column(
                  children: [
                    ListTile(
                      title: Text(config.displayName),
                      onTap: () {
                        Navigator.of(context).pop(entry.key);
                      },
                    ),
                    if (index < signersToShow.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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
    ChuChuLoading.show();
    try {
      final privKey = UserDBISAR.decodePrivkey(input);

      if (privKey == null) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Invalid private key format';
        });
        ChuChuLoading.dismiss();
        return;
      }

      final pubKey = Account.getPublicKey(privKey);
      final ChuChuUserInfoManager instance = ChuChuUserInfoManager.sharedInstance;
      final currentUserPubKey = instance.currentUserInfo?.pubKey ?? '';

      await instance.initDB(pubKey);

      var userDB = await Account.sharedInstance.loginWithPriKey(privKey);
      if (userDB != null) {
        await SecureAccountStorage.savePrivateKey(privKey);
      }
      userDB = await instance.handleSwitchFailures(
        userDB,
        currentUserPubKey,
      );

      if (userDB == null) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Login failed. Please check your credentials.';
        });
        ChuChuLoading.dismiss();
        return;
      }

      ChuChuUserInfoManager.sharedInstance.loginSuccess(userDB);
      ChuChuLoading.dismiss();
      ChuChuNavigator.pushReplacement(context, const HomePage());
      
    } catch (e) {
      ChuChuLoading.dismiss();
      setState(() {
        _hasError = true;
        _errorMessage = 'Login error: ${e.toString()}';
      });
    }
  }

  Future<void> _bunkerLogin(String uri) async {
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
      ChuChuLoading.show();
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
        ChuChuLoading.dismiss();
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
        ChuChuLoading.dismiss();
        return;
      }

      ChuChuUserInfoManager.sharedInstance.loginSuccess(finalUserDB);
      ChuChuLoading.dismiss();
      ChuChuNavigator.pushReplacement(context, const HomePage());
      
    } catch (e) {
      ChuChuLoading.dismiss();
      setState(() {
        _isConnecting = false;
        _hasError = true;
        _errorMessage = 'Connection error: ${e.toString()}';
      });
    }
  }
} 