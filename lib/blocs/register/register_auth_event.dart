import 'package:equatable/equatable.dart';
import 'package:arxivinder/data/model/auth_request.dart';

abstract class RegisterAuthEvent extends Equatable {
  const RegisterAuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterAuthEvent {
  final AuthRequest authRequest;

  const RegisterSubmitted({required this.authRequest});

  @override
  List<Object?> get props => [authRequest];
}

class RegisterReset extends RegisterAuthEvent {
  const RegisterReset();
}