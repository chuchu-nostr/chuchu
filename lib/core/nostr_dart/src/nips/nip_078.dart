
import '../event.dart';

/// Arbitrary custom app data
/// https://github.com/nostr-protocol/nips/blob/master/78.md
class Nip78 {
  static String? dTag(List<List<String>> tags) {
    for (var tag in tags) {
      if (tag[0] == "d") return tag[1];
    }
    return null;
  }

  static AppData decodeAppData(Event event) {
    if (event.kind == 30078) {
      return AppData(
          dTag(event.tags), event.pubkey, event.createdAt, event.content);
    }
    throw Exception("${event.kind} is not nip78 compatible");
  }

  /// Encode app data to NIP-78 event
  /// Creates a kind 30078 event with the provided app data
  static Event encodeAppData({
    required String pubkey,
    required String content,
    String? d,
    List<List<String>>? additionalTags,
    int? createdAt,
  }) {
    List<List<String>> tags = [];
    
    // Add d tag if provided
    if (d != null && d.isNotEmpty) {
      tags.add(["d", d]);
    }
    
    // Add additional tags if provided
    if (additionalTags != null) {
      tags.addAll(additionalTags);
    }
    
    // Create unsigned event - signature will be added later
    return Event(
      "", // id - will be calculated when signed
      pubkey,
      createdAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      30078, // kind
      tags,
      content,
      "", // sig - will be added when signed
      verify: false, // Don't verify unsigned event
    );
  }
}

class AppData {
  String? d;
  String pubkey;
  int createAt;
  String content;

  AppData(this.d, this.pubkey, this.createAt, this.content);
}
