class Notifications {
  final int id;
  final int accountId;
  final String content;
  final String timestamp;
  final bool isRead;

  Notifications({
    required this.id,
    required this.accountId,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });
}