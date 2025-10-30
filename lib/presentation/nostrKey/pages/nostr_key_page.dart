import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chuchu/core/utils/adapt.dart';
import '../../../core/account/account.dart';
import '../../../core/manager/chuchu_user_info_manager.dart';
import '../../../core/nostr_dart/src/nips/nip_019.dart';

class NostrKeyPage extends StatefulWidget {
  const NostrKeyPage({super.key});

  @override
  State<NostrKeyPage> createState() => _NostrKeyPageState();
}

class _NostrKeyPageState extends State<NostrKeyPage> {
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
        title: Text(
          'nostr key',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(theme),
            SizedBox(height: 24.px),
            _buildKeySection(
              theme: theme,
              title: 'Public key (npub)',
              subtitle: 'Public identifier — safe to share',
              value: _npubKey,
              icon: Icons.public,
              iconColor: theme.colorScheme.primary,
            ),
            SizedBox(height: 20.px),
            _buildKeySection(
              theme: theme,
              title: 'Private key (nsec)',
              subtitle: 'Secret — never share with anyone',
              value: _nsecKey,
              icon: Icons.lock,
              iconColor: Colors.red.shade600,
              isPrivate: true,
            ),
            SizedBox(height: 20.px),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Nostr keys',
          style: TextStyle(
            fontSize: 24.px,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.px),
        Text(
          'Back up these keys to restore your account if needed',
          style: TextStyle(
            fontSize: 16.px,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.4,
          ),
        ),
      ],
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
      padding: EdgeInsets.all(18.px),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.px),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
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
                      style: TextStyle(
                        fontSize: 18.px,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 6.px),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 15.px,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.3,
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
              padding: EdgeInsets.all(16.px),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12.px),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isPrivate && !_isPrivateKeyVisible
                        ? '•' * 64
                        : value,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14.px,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                      height: 1.4,
                      letterSpacing: 0.5,
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 12.px),
                GestureDetector(
                  onTap: value.isEmpty ? null : () => _copyToClipboard(value, title),
                  child: Container(
                    padding: EdgeInsets.all(8.px),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.px),
                    ),
                    child: Icon(
                      Icons.copy,
                      size: 16.px,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _copyToClipboard(String text, String keyType) {
    if (text.isEmpty) return;
    
    Clipboard.setData(ClipboardData(text: text));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
} 