class MessageModel {
  late String text;
  late String senderId;
  late String receiverId;
  late String dateTime;

  MessageModel({
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.dateTime,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
    };
  }
}
