import 'package:arxivinder/blocs/login/login_auth_event.dart';
import 'package:arxivinder/blocs/login/state_login_auth.dart';
import 'package:arxivinder/data/services/auth_api.dart';
import 'package:arxivinder/data/services/secure_storage_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginAuthBloc extends Bloc<LoginAuthEvent, StateLoginAuth> {
  final AuthApi authApi;

  LoginAuthBloc({required this.authApi}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<StateLoginAuth> emit,
  ) async {
    emit(LoginLoading());

    try {
      final response = await authApi.login(event.authRequest);
      debugPrint('Login response: $response');

      if (response.status == 'success' || response.status == '200') {
        await SecureStorageService.saveUserData(
          response.accessToken,
          response.username,
          response.id.toString(),
        );
        emit(LoginSuccess(response.message));
      } else {
        emit(LoginFailure(response.message));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
