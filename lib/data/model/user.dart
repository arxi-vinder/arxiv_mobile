import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String password;
  final String role;
  final DateTime createdAt;

  const User(this.id, this.username, this.password, this.role, this.createdAt);

  @override
  List<Object?> get props => [id, username, password, role, createdAt];
}
