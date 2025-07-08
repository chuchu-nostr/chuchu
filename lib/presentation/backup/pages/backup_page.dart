import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chuchu/core/utils/adapt.dart';
import '../../../core/account/account.dart';
import '../../../core/manager/chuchu_user_info_manager.dart';
import '../../../core/nostr_dart/src/nips/nip_019.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  bool _isPrivateKeyVisible = false;
  
  String get _npubKey {
    final userInfo = ChuChuUserInfoManager.sharedInstance.currentUserInfo;
    if (userInfo == null) return '';
    return Nip19.encodePubkey(userInfo.pubKey);
  }
  
  String get _privateKey {
    return Account.sharedInstance.currentPrivkey;
  }
  
  String get _nsecKey {
    if (_privateKey.isEmpty) return '';
    return Nip19.encodePrivkey(_privateKey);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back Up'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWarningCard(theme),
            SizedBox(height: 24.px),
            _buildKeySection(
              theme: theme,
              title: 'Public Key (npub)',
              subtitle: 'Your public identifier - safe to share',
              value: _npubKey,
              icon: Icons.public,
              iconColor: Colors.green,
            ),
            SizedBox(height: 24.px),
            _buildKeySection(
              theme: theme,
              title: 'Private Key (nsec)',
              subtitle: 'Keep this secret - never share with anyone',
              value: _nsecKey,
              icon: Icons.lock,
              iconColor: Colors.red,
              isPrivate: true,
            ),
            SizedBox(height: 32.px),
            _buildSecurityTips(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningCard(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.px),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 24.px,
          ),
          SizedBox(width: 12.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Security Notice',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.px),
                Text(
                  'Your private key is the only way to access your account. Store it safely and never share it with anyone.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeySection({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color iconColor,
    bool isPrivate = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.px),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.px),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.px),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20.px,
                ),
              ),
              SizedBox(width: 12.px),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isPrivate)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isPrivateKeyVisible = !_isPrivateKeyVisible;
                    });
                  },
                  icon: Icon(
                    _isPrivateKeyVisible ? Icons.visibility_off : Icons.visibility,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.px),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.px),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.px),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isPrivate && !_isPrivateKeyVisible
                        ? '•' * 64
                        : value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 12.px,
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8.px),
                IconButton(
                  onPressed: value.isEmpty ? null : () => _copyToClipboard(value, title),
                  icon: Icon(
                    Icons.copy,
                    size: 18.px,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTips(ThemeData theme) {
    final tips = [
      'Store your private key in a secure password manager',
      'Never share your private key with anyone',
      'Consider writing it down and storing it in a safe place',
      'Your private key cannot be recovered if lost',
      'Only use your private key on trusted devices',
    ];

    return Container(
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12.px),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: theme.colorScheme.primary,
                size: 20.px,
              ),
              SizedBox(width: 8.px),
              Text(
                'Security Tips',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.px),
          ...tips.map((tip) => Padding(
            padding: EdgeInsets.only(bottom: 8.px),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 6.px),
                  width: 4.px,
                  height: 4.px,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.px),
                Expanded(
                  child: Text(
                    tip,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _copyToClipboard(String text, String keyType) {
    if (text.isEmpty) return;
    
    Clipboard.setData(ClipboardData(text: text));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$keyType copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
} 