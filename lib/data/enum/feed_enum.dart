enum EFeedOptionType {
  reply,
  like,
  zaps,
}

extension EFeedOptionTypeEx on EFeedOptionType{
  String get text {
    switch (this) {
      case EFeedOptionType.reply:
        return 'Reply';
      case EFeedOptionType.like:
        return 'Like';
      case EFeedOptionType.zaps:
        return 'Zaps';
    }
  }

  String get getIconName {
    switch (this) {
      case EFeedOptionType.reply:
        return 'comment_feed_icon.png';
      case EFeedOptionType.like:
        return 'like_feed_icon.png';
      case EFeedOptionType.zaps:
        return 'lightning_feed_icon.png';
    }
  }

  int get kind {
    switch (this) {
      case EFeedOptionType.reply:
        return 1;
      case EFeedOptionType.like:
        return 7;
      case EFeedOptionType.zaps:
        return 9735;
    }
  }
}
