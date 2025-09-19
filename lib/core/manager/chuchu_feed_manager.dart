
import '../feed/feed.dart';
import '../feed/model/noteDB_isar.dart';
import '../feed/model/notificationDB_isar.dart';

abstract mixin class ChuChuFeedObserver {
  didNewNotesCallBackCallBack(List<NoteDBISAR> notes) {}

  didGroupsNoteCallBack(NoteDBISAR notes) {}

  didMyZapNotificationCallBack(List<NotificationDBISAR> notifications) {}

  didNewNotificationCallBack(List<NotificationDBISAR> notifications) {}

  void didMoveToTabBarCallBack() {}
  void didMoveToTopCallBack() {}
  void didDeleteMomentsCallBack() {}

}

class ChuChuFeedManager {
  static final ChuChuFeedManager sharedInstance = ChuChuFeedManager._internal();

  ChuChuFeedManager._internal();

  factory ChuChuFeedManager() {
    return sharedInstance;
  }

  List<NoteDBISAR> _notes = [];
  List<NoteDBISAR> _relayGroupNotes = [];
  List<NotificationDBISAR> _notifications = [];

  List<NoteDBISAR> get notes => _notes;
  List<NoteDBISAR> get relayGroupNotes => _relayGroupNotes;
  List<NotificationDBISAR> get notifications => _notifications;

  final List<ChuChuFeedObserver> _observers = <ChuChuFeedObserver>[];

  void addObserver(ChuChuFeedObserver observer) => _observers.add(observer);

  bool removeObserver(ChuChuFeedObserver observer) => _observers.remove(observer);

  final _reactionKind = 7; // reaction kind

  Future<void> init() async {
    initLocalData();
  }

  initLocalData() async {
    addMomentCallBack();
  }

  addMomentCallBack() {}

  void clearNewNotes() {
    Feed.sharedInstance.clearNewNotes();
    _notes.clear();
  }

  void clearNewNotifications() {
    Feed.sharedInstance.clearNewNotifications();
    _notifications.clear();
    newNotificationCallBack(_notifications);
  }

  void newNotesCallBackCallBack(List<NoteDBISAR> notes) {
    notes.removeWhere((element) => element.getNoteKind() == _reactionKind);
    _notes = notes;
    List<NoteDBISAR> personalNoteDBList = [];
    for (NoteDBISAR noteDB in notes) {

      bool isGroupNoted = noteDB.groupId.isNotEmpty;

      if(isGroupNoted) {
        personalNoteDBList.add(noteDB);
      }
    }
    for (ChuChuFeedObserver observer in _observers) {
      observer.didNewNotesCallBackCallBack(personalNoteDBList);
    }
  }

  void newNotificationCallBack(List<NotificationDBISAR> notifications) {
    _notifications = notifications;
    for (ChuChuFeedObserver observer in _observers) {
      observer.didNewNotificationCallBack(notifications);
    }
  }

  void myZapNotificationCallBack(List<NotificationDBISAR> notifications) {
    for (ChuChuFeedObserver observer in _observers) {
      observer.didMyZapNotificationCallBack(notifications);
    }
  }

  void groupsNoteCallBack(NoteDBISAR notes) {
    for (ChuChuFeedObserver observer in _observers) {
      observer.didGroupsNoteCallBack(notes);
    }
  }

  void moveToTabBarCallBack() {
    for (ChuChuFeedObserver observer in _observers) {
      observer.didMoveToTabBarCallBack();
    }
  }

  void moveToTopCallBack() {
    for (ChuChuFeedObserver observer in _observers) {
      observer.didMoveToTopCallBack();
    }
  }

  void deleteMomentsCallBack() {
    for (ChuChuFeedObserver observer in _observers) {
      observer.didDeleteMomentsCallBack();
    }
  }
}


