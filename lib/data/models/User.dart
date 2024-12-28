// class User {
//   final String email;
//   final String name;
//   final String password;
//
//   User({
//     required this.email,
//     required this.name,
//     required this.password,
//   });
//
//   // Create user from Firebase User data
//   factory User.fromMap(Map<String, dynamic> map) {
//     return User(
//       email: map['email'] ?? '',
//       name: map['name'] ?? '',
//       password: map['password'] ?? '',
//     );
//   }
//
//   // Convert user to Map for Firebase
//   Map<String, dynamic> toMap() {
//     return {
//       'email': email,
//       'name': name,
//       'password': password,
//     };
//   }
//
//   // Copy with method for updating user data
//   User copyWith({
//     String? email,
//     String? name,
//     String? password,
//   }) {
//     return User(
//       email: email ?? this.email,
//       name: name ?? this.name,
//       password: password ?? this.password,
//     );
//   }
// }