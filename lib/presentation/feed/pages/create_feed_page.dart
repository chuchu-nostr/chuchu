import 'dart:io';
import 'dart:typed_data';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chuchu/core/relayGroups/relayGroup+note.dart';
import 'package:chuchu/core/services/blossom_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import '../../../core/manager/chuchu_feed_manager.dart';
import 'package:nostr_core_dart/src/ok.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/services/file_type.dart';
import '../../../core/services/upload_utils.dart';
import '../../../core/utils/feed_utils.dart';
import '../../../core/widgets/chuchu_Loading.dart';
import '../../../core/widgets/common_toast.dart';
import '../../../data/models/noted_ui_model.dart';


import 'package:path/path.dart' as Path;

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
  
  // Video related state
  final List<File> _selectedVideos = [];
  final List<String> _uploadedVideoUrls = []; // Store uploaded video URLs
  final Map<int, bool> _videoUploadingStatus = {}; // Track upload status for each video
  final Map<int, Uint8List?> _videoThumbnails = {}; // Store video thumbnails
  
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
        // Initialize upload status for new images only (don't override existing upload status)
        for (int i = _uploadedImageUrls.length; i < _selectedImages.length; i++) {
          if (!_uploadingStatus.containsKey(i)) {
            _uploadingStatus[i] = false;
          }
        }
      });
      
      // Auto-upload newly selected images
      _uploadNewImages();
    }
  }

  Future<void> _pickVideos() async {
    final picker = ImagePicker();
    // Note: ImagePicker doesn't support multi-video selection, so we'll allow multiple single selections
    // or use pickVideo() for single selection. For better UX, let's allow selecting multiple videos one by one
    // by calling pickVideo() in a loop until user cancels, or show a dialog
    
    // For now, we'll use pickVideo() for single video selection
    // In a production app, you might want to implement a custom multi-video picker
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      final videoFile = File(picked.path);
      setState(() {
        _selectedVideos.add(videoFile);
        // Initialize upload status for new video
        final index = _selectedVideos.length - 1;
        if (!_videoUploadingStatus.containsKey(index)) {
          _videoUploadingStatus[index] = false;
        }
        // Generate thumbnail
        _generateVideoThumbnail(videoFile, index);
      });
      
      // Auto-upload newly selected video
      _uploadNewVideos();
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

  void _removeVideo(int index) {
    setState(() {
      _selectedVideos.removeAt(index);
      // Remove corresponding upload status, URL and thumbnail
      _videoUploadingStatus.remove(index);
      _videoThumbnails.remove(index);
      if (index < _uploadedVideoUrls.length) {
        _uploadedVideoUrls.removeAt(index);
      }
      // Re-adjust status indices for remaining videos
      final newStatus = <int, bool>{};
      final newThumbnails = <int, Uint8List?>{};
      _videoUploadingStatus.forEach((key, value) {
        if (key > index) {
          newStatus[key - 1] = value;
        } else if (key < index) {
          newStatus[key] = value;
        }
      });
      _videoThumbnails.forEach((key, value) {
        if (key > index) {
          newThumbnails[key - 1] = value;
        } else if (key < index) {
          newThumbnails[key] = value;
        }
      });
      _videoUploadingStatus.clear();
      _videoThumbnails.clear();
      _videoUploadingStatus.addAll(newStatus);
      _videoThumbnails.addAll(newThumbnails);
    });
  }

  /// Generate video thumbnail
  Future<void> _generateVideoThumbnail(File videoFile, int index) async {
    try {
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: videoFile.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 75,
      );
      
      if (thumbnail != null && mounted) {
        setState(() {
          _videoThumbnails[index] = thumbnail;
        });
      }
    } catch (e) {
      // Thumbnail generation failed, continue without thumbnail
    }
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
          
          // Remove EXIF data before upload
          final processedImageFile = await removeExifWithCompress(imageFile);
          if(processedImageFile == null) return;
          final imageUrl = await BolssomUploader.upload(
            'https://blossom.band',
            processedImageFile.path,
            fileName: processedImageFile.path.split('/').last,
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
          if (mounted) {
            setState(() {
              _uploadingStatus[i] = false; // Reset upload status on failure
            });
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

  /// Upload newly selected videos
  Future<void> _uploadNewVideos() async {
    if (_isUploading) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload videos that haven't been uploaded yet
      for (int i = _uploadedVideoUrls.length; i < _selectedVideos.length; i++) {
        if (!mounted) return;

        final file = _selectedVideos[i];

        try {
          // Set upload status to true
          if (mounted) {
            setState(() {
              _videoUploadingStatus[i] = true;
            });
          }

          final currentTime = DateTime.now().microsecondsSinceEpoch.toString();
          String fileName = '$currentTime${Path.basenameWithoutExtension(file.path)}.mp4';
          
          UploadResult result = await UploadUtils.uploadFile(
              context: context,
              fileType: FileType.video,
              file: file,
              filename: fileName,
          );
          
          if (result.isSuccess && result.url.isNotEmpty) {
            if (mounted) {
              setState(() {
                _uploadedVideoUrls.add(result.url);
                _videoUploadingStatus[i] = false; // Upload completed
              });
            }
          } else {
            throw Exception('Upload failed: ${result.errorMsg}');
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _videoUploadingStatus[i] = false; // Reset upload status
            });
            CommonToast.instance.show(context, 'Video ${i + 1} upload failed: $e');
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
    final theme = Theme.of(context);
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel', 
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: _postMoment,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                elevation: 0,
              ),
              child: const Text(
                'Publish', 
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      _buildTextInputArea(),
                      _buildImageDisplayArea(),
                      _buildVideoDisplayArea(),
                      _buildMediaToolbar(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInputArea() {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Icon(
              Icons.person, 
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              style: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: "What's new?",
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaToolbar() {
    // Hide media toolbar if video is selected
    if (_selectedVideos.isNotEmpty) {
      return const SizedBox();
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 40), // Align with text input
          Expanded(
            child: _buildMediaButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaButtons() {
    final theme = Theme.of(context);
    
    // Hide video button if images are selected
    final bool hideVideoButton = _selectedImages.isNotEmpty;
    
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: GestureDetector(
              onTap: _pickImages,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.image,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add images',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!hideVideoButton) const SizedBox(width: 12),
        if (!hideVideoButton)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: GestureDetector(
                onTap: _pickVideos,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.videocam,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Add video',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageDisplayArea() {
    if (_selectedImages.isEmpty) return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
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
        ),
      ),
    );
  }

  Widget _buildVideoDisplayArea() {
    if (_selectedVideos.isEmpty) return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child:
                _selectedVideos.length == 1
                    ? _buildSingleVideo(
                      _selectedVideos[0],
                      0,
                      key: const ValueKey('single_video'),
                    )
                    : _buildVideoCarousel(key: const ValueKey('multi_video')),
          ),
        ),
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
                    SizedBox.expand(
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
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

  Widget _buildSingleVideo(File video, int index, {required Key key}) {
    final isUploaded = index < _uploadedVideoUrls.length;
    final isUploading = _videoUploadingStatus[index] ?? false;
    final thumbnail = _videoThumbnails[index];
    
    return Stack(
      key: key,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              // Show thumbnail if available, otherwise show play icon
              if (thumbnail != null)
                Image.memory(thumbnail, fit: BoxFit.cover, width: double.infinity, height: 200)
              else
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.black12,
                  child: const Center(
                    child: Icon(Icons.play_circle_outline, size: 50, color: Colors.grey),
                  ),
                ),
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
            onTap: () => _removeVideo(index),
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

  Widget _buildVideoCarousel({required Key key}) {
    return SizedBox(
      key: key,
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _selectedVideos.length,
        itemBuilder: (context, index) {
          final isUploaded = index < _uploadedVideoUrls.length;
          final isUploading = _videoUploadingStatus[index] ?? false;
          final thumbnail = _videoThumbnails[index];
          
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
                    // Show thumbnail if available, otherwise show play icon
                    if (thumbnail != null)
                      Image.memory(thumbnail, fit: BoxFit.cover, width: 120, height: 120)
                    else
                      Container(
                        width: 120,
                        height: 120,
                        color: Colors.black12,
                        child: const Center(
                          child: Icon(Icons.play_circle_outline, size: 30, color: Colors.grey),
                        ),
                      ),
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
                  onTap: () => _removeVideo(index),
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
      
      // Wait for all videos to complete upload
      if (_selectedVideos.isNotEmpty && _uploadedVideoUrls.length < _selectedVideos.length) {
        await _uploadNewVideos();
      }
      
      final inputText = _controller.text;
      
      // Build content with image and video URLs
      String mediaContent = '';
      if (_uploadedImageUrls.isNotEmpty) {
        mediaContent += ' ${_uploadedImageUrls.join(' ')}';
      }
      if (_uploadedVideoUrls.isNotEmpty) {
        mediaContent += ' ${_uploadedVideoUrls.join(' ')}';
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
      CommonToast.instance.show(context, 'Post failed: $e');
    } finally {
      ChuChuLoading.dismiss();
      _postFeedTag = false;
    }
  }


  Future<File?> removeExifWithCompress(File file) async {
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
  }

  @override
  didNewNotesCallBackCallBack(List<NoteDBISAR> notes) {
  }
}
