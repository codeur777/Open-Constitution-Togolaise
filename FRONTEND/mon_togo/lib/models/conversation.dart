class Conversation {
  final String id;
  final String title;
  final String lastMessage;

  Conversation({required this.id, required this.title, required this.lastMessage});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      lastMessage: json['lastMessage'],
    );
  }
}
