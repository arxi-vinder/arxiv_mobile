import 'package:equatable/equatable.dart';

class StateRegisterAuth extends Equatable {
  const StateRegisterAuth();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends StateRegisterAuth {}

class RegisterLoading extends StateRegisterAuth {}

class RegisterSuccess extends StateRegisterAuth {
  final String msg;

  const RegisterSuccess(this.msg);

  @override
  List<Object?> get props => [msg];
}

class RegisterFailure extends StateRegisterAuth {
  final String error;

  const RegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}
