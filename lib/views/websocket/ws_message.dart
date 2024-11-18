class WSMessage {
  final String username;
  final String message;
  int? timestamp;

  WSMessage(this.username, this.message, this.timestamp);

  factory WSMessage.fromJson(Map<String, dynamic> json) {
    return WSMessage(json["username"], json["message"], json["timestamp"]);
  }

  @override
  String toString() {
    return '{ "username": "$username", "message": "$message", "timestamp": "$timestamp"}';
  }
}