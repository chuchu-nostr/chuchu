import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:chuchu/core/relayGroups/relayGroup+note.dart';
import 'package:chuchu/core/utils/adapt.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as Path;
import '../../../core/relayGroups/model/relayGroupDB_isar.dart';
import '../../../core/services/blossom_uploader.dart';

import '../../../core/account/account.dart';
import '../../../core/account/model/userDB_isar.dart';
import '../../../core/feed/feed.dart';
import '../../../core/feed/model/noteDB_isar.dart';
import 'package:nostr_core_dart/src/nips/nip_029.dart';
import 'package:nostr_core_dart/src/ok.dart';
import '../../../core/relayGroups/relayGroup.dart';
import '../../../core/utils/feed_content_analyze_utils.dart';
import '../../../core/utils/feed_utils.dart';
import '../../../core/utils/feed_widgets_utils.dart';
import '../../../core/utils/navigator/navigator.dart';
import '../../../core/widgets/chuchu_Loading.dart';
import '../../../core/widgets/chuchu_cached_network_Image.dart';
import '../../../core/widgets/common_toast.dart';
import '../../../data/models/noted_ui_model.dart';
import '../widgets/feed_widget.dart';
import 'feed_info_page.dart';

class FeedReplyPage extends StatefulWidget {
  final NotedUIModel notedUIModel;
  const FeedReplyPage({super.key, required this.notedUIModel});

  @override
  State<FeedReplyPage> createState() => _FeedReplyPageState();
}

class _FeedReplyPageState extends State<FeedReplyPage> {
  final TextEditingController _textController = TextEditingController();
  // Align with create_feed_page: store selected images as File and support removal
  final List<File> _selectedImages = [];
  double? _singleImageAspectRatio;
  bool _postMomentTag = false;
  // Upload state
  final List<String> _uploadedImageUrls = [];
  final Map<int, bool> _uploadingStatus = {}; // index -> uploading

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.colorScheme.surface,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                elevation: 0,
              ),
              child: const Text(
                'Publish',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _momentItemWidget(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: theme.colorScheme.primary
                                  .withOpacity(0.1),
                              child: Icon(
                                Icons.person,
                                color: theme.colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                maxLines: null,
                                minLines: 3,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Post your reply',
                                  hintStyle: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedImages.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildReplyImageDisplayArea(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            ),
            child: GestureDetector(
              onTap: _pickMedias,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
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
                      'Add medias',
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
        ),
      ),
    );
  }

  Widget _momentItemWidget() {
    String pubKey = widget.notedUIModel.noteDB.author;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        ChuChuNavigator.pushPage(
          context,
          (context) => FeedInfoPage(
            notedUIModel: widget.notedUIModel,
            isShowReply: false,
          ),
        );
      },
      child: IntrinsicHeight(
        child: ValueListenableBuilder<UserDBISAR>(
          valueListenable: Account.sharedInstance.getUserNotifier(pubKey),
          builder: (context, value, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ValueListenableBuilder<UserDBISAR>(
                      valueListenable: Account.sharedInstance.getUserNotifier(
                        pubKey,
                      ),
                      builder: (context, value, child) {
                        return FeedWidgetsUtils.clipImage(
                          borderRadius: 40.px,
                          imageSize: 40.px,
                          child: GestureDetector(
                            onTap: () {},
                            child: ChuChuCachedNetworkImage(
                              imageUrl: value.picture ?? '',
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) =>
                                      FeedWidgetsUtils.badgePlaceholderImage(),
                              errorWidget:
                                  (context, url, error) =>
                                      FeedWidgetsUtils.badgePlaceholderImage(),
                              width: 40.px,
                              height: 40.px,
                            ),
                          ),
                        );
                      },
                    ),

                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4.px),
                        width: 1.0,
                        color: Theme.of(context).dividerColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                ).setPaddingOnly(right: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _momentUserInfoWidget(),
                      FeedWidget(
                        isShowOption: false,
                        feedWidgetLayout: EFeedWidgetLayout.fullScreen,
                        isShowAllContent: false,
                        isShowBottomBorder: false,
                        isShowReply: false,
                        notedUIModel: widget.notedUIModel,
                        isShowUserInfo: false,
                        clickMomentCallback: (
                          NotedUIModel? notedUIModel,
                        ) async {
                          await ChuChuNavigator.pushPage(
                            context,
                            (context) => FeedInfoPage(
                              notedUIModel: widget.notedUIModel,
                              isShowReply: false,
                            ),
                          );
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            'Reply ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.px,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          _momentReplyName(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ).setPaddingOnly(left: 18.0, right: 18.0);
  }

  Widget _momentReplyName(){
    if(widget.notedUIModel.noteDB.root == null || widget.notedUIModel.noteDB.root!.isEmpty){
      return ValueListenableBuilder<RelayGroupDBISAR>(
          valueListenable: RelayGroup.sharedInstance.getRelayGroupNotifier(
            widget.notedUIModel.noteDB.groupId,
          ),
          builder: (context, value, child) {
            return Text(
              '@${value.name}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14.px,
                fontWeight: FontWeight.w500,
              ),
            );
          });
    } else {
      return ValueListenableBuilder<UserDBISAR>(
          valueListenable: Account.sharedInstance.getUserNotifier(
            widget.notedUIModel.noteDB.groupId,
          ),
          builder: (context, value, child) {
            return Text(
              '@${value.name}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14.px,
                fontWeight: FontWeight.w500,
              ),
            );
          }
        );
    }
  }

  Widget _momentUserInfoWidget() {
    if(widget.notedUIModel.noteDB.root == null || widget.notedUIModel.noteDB.root!.isEmpty){
      return ValueListenableBuilder<RelayGroupDBISAR>(
        valueListenable: RelayGroup.sharedInstance.getRelayGroupNotifier(
          widget.notedUIModel.noteDB.groupId,
        ),
        builder: (context, value, child) {
          return  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    value.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14.px,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                widget.notedUIModel.createAtStr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12.px,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        });
    } else {
      return ValueListenableBuilder<UserDBISAR>(
          valueListenable: Account.sharedInstance.getUserNotifier(
            widget.notedUIModel.noteDB.groupId,
          ),
          builder: (context, value, child) {
            return  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      value.name ?? '--',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14.px,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.notedUIModel.createAtStr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12.px,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            );
          });
    }
  }

  void _postMoment() async {
    if (_textController.text.isEmpty && _selectedImages.isEmpty) {
      CommonToast.instance.show(context, 'content_empty_tips');
      return;
    }
    if (_postMomentTag) return;
    _postMomentTag = true;
    await ChuChuLoading.show();
    final inputText = _textController.text;
    // List<String>? getReplyUser = FeedUtils.getMentionReplyUserList(draftCueUserMap, inputText);
    String getMediaStr = await _getUploadMediaContent();
    String content = '$inputText $getMediaStr';
    List<String> hashTags =
        FeedContentAnalyzeUtils(content).getMomentHashTagList;

    OKEvent? event = await _sendNoteReply(
      content: content,
      hashTags: hashTags,
      getReplyUser: null,
    );

    await ChuChuLoading.dismiss();

    if (event != null && event.status) {
      ChuChuNavigator.pop(context);
    }
  }

  Future<OKEvent?> _sendNoteReply({
    required String content,
    required List<String> hashTags,
    List<String>? getReplyUser,
  }) async {
    NoteDBISAR? noteDB = widget.notedUIModel?.noteDB;
    if (noteDB == null) return null;
    String groupId = noteDB.groupId;
    List<String> previous = Nip29.getPrevious([
      [groupId],
    ]);
    return await RelayGroup.sharedInstance.sendGroupNoteReply(
      noteDB.noteId,
      content,
      previous,
      hashTags: hashTags,
      mentions: getReplyUser,
    );
  }

  Future<String> _getUploadMediaContent() async {
    if (_selectedImages.isEmpty) return '';
    await _uploadNewImages();
    return _uploadedImageUrls.isEmpty ? '' : _uploadedImageUrls.join(' ');
  }

  Future<void> _pickMedias() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> files = await picker.pickMultiImage();
      if (files.isEmpty) return;
      if (!mounted) return;
      setState(() {
        _selectedImages.addAll(files.map((f) => File(f.path)));
        for (
          int i = _uploadedImageUrls.length;
          i < _selectedImages.length;
          i++
        ) {
          _uploadingStatus[i] = false;
        }
      });
      // compute aspect ratio for single image
      if (_selectedImages.length == 1) {
        final ratio = await _computeAspectRatio(_selectedImages.first);
        if (mounted)
          setState(() {
            _singleImageAspectRatio = ratio;
          });
      } else {
        if (mounted) {
          setState(() {
            _singleImageAspectRatio = null;
          });
        }
      }
      // auto upload
      _uploadNewImages();
    } catch (e) {
      debugPrint('pick medias error: $e');
    }
  }

  void _removeImage(int index) {
    if (index < 0 || index >= _selectedImages.length) return;
    setState(() {
      _selectedImages.removeAt(index);
      if (index < _uploadedImageUrls.length) {
        _uploadedImageUrls.removeAt(index);
      }
      _uploadingStatus.remove(index);
      final newStatus = <int, bool>{};
      _uploadingStatus.forEach((k, v) {
        newStatus[k > index ? k - 1 : k] = v;
      });
      _uploadingStatus
        ..clear()
        ..addAll(newStatus);
    });
    if (_selectedImages.length == 1) {
      _computeAspectRatio(_selectedImages.first).then((ratio) {
        if (mounted)
          setState(() {
            _singleImageAspectRatio = ratio;
          });
      });
    } else {
      setState(() {
        _singleImageAspectRatio = null;
      });
    }
  }

  // --- UI helpers aligned with create_feed_page ---
  Widget _buildReplyImageDisplayArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child:
            _selectedImages.length == 1
                ? _buildReplySingleImage(
                  _selectedImages[0],
                  key: const ValueKey('reply_single'),
                )
                : _buildReplyImageCarousel(key: const ValueKey('reply_multi')),
      ),
    );
  }

  Widget _buildReplySingleImage(File image, {required Key key}) {
    final aspect = _singleImageAspectRatio ?? (16 / 9);
    return AspectRatio(
      key: key,
      aspectRatio: aspect,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(image, fit: BoxFit.cover),
            ),
          ),
          if ((_uploadingStatus[0] ?? false))
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 8,
            right: 12,
            child: GestureDetector(
              onTap: () => _removeImage(0),
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
          if (_uploadedImageUrls.isNotEmpty)
            Positioned(
              bottom: 8,
              left: 12,
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
      ),
    );
  }

  Widget _buildReplyImageCarousel({required Key key}) {
    return SizedBox(
      key: key,
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          final image = _selectedImages[index];
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
                    Positioned.fill(
                      child: Image.file(image, fit: BoxFit.cover),
                    ),
                    if (_uploadingStatus[index] ?? false)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    if (index < _uploadedImageUrls.length)
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
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

  Future<double> _computeAspectRatio(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final completer = Completer<ui.Image>();
      ui.decodeImageFromList(bytes, (ui.Image img) => completer.complete(img));
      final img = await completer.future;
      return img.width / img.height;
    } catch (_) {
      return 16 / 9; // fallback
    }
  }

  Future<void> _uploadNewImages() async {
    for (int i = _uploadedImageUrls.length; i < _selectedImages.length; i++) {
      if (!mounted) return;
      setState(() {
        _uploadingStatus[i] = true;
      });
      final original = _selectedImages[i];
      final processed = await _removeExifWithCompress(original);
      final filePath = (processed ?? original).path;
      try {
        final url = await BolssomUploader.upload(
          'https://blossom.band',
          filePath,
          fileName: Path.basename(filePath),
        );
        if (url != null && mounted) {
          setState(() {
            _uploadedImageUrls.add(url);
            _uploadingStatus[i] = false;
          });
        } else if (mounted) {
          setState(() {
            _uploadingStatus[i] = false;
          });
        }
      } catch (e) {
        if (mounted)
          setState(() {
            _uploadingStatus[i] = false;
          });
      }
    }
  }

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
}
