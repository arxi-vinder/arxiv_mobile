import 'package:equatable/equatable.dart';

class StateLoginAuth extends Equatable {
  const StateLoginAuth();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends StateLoginAuth {}

class LoginLoading extends StateLoginAuth {}

class LoginSuccess extends StateLoginAuth {
  final String msg;

  const LoginSuccess(this.msg);

  @override
  List<Object?> get props => [msg];
}

class LoginFailure extends StateLoginAuth {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}
