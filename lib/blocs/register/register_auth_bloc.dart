import 'package:arxivinder/blocs/register/register_auth_event.dart';
import 'package:arxivinder/blocs/register/state_register_auth.dart';
import 'package:arxivinder/data/services/auth_api.dart';
import 'package:arxivinder/data/services/secure_storage_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterAuthBloc extends Bloc<RegisterAuthEvent, StateRegisterAuth> {
  final AuthApi authApi;

  RegisterAuthBloc({required this.authApi}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<StateRegisterAuth> emit,
  ) async {
    emit(RegisterLoading());

    try {
      final response = await authApi.register(event.authRequest);
      debugPrint('Register response: $response');

      if (response.status == '200') {
        await SecureStorageService.saveUserData(
          response.accessToken,
          response.username,
          response.id.toString(),
        );
        emit(RegisterSuccess(response.message));
      } else {
        emit(RegisterFailure(response.message));
      }
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
