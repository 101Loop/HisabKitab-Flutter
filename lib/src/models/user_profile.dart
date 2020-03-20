class UserProfile {
  final int id;
  final String name;
  final String email;
  final String mobile;
  final int statusCode;
  final String error;

  UserProfile({this.id, this.name, this.email, this.mobile, this.statusCode, this.error});

  factory UserProfile.fromJson(var json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }

  Map<String, String> toMap() {
    var map = Map<String, String>();

    if (name?.isNotEmpty ?? false) map['name'] = name;
    if (email?.isNotEmpty ?? false) map['email'] = email;
    if (mobile?.isNotEmpty ?? false) map['mobile'] = mobile;

    return map;
  }
}
