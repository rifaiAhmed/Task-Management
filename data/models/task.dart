import 'user.dart';

class Task {
    final int? id;
    final int? userId;
    final String? title;
    final String? description;
    final String? status;
    final String? reason;
    final int? revision;
    final DateTime? dueDate;
    final DateTime? submitDate;
    final DateTime? rejectedDate;
    final DateTime? approvedDate;
    final String? attachment;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final User? user;

    Task({
        this.id,
        this.userId,
        this.title,
        this.description,
        this.status,
        this.reason,
        this.revision,
        this.dueDate,
        this.submitDate,
        this.rejectedDate,
        this.approvedDate,
        this.attachment,
        this.createdAt,
        this.updatedAt,
        this.user,
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        userId: json["userId"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        reason: json["reason"],
        revision: json["revision"],
        dueDate: json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
        submitDate: json["submitDate"] == null || json["submitDate"] == '' ? null : DateTime.parse(json["submitDate"]),
        rejectedDate: json["rejectedDate"] == null || json["rejectedDate"] == '' ? null : DateTime.parse(json["rejectedDate"]),
        approvedDate: json["approvedDate"] == null || json["approvedDate"] == '' ? null : DateTime.parse(json["approvedDate"]),
        attachment: json["attachment"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "status": status,
        "reason": reason,
        "revision": revision,
        "dueDate": "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
        "submitDate": "${submitDate!.year.toString().padLeft(4, '0')}-${submitDate!.month.toString().padLeft(2, '0')}-${submitDate!.day.toString().padLeft(2, '0')}",
        "rejectedDate": rejectedDate,
        "approvedDate": "${approvedDate!.year.toString().padLeft(4, '0')}-${approvedDate!.month.toString().padLeft(2, '0')}-${approvedDate!.day.toString().padLeft(2, '0')}",
        "attachment": attachment,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
    };
}