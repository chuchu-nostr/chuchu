import 'dart:io';
import 'package:chuchu/core/relayGroups/relayGroup+admin.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:nostr_core_dart/src/ok.dart';
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


  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  String? _selectedCoverPhotoPath; // Local file path for display
  String? _uploadedCoverPhotoUrl; // Network URL after upload (used when saving)
  bool _isLoading = false;
  bool _isUploadingCoverPhoto = false;

  late RelayGroupDBISAR groupInfo;

  int subscriptionPrice = 0;
  late ValueNotifier<bool> _hasChangesNotifier;

  @override
  void initState() {
    super.initState();
    _hasChangesNotifier = ValueNotifier<bool>(false);
    getGroupInfo();
    _addListeners();
  }


  void _addListeners() {
    // Listen to text field changes
    _usernameController.addListener(_onFieldChanged);
    _aboutController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    _hasChangesNotifier.value = _hasChanges();
  }


  // Check if relay group metadata has changed
  bool _hasGroupMetadataChanges() {
    final originalName = widget.relayGroup.name;
    final originalAbout = widget.relayGroup.about;
    final originalPicture = widget.relayGroup.picture;
    final originalSubscriptionAmount = widget.relayGroup.subscriptionAmount;
    
    final updatedName = _usernameController.text.trim();
    final updatedAbout = _aboutController.text.trim();
    // If user selected a new image (local path exists), consider it a change
    // Use uploaded URL if available for comparison, otherwise check if local path exists
    final hasPictureChange = _selectedCoverPhotoPath != null && 
        (_uploadedCoverPhotoUrl != originalPicture || _uploadedCoverPhotoUrl == null);
    final updatedSubscriptionAmount = subscriptionPrice;
    
    // Check if any group metadata values have actually changed
    return updatedName != originalName ||
           updatedAbout != originalAbout ||
           hasPictureChange ||
           updatedSubscriptionAmount != originalSubscriptionAmount;
  }

  // Check if any values have changed (for UI state)
  bool _hasChanges() {
    return _hasGroupMetadataChanges();
  }

  void getGroupInfo() {
    _usernameController.text = widget.relayGroup.name;
    _aboutController.text = widget.relayGroup.about;
    subscriptionPrice = widget.relayGroup.subscriptionAmount;
    setState(() {});
  }

  @override
  void dispose() {
    _hasChangesNotifier.dispose();
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
              child: ValueListenableBuilder<bool>(
                valueListenable: _hasChangesNotifier,
                builder: (context, hasChanges, child) {
                  return ElevatedButton(
                    onPressed: hasChanges ? _saveProfile : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasChanges
                          ? theme.colorScheme.primary 
                          : theme.colorScheme.outline.withOpacity(0.3),
                      foregroundColor: hasChanges
                          ? Colors.white 
                          : theme.colorScheme.onSurface.withOpacity(0.5),
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
                  );
                },
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
      body: SafeArea(
        child: GestureDetector(
          onTap:() {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCoverPhotoSection(),
                const SizedBox(height: 32),
                _buildFormSection(),
                const SizedBox(height: 32),
                _subscriptionWidget(),
              ],
            ),
          ),
        ),
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
                // Show local image, existing picture, or placeholder
                _selectedCoverPhotoPath != null
                    ? Image.file(
                        File(_selectedCoverPhotoPath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      )
                    : widget.relayGroup.picture.isNotEmpty
                        ? Image.network(
                            widget.relayGroup.picture,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
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
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No Cover Photo',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Click "Edit" to add',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
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
                                  'No Cover Photo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Click "Edit" to add',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
          _hasChangesNotifier.value = _hasChanges();
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
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          fontSize: 16,
          fontWeight: FontWeight.w600,
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
          _uploadedCoverPhotoUrl = null; // Clear previous uploaded URL when selecting new image
        });
        _hasChangesNotifier.value = _hasChanges();
        // Auto-upload cover photo after showing local image
        await _uploadCoverPhoto();
      }
    } catch (e, stackTrace) {
      debugPrint('Error picking cover photo: $e');
      debugPrint('Stack trace: $stackTrace');
      FeedWidgetsUtils.showMessage(
        context,
        'Unable to open photo picker. Please try again.',
        isError: true,
      );
    }
  }

  // Action methods


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
        // Save uploaded URL separately, keep local path for display
        _uploadedCoverPhotoUrl = imageUrl;
        _hasChangesNotifier.value = _hasChanges();
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
    // Check if there are any changes to save
    if (!_hasChanges()) {
      FeedWidgetsUtils.showMessage(context, 'No changes to save', isError: false);
      return;
    }

    // Validate inputs for group metadata changes
    if (_hasGroupMetadataChanges()) {
      final updatedName = _usernameController.text.trim();
      if (updatedName.isEmpty) {
        FeedWidgetsUtils.showMessage(context, 'Username cannot be empty', isError: true);
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      bool groupMetadataSaved = false;

      // Update relay group metadata if changed
      if (_hasGroupMetadataChanges()) {
        RelayGroupDBISAR relayGroup = widget.relayGroup;

        // Prepare updated parameters
        final updatedName = _usernameController.text.trim();
        final updatedAbout = _aboutController.text.trim();
        // Use uploaded URL if available, otherwise keep original picture
        final updatedPicture = _uploadedCoverPhotoUrl ?? relayGroup.picture;
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

        if (event.status) {
          groupMetadataSaved = true;
        } else {
          if (mounted) {
            FeedWidgetsUtils.showMessage(context, event.message, isError: true);
          }
          return;
        }
      }

      // Show success message based on what was saved
      if (mounted) {
        if (groupMetadataSaved) {
          FeedWidgetsUtils.showMessage(context, 'Profile updated successfully');
        }
        
        _hasChangesNotifier.value = false; // Reset changes flag after successful save
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        FeedWidgetsUtils.showMessage(context, 'Error updating profile: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
