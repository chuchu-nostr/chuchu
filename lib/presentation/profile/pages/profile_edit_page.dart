import 'package:flutter/material.dart';

import '../../../core/account/account.dart';
import '../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../drawerMenu/subscription/widgets/subscription_settings_section.dart';

class ProfileEditPage extends StatefulWidget {
  final RelayGroupDBISAR relayGroup;
  const ProfileEditPage({super.key, required this.relayGroup});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  static const String _pageTitle = 'Edit Profile';
  static const String _usernameLabel = 'Username';
  static const String _aboutLabel = 'About';
  static const String _setAvatarText = 'Set Avatar';
  static const String _profileSavedMessage = 'Profile saved successfully';
  static const String _saveFailedMessage = 'Failed to save profile';

  static const double _avatarSize = 120.0;
  static const double _avatarIconSize = 60.0;
  static const double _borderWidth = 2.0;
  static const EdgeInsets _bodyPadding = EdgeInsets.all(20);
  static const EdgeInsets _textFieldPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  String? _selectedAvatarPath;
  bool _isLoading = false;

  late RelayGroupDBISAR groupInfo;

  int subscriptionPrice = 0;

  @override
  void initState() {
    super.initState();
    getGroupInfo();
  }

  void getGroupInfo() {
    _usernameController.text = widget.relayGroup.name;
    _aboutController.text = widget.relayGroup.about;
    subscriptionPrice = widget.relayGroup.subscriptionAmount;
    setState(() {});
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  // Build app bar with close and save buttons
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(_pageTitle),
      leading: IconButton(
        icon: const Icon(Icons.close, size: 28),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        _isLoading
            ? const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
            : IconButton(
              icon: const Icon(Icons.check, size: 28),
              onPressed: _saveProfile,
            ),
      ],
    );
  }

  // Build main body content
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: _bodyPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatarSection(),
          const SizedBox(height: 40),
          _buildFormSection(),
          const SizedBox(height: 40),
          _subscriptionWidget(),
        ],
      ),
    );
  }

  // Build avatar section
  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _selectAvatar,
            child: Container(
              width: _avatarSize,
              height: _avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surfaceVariant,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: _borderWidth,
                ),
              ),
              child:
                  _selectedAvatarPath != null
                      ? ClipOval(
                        child: Image.asset(
                          _selectedAvatarPath!,
                          fit: BoxFit.cover,
                        ),
                      )
                      : Icon(
                        Icons.person,
                        size: _avatarIconSize,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _setAvatarText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Build form section with username and about fields
  Widget _buildFormSection() {
    return Column(
      children: [
        _buildInputSection(
          label: _usernameLabel,
          controller: _usernameController,
        ),
        const SizedBox(height: 24),
        _buildInputSection(
          label: _aboutLabel,
          controller: _aboutController,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _subscriptionWidget() {
    if (widget.relayGroup.subscriptionAmount > 0) {
      return SubscriptionSettingsSection(
        initialMonthlyPrice: widget.relayGroup.subscriptionAmount,
        onPriceChanged: (monthlyPrice) {
          subscriptionPrice = monthlyPrice;
          if (mounted) {
            setState(() {});
          }
        },
      );
    }
     return Container(
       width: double.infinity,
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         color: Theme.of(context).colorScheme.primaryContainer,
         borderRadius: BorderRadius.circular(12),
         border: Border.all(color: Theme.of(context).dividerColor.withAlpha(60)),
       ),
       child: Row(
         children: [
           Icon(
             Icons.check_circle,
             color: Theme.of(context).colorScheme.primary,
             size: 24,
           ),
           const SizedBox(width: 12),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   'Free Subscription',
                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
                     fontWeight: FontWeight.w600,
                     color: Theme.of(context).colorScheme.onPrimaryContainer,
                   ),
                 ),
                 const SizedBox(height: 4),
                 Text(
                   'Users can access your content without payment',
                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                     color: Theme.of(context).colorScheme.onPrimaryContainer,
                   ),
                 ),
               ],
             ),
           ),
         ],
       ),
     );
  }

  // Build input section with label and text field
  Widget _buildInputSection({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildTextField(controller, maxLines: maxLines),
      ],
    );
  }

  // Build text field widget
  Widget _buildTextField(
    TextEditingController controller, {
    String? hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: _textFieldPadding,
      ),
    );
  }

  // Action methods
  void _selectAvatar() {
    // TODO: Implement avatar selection with image picker
    debugPrint('Select avatar');
  }

  Future<void> _saveProfile() async {
    // Validate inputs
    if (_usernameController.text.trim().isEmpty) {
      _showMessage('Username cannot be empty', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implement actual profile save logic
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        _showMessage(_profileSavedMessage);
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        _showMessage('$_saveFailedMessage: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
