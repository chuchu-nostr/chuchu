import 'dart:typed_data';
import 'dart:io' if (dart.library.html) 'package:chuchu/core/account/platform_stub.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as Path;

import '../../../core/account/web_file_registry_stub.dart'
    if (dart.library.html) 'package:chuchu/core/account/web_file_registry.dart'
    as web_file_registry;

import '../../../core/account/account.dart';
import '../../../core/account/account+profile.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/manager/chuchu_user_info_manager.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/services/blossom_uploader.dart';
import '../../../core/widgets/common_toast.dart';
import '../../../core/config/storage_key_tool.dart';
import '../../../core/manager/cache/chuchu_cache_manager.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../login/pages/login_page.dart';
import '../../nostrKey/pages/nostr_key_page.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  String? _selectedAvatarPath; // Local file path for display
  Uint8List? _selectedAvatarBytes; // In-memory image data for web preview
  String? _uploadedAvatarUrl; // Network URL after upload (used when confirming)
  bool _isUploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final userInfo = ChuChuUserInfoManager.sharedInstance.currentUserInfo;
    if (userInfo != null) {
      // Use name field first, fallback to nickName if name is empty
      _nameController.text = (userInfo.name?.isNotEmpty == true) ? userInfo.name! : (userInfo.nickName ?? '');
      _aboutController.text = userInfo.about ?? '';
    }
  }

  @override
  void dispose() {
    if (_selectedAvatarPath != null && _selectedAvatarPath!.startsWith('webfile://')) {
      web_file_registry.unregisterWebFileData(_selectedAvatarPath!);
    }
    _nameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        // actions: [
        //   IconButton(
        //     onPressed: _refreshProfile,
        //     icon: const Icon(Icons.refresh),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildProfileInfoCard(),
              _buildOtherInfoCard(),
              const SizedBox(height: 24),
              _buildLogoutButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _changeProfilePicture,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  width: 2,
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
                  // Show selected local image, existing picture, or placeholder
                  ValueListenableBuilder<UserDBISAR>(
                    valueListenable: Account.sharedInstance.getUserNotifier(
                      Account.sharedInstance.currentPubkey,
                    ),
                    builder: (context, user, child) {
                      // Always prioritize local image if available
                      // This ensures smooth experience without any flash of default image
                      // Local image will be used until user selects a new one or page is refreshed
                      if (_selectedAvatarBytes != null) {
                        return ClipOval(
                          child: Image.memory(
                            _selectedAvatarBytes!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        );
                      } else if (user.picture != null && user.picture!.isNotEmpty) {
                        return FeedWidgetsUtils.clipImage(
                          borderRadius: 100,
                          imageSize: 100,
                          child: ChuChuCachedNetworkImage(
                            imageUrl: user.picture!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
                            errorWidget: (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(),
                            width: 100,
                            height: 100,
                          ),
                        );
                      } else {
                        return FeedWidgetsUtils.badgePlaceholderImage(size:  100);
                      }
                    },
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
          // Show confirm/cancel buttons if avatar is uploaded, otherwise show Edit Photo button
          if (_uploadedAvatarUrl != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                    onTap: _cancelAvatarUpdate,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                    onTap: _confirmAvatarUpdate,
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: _changeProfilePicture,
              child: Text(
                'Edit Photo',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.sentiment_satisfied_alt,
            label: 'Nickname',
            value: _nameController.text.isNotEmpty ? _nameController.text : '',
            onTap: () => _editField('Nickname', _nameController),
            isShowUnderline: true,
          ),
          _buildInfoRow(
            icon: Icons.star,
            label: 'Bio',
            value: _aboutController.text.isNotEmpty ? _aboutController.text : '',
            onTap: () => _editField('Bio', _aboutController),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherInfoCard() {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.vpn_key,
            label: 'Nostr key',
            value: '',
            onTap: () => _navigateToBackup(),
          ),
        ],
      ),
    );
  }




  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    isShowUnderline = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: label == 'Bio' ? null : 56,
        padding:  EdgeInsets.symmetric(horizontal: 16, vertical: label == 'Bio' ? 8 : 0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: label == 'Bio' ? null : 56,
                decoration: isShowUnderline ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Theme.of(context).dividerColor.withOpacity(0.3),
                    ),
                  ),
                ) : null ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          if (value.isNotEmpty)
                            Text(
                              value,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editField(String fieldName, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController editController = TextEditingController(text: controller.text);
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.grey[50]!],
                ),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with icon
                    Row(
                      children: [
                        Icon(
                          fieldName == 'Nickname' ? Icons.sentiment_satisfied_alt : Icons.star,
                          size: 24,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        // Title
                        Text(
                          'Edit $fieldName',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Input field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: editController,
                        autofocus: false,
                        maxLines: fieldName == 'Bio' ? 4 : 1,
                        minLines: fieldName == 'Bio' ? 3 : 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                        decoration: InputDecoration(
                          labelText: 'Enter $fieldName',
                          hintText: fieldName == 'Nickname' ? 'Your display name' : 'Tell us about yourself',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Update your $fieldName to personalize your profile',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                await _updateProfile(fieldName, editController.text);
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_rounded, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Future<void> _changeProfilePicture() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        if (kIsWeb) {
          final virtualPath = web_file_registry.createVirtualFilePath(picked.name);
          web_file_registry.registerWebFileData(virtualPath, bytes);
          // Clean up previous virtual file if exists
          if (_selectedAvatarPath != null && _selectedAvatarPath!.startsWith('webfile://')) {
            web_file_registry.unregisterWebFileData(_selectedAvatarPath!);
          }
          setState(() {
            _selectedAvatarPath = virtualPath;
            _selectedAvatarBytes = bytes;
            _uploadedAvatarUrl = null; // Clear previous uploaded URL when selecting new image
          });
        } else {
          setState(() {
            _selectedAvatarPath = picked.path;
            _selectedAvatarBytes = bytes;
            _uploadedAvatarUrl = null; // Clear previous uploaded URL when selecting new image
          });
        }
        
        // Auto-upload avatar after showing local image
        await _uploadAvatar();
      }
    } catch (e, stackTrace) {
      // Print detailed error for debugging
      debugPrint('Error picking avatar: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Show user-friendly error message
      _showErrorSnackBar('Unable to select photo. Please try again.');
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
      // Remove EXIF (GPS) by re-encoding image before upload
      final processed = await _removeExifWithCompress(imageFile);
      final uploadFilePath = (processed ?? imageFile).path;
      final imageUrl = await BolssomUploader.upload(
        'https://blossom.band',
        uploadFilePath,
        fileName: uploadFilePath.split('/').last,
      );

      if (imageUrl != null && mounted) {
        // Save uploaded URL, but don't update profile yet - wait for user confirmation
        setState(() {
          _uploadedAvatarUrl = imageUrl;
        });
        CommonToast.instance.show(context, 'Avatar uploaded successfully. Please confirm to update.');
      } else {
        throw Exception('Upload returned empty URL');
      }
    } catch (e, stackTrace) {
      // Print detailed error for debugging
      debugPrint('Error uploading avatar: $e');
      debugPrint('Stack trace: $stackTrace');
      
      if (mounted) {
        // Show user-friendly error message
        _showErrorSnackBar('Failed to upload photo. Please check your network connection and try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingAvatar = false;
        });
      }
    }
  }

  // Remove EXIF metadata (including GPS) by re-compressing the image
  Future<File?> _removeExifWithCompress(File file) async {
    try {
      final targetPath = Path.join(
        Path.dirname(file.path),
        '${Path.basenameWithoutExtension(file.path)}_noexif.jpg',
      );
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 95,
      );
      return result != null ? File(result.path) : null;
    } catch (_) {
      return null;
    }
  }

  // Confirm avatar update - actually update the profile
  Future<void> _confirmAvatarUpdate() async {
    if (_uploadedAvatarUrl == null) return;
    
    try {
      final uploadedUrl = _uploadedAvatarUrl!;
      await _updateUserAvatar(uploadedUrl);
      
      // Clear uploaded URL to hide confirm/cancel buttons
      // But keep local image bytes to continue showing local image
      // This prevents any flash of default image or network loading
      if (mounted) {
        setState(() {
          _uploadedAvatarUrl = null;
          // Keep _selectedAvatarBytes and _selectedAvatarPath to continue using local image
        });
      }
      
      CommonToast.instance.show(context, 'Avatar updated successfully');
    } catch (e, stackTrace) {
      // Print detailed error for debugging
      debugPrint('Error confirming avatar update: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Show user-friendly error message
      if (mounted) {
        _showErrorSnackBar('Failed to update avatar. Please try again.');
      }
    }
  }

  // Cancel avatar update - clear uploaded URL and selected image
  void _cancelAvatarUpdate() {
    if (_selectedAvatarPath != null && _selectedAvatarPath!.startsWith('webfile://')) {
      web_file_registry.unregisterWebFileData(_selectedAvatarPath!);
    }
    setState(() {
      _selectedAvatarPath = null;
      _selectedAvatarBytes = null;
      _uploadedAvatarUrl = null;
    });
  }

  // Update user avatar in profile
  Future<void> _updateUserAvatar(String imageUrl) async {
    try {
      // Get current user info
      final currentUserInfo = ChuChuUserInfoManager.sharedInstance.currentUserInfo;
      if (currentUserInfo == null) {
        debugPrint('Error: User info not found when updating avatar');
        _showErrorSnackBar('Unable to update avatar. Please try again later.');
        return;
      }

      // Update picture field
      currentUserInfo.picture = imageUrl;
      
      // Update profile through Account
      final result = await Account.sharedInstance.updateProfile(currentUserInfo);
      
      if (result != null) {
        // Update ChuChuUserInfoManager's currentUserInfo
        ChuChuUserInfoManager.sharedInstance.currentUserInfo = result;
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e, stackTrace) {
      // Print detailed error for debugging
      debugPrint('Error updating user avatar: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Show user-friendly error message
      _showErrorSnackBar('Failed to update avatar. Please check your connection and try again.');
      rethrow; // Re-throw to let caller handle if needed
    }
  }

  void _navigateToBackup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NostrKeyPage(),
      ),
    );
  }

  Future<void> _updateProfile(String fieldName, String newValue) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Get current user info
      final currentUserInfo = ChuChuUserInfoManager.sharedInstance.currentUserInfo;
      if (currentUserInfo == null) {
        Navigator.of(context).pop(); // Close loading dialog
        debugPrint('Error: User info not found when updating $fieldName');
        _showErrorSnackBar('Unable to update $fieldName. Please try again later.');
        return;
      }

      // Create updated user info using the new value from dialog
      if (fieldName == 'Nickname') {
        currentUserInfo.name = newValue.trim();
      } else if (fieldName == 'Bio') {
        currentUserInfo.about = newValue.trim();
      }

      // Update profile through Account
      final result = await Account.sharedInstance.updateProfile(currentUserInfo);

      // Check if the update was successful
      if (result == null) {
        throw Exception('Failed to update profile - no data returned');
      }
      
      // Update ChuChuUserInfoManager's currentUserInfo
      ChuChuUserInfoManager.sharedInstance.currentUserInfo = result;

      // Update local controllers
      if (fieldName == 'Nickname') {
        _nameController.text = newValue;
      } else if (fieldName == 'Bio') {
        _aboutController.text = newValue;
      }

      Navigator.of(context).pop(); // Close loading dialog
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$fieldName updated successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Refresh UI
      setState(() {});
    } catch (e, stackTrace) {
      Navigator.of(context).pop(); // Close loading dialog
      
      // Print detailed error for debugging
      debugPrint('Error updating $fieldName: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Show user-friendly error message
      _showErrorSnackBar('Failed to update $fieldName. Please check your connection and try again.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ElevatedButton.icon(
        onPressed: () => _handleLogout(),
        icon: Icon(Icons.logout, size: 20, color: Colors.red[600]),
        label: Text(
          'Log Out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red[600],
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red[600],
          elevation: 0,
          side: BorderSide(color: Colors.red[600]!, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout,
              color: Colors.red[600],
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('Log Out'),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      // Clear saved user pubkey
      await ChuChuCacheManager.defaultOXCacheManager.saveForeverData(
        StorageKeyTool.CHUCHU_USER_PUBKEY,
        '',
      );

      // Logout
      await ChuChuUserInfoManager.sharedInstance.logout(needObserver: true);

      // Navigate to login page
      if (mounted) {
        ChuChuNavigator.pushReplacement(
          context,
          const LoginPage(),
        );
      }
    }
  }
}
