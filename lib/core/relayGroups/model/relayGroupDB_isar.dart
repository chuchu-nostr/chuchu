import 'dart:convert';

import 'package:isar/isar.dart';

import '../../account/model/userDB_isar.dart';
import '../../nostr_dart/src/nips/nip_029.dart';
import '../../utils/log_utils.dart';

part 'relayGroupDB_isar.g.dart';

extension RelayGroupDBISARExtensions on RelayGroupDBISAR {
  RelayGroupDBISAR withGrowableLevels() => this
    ..pinned = pinned?.toList()
    ..members = members?.toList();
}

@collection
class RelayGroupDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String groupId;

  String author; // group creator
  String relay;
  String relayPubkey;
  bool private;
  bool closed;
  int lastUpdatedTime;
  int lastMembersUpdatedTime;
  int lastAdminsUpdatedTime;
  bool mute;
  String? adminsString;
  String name;
  String about;
  String picture;
  List<String>? pinned;
  List<String>? members;
  int level; // group level
  int point; // group point
  int subscriptionAmount; // subscription amount in satoshis
  String groupWalletId; // LNbits wallet ID for group payments

  RelayGroupDBISAR(
      {this.groupId = '',
      this.author = '',
      this.relay = '',
      this.relayPubkey = '',
      this.private = false,
      this.closed = false,
      this.lastUpdatedTime = 0,
      this.lastMembersUpdatedTime = 0,
      this.lastAdminsUpdatedTime = 0,
      this.mute = false,
      this.adminsString,
      this.name = '',
      this.about = '',
      this.picture = '',
      this.pinned,
      this.members,
      this.level = 0,
      this.point = 0,
      this.subscriptionAmount = 0,
      this.groupWalletId = ''});

  static RelayGroupDBISAR fromMap(Map<String, Object?> map) {
    return _groupInfoFromMap(map);
  }

  String get identifier {
    RegExp regExp = RegExp(r'(?<=wss?://)([^/]+)');
    String host = regExp.firstMatch(relay)?.group(0) ?? '';
    return '$host\'$groupId';
  }

  @ignore
  String get shortGroupId {
    String k = groupId;
    if (k.length < 12) return k;
    final String start = k.substring(0, 6);
    final String end = k.substring(k.length - 6);
    return '$start:$end';
  }

  @ignore
  String get showName {
    return name.isEmpty ? shortGroupId : name;
  }

  set admins(List<GroupAdmin> attributes) {
    adminsString = groupAdminsToString(attributes);
  }

  @ignore
  List<GroupAdmin> get admins {
    return adminsString != null ? stringToGroupAdmins(adminsString!) : [];
  }
  
  static List<GroupAdmin> stringToGroupAdmins(String json) {
    if (json.isEmpty || json == 'null') return [];
    try {
      List<dynamic> groupAdminsJson = [];
      groupAdminsJson = jsonDecode(json);
      List<GroupAdmin> admins =
          groupAdminsJson.map((json) => GroupAdmin.fromJson(json)).toList();
      return admins;
    } catch (e) {
      LogUtils.v(() => 'stringToGroupAdmins error: $e');
      return [];
    }
  }

  static String groupAdminsToString(List<GroupAdmin> admins) {
    List<List<dynamic>> adminsString =
    admins.map((admin) => admin.toJson()).toList();
    return jsonEncode(adminsString);
  }
}

RelayGroupDBISAR _groupInfoFromMap(Map<String, dynamic> map) {
  return RelayGroupDBISAR(
    groupId: map['groupId'].toString(),
    author: map['author'].toString(),
    relay: map['relay'].toString(),
    relayPubkey: map['relayPubkey'].toString(),
    private: map['private'],
    closed: map['closed'],
    lastUpdatedTime: map['lastUpdatedTime'],
    mute: map['mute'],
    adminsString: map['adminsString'].toString(),
    name: map['name'].toString(),
    about: map['about'].toString(),
    picture: map['picture'].toString(),
    pinned: UserDBISAR.decodeStringList(map['pinned'].toString()),
    members: UserDBISAR.decodeStringList(map['members'].toString()),
    level: map['level'],
    point: map['point'],
    subscriptionAmount: map['subscriptionAmount'] ?? 0,
    groupWalletId: map['groupWalletId']?.toString() ?? '',
  );
}
