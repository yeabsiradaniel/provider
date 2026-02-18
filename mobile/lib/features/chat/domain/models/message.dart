class Message {
  final String id;
  final String jobId;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.jobId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      jobId: json['jobId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
