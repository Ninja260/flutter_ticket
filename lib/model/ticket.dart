class Ticket {
  String? id;
  String topic;
  String status;
  String description;
  String issuerId;
  List<String> approverIds;
  String? nextApproverRoleId;
  DateTime createdTime;

  Ticket({
    this.id,
    required this.topic,
    required this.status,
    required this.description,
    required this.issuerId,
    required this.approverIds,
    this.nextApproverRoleId,
    required this.createdTime,
  });

  Ticket.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        topic = json['topic'],
        status = json['status'],
        description = json['description'],
        issuerId = json['issuer_id'],
        approverIds = List<String>.from(json['approver_ids']),
        nextApproverRoleId = json['next_approver_role_id'],
        createdTime = DateTime.parse(json['created_time']);

  Map<String, dynamic> toJson() => {
        '_id': id,
        'topic': topic,
        'status': status,
        'description': description,
        'issuer_id': issuerId,
        'approver_ids': approverIds,
        'next_approver_role_id': nextApproverRoleId,
        'created_time': createdTime.toUtc().toString(),
      };
}
