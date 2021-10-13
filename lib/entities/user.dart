import 'dart:convert';

class User {
  final int? id;
  final String? email;
  final String? password;
  final String? registerType;
  final String? iosToken;
  final String? androidToken;
  final String? refreshToken;
  final String? socialKey;
  final String? imageAvatar;
  final int? supplierId;

  User({
    this.id,
    this.email,
    this.password,
    this.registerType,
    this.iosToken,
    this.androidToken,
    this.refreshToken,
    this.socialKey,
    this.imageAvatar,
    this.supplierId,
  });

  User copyWith({
    int? id,
    String? email,
    String? password,
    String? registerType,
    String? iosToken,
    String? androidToken,
    String? refreshToken,
    String? socialKey,
    String? imageAvatar,
    int? supplierId,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      registerType: registerType ?? this.registerType,
      iosToken: iosToken ?? this.iosToken,
      androidToken: androidToken ?? this.androidToken,
      refreshToken: refreshToken ?? this.refreshToken,
      socialKey: socialKey ?? this.socialKey,
      imageAvatar: imageAvatar ?? this.imageAvatar,
      supplierId: supplierId ?? this.supplierId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.email == email &&
        other.password == password &&
        other.registerType == registerType &&
        other.iosToken == iosToken &&
        other.androidToken == androidToken &&
        other.refreshToken == refreshToken &&
        other.socialKey == socialKey &&
        other.imageAvatar == imageAvatar &&
        other.supplierId == supplierId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        password.hashCode ^
        registerType.hashCode ^
        iosToken.hashCode ^
        androidToken.hashCode ^
        refreshToken.hashCode ^
        socialKey.hashCode ^
        imageAvatar.hashCode ^
        supplierId.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'registerType': registerType,
      'iosToken': iosToken,
      'androidToken': androidToken,
      'refreshToken': refreshToken,
      'socialKey': socialKey,
      'imageAvatar': imageAvatar,
      'supplierId': supplierId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      registerType: map['registerType'],
      iosToken: map['iosToken'],
      androidToken: map['androidToken'],
      refreshToken: map['refreshToken'],
      socialKey: map['socialKey'],
      imageAvatar: map['imageAvatar'],
      supplierId: map['supplierId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, email: $email, password: $password, registerType: $registerType, iosToken: $iosToken, androidToken: $androidToken, refreshToken: $refreshToken, socialKey: $socialKey, imageAvatar: $imageAvatar, supplierId: $supplierId)';
  }
}
