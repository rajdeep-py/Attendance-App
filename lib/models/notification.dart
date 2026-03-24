class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['notification_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      message: json['subtitle'] ?? json['message'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': id,
      'title': title,
      'subtitle': message,
      'date': date.toIso8601String(),
      'is_read': isRead,
    };
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? date,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
    );
  }
}
