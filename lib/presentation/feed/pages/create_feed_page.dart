import 'dart:io';
// import 'package:chuchu/core/feed/feed+send.dart';
import 'package:chuchu/core/nostr_dart/nostr.dart';
import 'package:chuchu/core/relayGroups/relayGroup+note.dart';
import 'package:chuchu/core/services/blossom_uploader.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/feed/feed.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import '../../../core/manager/chuchu_feed_manager.dart';
import '../../../core/nostr_dart/src/ok.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/utils/feed_utils.dart';
import '../../../core/widgets/chuchu_Loading.dart';
import '../../../core/widgets/common_toast.dart';
import '../../../data/models/noted_ui_model.dart';

class CreateFeedPage extends StatefulWidget {
  final NotedUIModel? notedUIModel;
  const CreateFeedPage({super.key,this.notedUIModel});

  @override
  State createState() => _CreateFeedPageState();
}

class _CreateFeedPageState extends State<CreateFeedPage> with ChuChuFeedObserver {
  final TextEditingController _controller = TextEditingController();
  final List<File> _selectedImages = [];
  final List<String> _uploadedImageUrls = []; // Store uploaded image URLs
  final Map<int, bool> _uploadingStatus = {}; // Track upload status for each image
  Map<String,UserDBISAR> draftCueUserMap = {};

  bool _postFeedTag = false;
  bool _isUploading = false; // Track overall upload status

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(picked.map((x) => File(x.path)));
        // Initialize upload status for new images
        for (int i = _uploadedImageUrls.length; i < _selectedImages.length; i++) {
          _uploadingStatus[i] = false;
        }
      });
      
      // Auto-upload newly selected images
      _uploadNewImages();
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      // Remove corresponding upload status and URL
      _uploadingStatus.remove(index);
      if (index < _uploadedImageUrls.length) {
        _uploadedImageUrls.removeAt(index);
      }
      // Re-adjust status indices for remaining images
      final newStatus = <int, bool>{};
      _uploadingStatus.forEach((key, value) {
        if (key > index) {
          newStatus[key - 1] = value;
        } else if (key < index) {
          newStatus[key] = value;
        }
      });
      _uploadingStatus.clear();
      _uploadingStatus.addAll(newStatus);
    });
  }

  /// Upload newly selected images
  Future<void> _uploadNewImages() async {
    if (_isUploading) return;
    
    setState(() {
      _isUploading = true;
    });

    try {
      // Upload images that haven't been uploaded yet
      for (int i = _uploadedImageUrls.length; i < _selectedImages.length; i++) {
        if (!mounted) return;
        
        final imageFile = _selectedImages[i];
        
        try {
          // Set upload status to true
          if (mounted) {
            setState(() {
              _uploadingStatus[i] = true;
            });
          }
          
          final imageUrl = await BolssomUploader.upload(
            'https://blossom.band',
            imageFile.path,
            fileName: imageFile.path.split('/').last,
          );

          if (imageUrl != null) {
            if (mounted) {
              setState(() {
                _uploadedImageUrls.add(imageUrl);
                _uploadingStatus[i] = false; // Upload completed
              });
            }
          } else {
            throw Exception('Upload returned empty URL');
          }
        } catch (e) {
          print('Image $i upload failed: $e');
          if (mounted) {
            CommonToast.instance.show(context, 'Image ${i + 1} upload failed: $e');
          }
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leadingWidth: 75,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        actions: [
          TextButton(
            onPressed: _postMoment,
            child: const Text('Push'),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [_buildTextInputArea(), _buildImageDisplayArea()],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: _pickImages,
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

  Widget _buildTextInputArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "What's new?",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageDisplayArea() {
    if (_selectedImages.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child:
            _selectedImages.length == 1
                ? _buildSingleImage(
                  _selectedImages[0],
                  0,
                  key: const ValueKey('single'),
                )
                : _buildImageCarousel(key: const ValueKey('multi')),
      ),
    );
  }

  Widget _buildSingleImage(File image, int index, {required Key key}) {
    final isUploaded = index < _uploadedImageUrls.length;
    final isUploading = _uploadingStatus[index] ?? false;
    
    return Stack(
      key: key,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Image.file(image),
              if (isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black54,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 24,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.black54,
              child: Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
        if (isUploaded)
          Positioned(
            bottom: 8,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, color: Colors.white, size: 12),
                  SizedBox(width: 3),
                  Text(
                    'Uploaded',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageCarousel({required Key key}) {
    return SizedBox(
      key: key,
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          final image = _selectedImages[index];
          final isUploaded = index < _uploadedImageUrls.length;
          final isUploading = _uploadingStatus[index] ?? false;
          
          return Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    Image.file(image, fit: BoxFit.cover),
                    if (isUploading)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black54,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    if (isUploaded)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check, color: Colors.white, size: 10),
                              SizedBox(width: 2),
                              Text(
                                'Done',
                                style: TextStyle(color: Colors.white, fontSize: 8),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Positioned(
                top: 6,
                right: 14,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.close, color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _postMoment() async {
    if (_postFeedTag) return;
    _postFeedTag = true;
    
    ChuChuLoading.show();
    
    try {
      // Wait for all images to complete upload
      if (_selectedImages.isNotEmpty && _uploadedImageUrls.length < _selectedImages.length) {
        await _uploadNewImages();
      }
      
      final inputText = _controller.text;
      
      // Build content with image URLs
      String mediaContent = '';
      if (_uploadedImageUrls.isNotEmpty) {
        mediaContent = ' ${_uploadedImageUrls.join(' ')}';
      }
      
      String content = '${FeedUtils.changeAtUserToNpub(draftCueUserMap, inputText)}$mediaContent';
      
      if (content.trim().isEmpty) {
        CommonToast.instance.show(context, 'Content empty tips');
        return;
      }
      List<String> previous = Nip29.getPrevious([[Account.sharedInstance.currentPubkey]]);
      OKEvent? eventStatus  = await RelayGroup.sharedInstance.sendGroupNotes(Account.sharedInstance.currentPubkey,content,previous);

      if (eventStatus.status) {
        CommonToast.instance.show(context, 'Sent successfully');
        Navigator.pop(context);
      } else {
        CommonToast.instance.show(context, 'Failed to send');
      }
    } catch (e) {
      print('Post failed: $e');
      CommonToast.instance.show(context, 'Post failed: $e');
    } finally {
      ChuChuLoading.dismiss();
      _postFeedTag = false;
    }
  }

  @override
  didNewNotesCallBackCallBack(List<NoteDBISAR> notes) {
  }
}
