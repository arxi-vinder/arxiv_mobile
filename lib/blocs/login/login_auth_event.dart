import 'package:equatable/equatable.dart';
import 'package:arxivinder/data/model/auth_request.dart';

abstract class LoginAuthEvent extends Equatable {
  const LoginAuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginAuthEvent {
  final AuthRequest authRequest;

  const LoginSubmitted({required this.authRequest});

  @override
  List<Object?> get props => [authRequest];
}

class LoginReset extends LoginAuthEvent {
  const LoginReset();
}
