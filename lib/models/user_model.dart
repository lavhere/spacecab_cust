class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final List<String>? savedAddresses;
  final double? rating;
  final String? paymentMethod;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    this.savedAddresses,
    this.rating,
    this.paymentMethod,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      savedAddresses:
          json['savedAddresses'] != null
              ? List<String>.from(json['savedAddresses'])
              : null,
      rating: json['rating'],
      paymentMethod: json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'savedAddresses': savedAddresses,
      'rating': rating,
      'paymentMethod': paymentMethod,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    List<String>? savedAddresses,
    double? rating,
    String? paymentMethod,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      rating: rating ?? this.rating,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
