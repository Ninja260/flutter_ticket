class Log {
  String id;
  DateTime time;
  String text;

  Log({
    required this.id,
    required this.time,
    required this.text,
  });

  Log.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        time = DateTime.parse(json['time']),
        text = json['text'];

  Map<String, dynamic> toJson() => {
        '_id': id,
        'time': time,
        'text': text,
      };
}
