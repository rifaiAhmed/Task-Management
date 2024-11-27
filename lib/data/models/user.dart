class User {
    final int? id;
    final String? role;
    final String? name;
    final String? email;
    final String? password;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    User({
        this.id,
        this.role,
        this.name,
        this.email,
        this.password,
        this.createdAt,
        this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        role: json["role"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "name": name,
        "email": email,
        "password": password,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
