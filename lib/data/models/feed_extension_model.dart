import 'package:chuchu/core/feed/feed+load.dart';
import 'package:flutter/cupertino.dart';

import '../../core/account/model/userDB_isar.dart';
import '../../core/feed/feed.dart';
import '../../core/feed/model/noteDB_isar.dart';
import '../../core/feed/model/notificationDB_isar.dart';
import '../../core/utils/web_url_helper_utils.dart';
import '../enum/feed_enum.dart';
import 'noted_ui_model.dart';

extension ENoteDBEx on NoteDBISAR {

  bool get isReaction => getNoteKind() == EFeedOptionType.like.kind;

  bool get isReply => getNoteKind() == EFeedOptionType.reply.kind;



  isRoot (String? noteId) {
    return getReplyLevel(noteId) == 0;
  }

  isFirstLevelReply (String? noteId) {
    return getReplyLevel(noteId) == 1;
  }

  isSecondLevelReply (String? noteId) {
    return getReplyLevel(noteId) == 2;
  }

  String? get getReplyId {
    String? replyId = reply;
    if(replyId != null && replyId.isNotEmpty) return replyId;
    return root;
  }
}

extension ENotificationDBEX on NotificationDBISAR {
  bool get isLike => kind == EFeedOptionType.like.kind;
}

class CreateFeedDraft{
  List<String>? imageList;
  String? videoPath;
  String? videoImagePath;
  String content;
  EFeedOptionType type;
  Map<String,UserDBISAR>? draftCueUserMap;

  List<UserDBISAR>? selectedContacts;

  CreateFeedDraft({
    required this.type,
    this.imageList,
    this.videoPath,
    this.content = '',
    this.draftCueUserMap,
    this.selectedContacts,
    this.videoImagePath,
  });
}

class ChuChuFeedCacheManager {
  static final ChuChuFeedCacheManager sharedInstance = ChuChuFeedCacheManager._internal();

  ChuChuFeedCacheManager._internal();

  Map<String,Map<String,dynamic>?> naddrAnalysisCache = {};

  Map<String,PreviewData?> urlPreviewDataCache = {};

  CreateFeedDraft? createMomentMediaDraft;
  CreateFeedDraft? createMomentContentDraft;

  CreateFeedDraft? createGroupMomentMediaDraft;
  CreateFeedDraft? createGroupMomentContentDraft;

  static Future<NotedUIModel?> getValueNotifierNoted(
      String noteId,
      {
        bool isUpdateCache = false,
        String? rootRelay,
        String? replyRelay,
        List<String>? setRelay,
        NotedUIModel? notedUIModel,
      }) async {
    Map<String, NoteDBISAR> notesCache = Feed.sharedInstance.notesCache;
    NoteDBISAR? noteNotifier = notesCache[noteId];

    if(!isUpdateCache && noteNotifier != null){
      return NotedUIModel(noteDB: noteNotifier);
    }

    List<String>? relaysList = setRelay;
    if(relaysList == null){
      String? relayStr = (notedUIModel?.noteDB.replyRelay ?? replyRelay) ?? (notedUIModel?.noteDB.rootRelay ?? rootRelay);
      relaysList = relayStr != null ? [relayStr] : null;
    }

    NoteDBISAR? note = await Feed.sharedInstance.loadNoteWithNoteId(noteId, relays: relaysList);
    if(note == null) return null;

    return NotedUIModel(noteDB: note);
  }

  static NotedUIModel? getValueNotifierNoteToCache(String noteId){
    Map<String, NoteDBISAR> notesCache = Feed.sharedInstance.notesCache;
    return notesCache[noteId] == null ? null : NotedUIModel(noteDB: notesCache[noteId]!);
  }
}