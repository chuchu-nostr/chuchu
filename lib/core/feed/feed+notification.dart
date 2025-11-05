import 'package:isar/isar.dart';
import '../account/model/zapRecordsDB_isar.dart';
import '../database/db_isar.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'feed+load.dart';
import 'feed.dart';
import 'model/notificationDB_isar.dart';

extension Notification on Feed {
  Future<List<NotificationDBISAR>?> loadNotificationsFromDB(int until, {int limit = 50}) async {
    final isar = DBISAR.sharedInstance.isar;
    List<NotificationDBISAR> notifications = await isar.notificationDBISARs
        .filter()
        .createAtLessThan(until)
        .sortByCreateAtDesc()
        .limit(limit)
        .findAll();
    
    // Only update latestNotificationTime if we have notifications
    if (notifications.isNotEmpty) {
      latestNotificationTime = notifications.first.createAt;
    }
    
    return notifications;
  }

  Future<void> handleZapNotification(ZapRecordsDBISAR zapRecordsDB, Event zapEvent) async {
    // final reactedMessageDB =
    // await Messages.sharedInstance.loadMessageDBFromDB(zapRecordsDB.eventId);
    // if (reactedMessageDB != null) {
    //   await Messages.sharedInstance.handleZapRecordEvent(zapEvent);
    // } else {
    //   await addZapRecordToNote(zapEvent, zapRecordsDB.eventId);
    //   NotificationDBISAR notificationDB =
    //   NotificationDBISAR.notificationDBFromZapRecordsDB(zapRecordsDB, zapEvent.id);
    //   await saveNotificationToDB(notificationDB);
    //   if (notificationDB.author != pubkey && notificationDB.createAt > latestNotificationTime) {
    //     newNotifications.add(notificationDB);
    //     newNotificationCallBack?.call(newNotifications);
    //   } else if (notificationDB.author != pubkey) {
    //     myZapNotificationCallBack?.call([notificationDB]);
    //   }
    // }
  }

  Future<void> saveNotificationToDB(NotificationDBISAR notificationDB,
      {ConflictAlgorithm? conflictAlgorithm}) async {
    await DBISAR.sharedInstance.saveToDB(notificationDB);
  }

  Future<void> deleteAllNotifications() async {
    newNotifications.clear();
    final isar = DBISAR.sharedInstance.isar;
    await isar.writeTxn(() async {
      await isar.notificationDBISARs.clear();
    });
  }
}
