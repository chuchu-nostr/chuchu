import 'dart:io';
import 'package:chuchu/core/relayGroups/relayGroup+admin.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/nostr_dart/src/ok.dart';
import '../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/services/blossom_uploader.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/widgets/common_toast.dart';
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

  static const double _avatarSize = 120.0;
  static const double _avatarIconSize = 60.0;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  String? _selectedAvatarPath;
  String? _selectedCoverPhotoPath;
  bool _isLoading = false;
  bool _isUploadingAvatar = false;
  bool _isUploadingCoverPhoto = false;

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
    final theme = Theme.of(context);
    
    return AppBar(
      title: Text(
        _pageTitle,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.close, 
          size: 24,
          color: theme.colorScheme.onSurface,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        _isLoading
            ? Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              ),
            )
            : Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  elevation: 0,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
      ],
    );
  }

  // Build main body content
  Widget _buildBody() {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatarSection(),
            const SizedBox(height: 32),
            _buildCoverPhotoSection(),
            const SizedBox(height: 32),
            _buildFormSection(),
            const SizedBox(height: 32),
            _subscriptionWidget(),
          ],
        ),
      ),
    );
  }

  // Build avatar section
  Widget _buildAvatarSection() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _selectAvatar,
            child: Container(
              width: _avatarSize,
              height: _avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Always show local image or default icon
                  _selectedAvatarPath != null
                      ? SizedBox(
                    width: _avatarSize,
                    height: _avatarSize,
                    child:ClipOval(
                      child: Image.file(
                        File(_selectedAvatarPath!),
                        fit: BoxFit.cover,
                      ),
                    ) ,
                  )
                      : Center(
                          child: Icon(
                            Icons.person,
                            size: _avatarIconSize,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                  // Show loading overlay when uploading
                  if (_isUploadingAvatar)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _selectAvatar,
            child: Text(
              _setAvatarText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build cover photo section
  Widget _buildCoverPhotoSection() {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cover Photo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: _setImages,
              child: Text(
                'Edit',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Cover photo display
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Always show local image or placeholder
                _selectedCoverPhotoPath != null
                    ? Image.file(
                        File(_selectedCoverPhotoPath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      )
                    : Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              Theme.of(context).colorScheme.primary.withOpacity(0.05),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_rounded,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Add Cover Photo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to select image',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                // Show loading overlay when uploading
                if (_isUploadingCoverPhoto)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
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
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
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
    final theme = Theme.of(context);
    
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 16,
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  Future<void> _setImages() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _selectedCoverPhotoPath = picked.path;
        });
        // Auto-upload cover photo after showing local image
        await _uploadCoverPhoto();
      }
    } catch (e) {
      FeedWidgetsUtils.showMessage(context,'Failed to pick image: $e', isError: true);
    }
  }

  // Action methods
  Future<void> _selectAvatar() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _selectedAvatarPath = picked.path;
        });
        // Auto-upload avatar after showing local image
        await _uploadAvatar();
      }
    } catch (e) {
      FeedWidgetsUtils.showMessage(context,'Failed to pick avatar: $e', isError: true);
    }
  }

  // Upload avatar image
  Future<void> _uploadAvatar() async {
    if (_selectedAvatarPath == null || _isUploadingAvatar) return;

    setState(() {
      _isUploadingAvatar = true;
    });

    try {
      final imageFile = File(_selectedAvatarPath!);
      final imageUrl = await BolssomUploader.upload(
        'https://blossom.band',
        imageFile.path,
        fileName: imageFile.path.split('/').last,
      );

      if (imageUrl != null && mounted) {
        CommonToast.instance.show(context, 'Avatar uploaded successfully');
      } else {
        throw Exception('Upload returned empty URL');
      }
    } catch (e) {
      if (mounted) {
        CommonToast.instance.show(context, 'Avatar upload failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingAvatar = false;
        });
      }
    }
  }

  // Upload cover photo
  Future<void> _uploadCoverPhoto() async {
    if (_selectedCoverPhotoPath == null || _isUploadingCoverPhoto) return;

    setState(() {
      _isUploadingCoverPhoto = true;
    });

    try {
      final imageFile = File(_selectedCoverPhotoPath!);
      final imageUrl = await BolssomUploader.upload(
        'https://blossom.band',
        imageFile.path,
        fileName: imageFile.path.split('/').last,
      );
      if (imageUrl != null && mounted) {
        CommonToast.instance.show(context, 'Cover photo uploaded successfully');
      } else {
        throw Exception('Upload returned empty URL');
      }
    } catch (e) {
      if (mounted) {
        CommonToast.instance.show(context, 'Cover photo upload failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingCoverPhoto = false;
        });
      }
    }
  }


  Future<void> _saveProfile() async {
    // Validate inputs
    if (_usernameController.text.trim().isEmpty) {
      FeedWidgetsUtils.showMessage(context,'Username cannot be empty', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      RelayGroupDBISAR relayGroup = widget.relayGroup;

      // Prepare updated parameters
      final updatedName = _usernameController.text.trim();
      final updatedAbout = _aboutController.text.trim();
      final updatedPicture = _selectedAvatarPath ?? relayGroup.picture;
      final updatedSubscriptionAmount = subscriptionPrice;

      // Call editMetadata with user input parameters
      OKEvent event = await RelayGroup.sharedInstance.editMetadata(
        relayGroup.groupId,
        updatedName,
        updatedAbout,
        updatedPicture,
        relayGroup.closed,
        relayGroup.private,
        'Profile updated',
        subscriptionAmount: updatedSubscriptionAmount,
        groupWalletId: relayGroup.groupWalletId,
      );

      if (mounted) {
        if (event.status) {
          FeedWidgetsUtils.showMessage(context,'Profile updated successfully');
          Navigator.of(context).pop(true); // Return true to indicate success
        } else {
          FeedWidgetsUtils.showMessage(context,event.message, isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        FeedWidgetsUtils.showMessage(context,'Error updating profile: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
