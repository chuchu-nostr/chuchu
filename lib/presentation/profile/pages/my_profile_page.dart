import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/account/account.dart';
import '../../../core/account/account+profile.dart';
import '../../../core/manager/chuchu_user_info_manager.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/adapt.dart';
import '../../backup/pages/backup_page.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _dnsController = TextEditingController();

  String? _currentPicture;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final userInfo = ChuChuUserInfoManager.sharedInstance.currentUserInfo;
    print('🔍 _loadUserProfile: userInfo = $userInfo');
    print('🔍 _loadUserProfile: name = ${userInfo?.name}, nickName = ${userInfo?.nickName}');
    if (userInfo != null) {
      // Use name field first, fallback to nickName if name is empty
      _nameController.text = (userInfo.name?.isNotEmpty == true) ? userInfo.name! : (userInfo.nickName ?? '');
      _aboutController.text = userInfo.about ?? '';
      _dnsController.text = userInfo.dns ?? '';
      _currentPicture = userInfo.picture;
      print('🔍 _loadUserProfile: loaded name = ${_nameController.text}');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _dnsController.dispose();
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
        actions: [
          IconButton(
            onPressed: _refreshProfile,
            icon: const Icon(Icons.refresh),
          ),
        ],
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
          FeedWidgetsUtils.clipImage(
            borderRadius: 100.px,
            imageSize: 100.px,
            child: ChuChuCachedNetworkImage(
              imageUrl: _currentPicture ?? '',
              fit: BoxFit.cover,
              placeholder: (_, __) => FeedWidgetsUtils.badgePlaceholderImage(),
              errorWidget: (_, __, ___) => FeedWidgetsUtils.badgePlaceholderImage(),
              width: 100.px,
              height: 100.px,
            ),
          ),
          const SizedBox(height: 16),
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
        top: 50,
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
        height: 56,
        padding:  EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 56,
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
                height: 56,
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

  void _refreshProfile() {
    _loadUserProfile();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile refreshed'),
        duration: Duration(seconds: 1),
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


  void _changeProfilePicture() async {
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
        _showErrorSnackBar('User info not found');
        return;
      }

      // TODO: Implement image picker logic here
      // For now, we'll just show a placeholder message
      Navigator.of(context).pop(); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture change feature coming soon!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      _showErrorSnackBar('Failed to change profile picture: $e');
    }
  }

  void _navigateToBackup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BackupPage(),
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
        _showErrorSnackBar('User info not found');
        return;
      }

      // Create updated user info using the new value from dialog
      print('🔍 _updateProfile: fieldName = $fieldName, newValue = "$newValue"');
      if (fieldName == 'Nickname') {
        currentUserInfo.name = newValue.trim();
        print('🔍 _updateProfile: set name to "${currentUserInfo.name}"');
      } else if (fieldName == 'Bio') {
        currentUserInfo.about = newValue.trim();
        print('🔍 _updateProfile: set about to "${currentUserInfo.about}"');
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
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      _showErrorSnackBar('Failed to update $fieldName: $e');
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
}
