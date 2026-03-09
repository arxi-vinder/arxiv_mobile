import 'package:arxivinder/blocs/bottom_nav_bar_bloc.dart';
import 'package:arxivinder/blocs/login/login_auth_bloc.dart';
import 'package:arxivinder/blocs/login/login_auth_event.dart';
import 'package:arxivinder/blocs/login/state_login_auth.dart';
import 'package:arxivinder/data/model/auth_request.dart';
import 'package:arxivinder/data/services/auth_api.dart';
import 'package:arxivinder/ui/pages/auth/register/register_page_screen.dart';
import 'package:arxivinder/ui/pages/root/root_navigation_screen.dart';
import 'package:arxivinder/ui/utils/auth_button.dart';
import 'package:arxivinder/ui/utils/custom_auth_widget.dart';
import 'package:arxivinder/ui/utils/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPageScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginAuthBloc(authApi: AuthApi()),
      child: Scaffold(
        body: CustomAuthWidget(
          title: "Masuk Ke akun anda",
          logoPath: 'assets/images/arxiv_register_logo.png',
          child: BlocConsumer<LoginAuthBloc, StateLoginAuth>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                _usernameController.clear();
                _passwordController.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider(
                          create: (_) => BottomNavBarBloc(),
                          child: const RootNavigationScreen(),
                        ),
                  ),
                  (route) => false,
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.msg)));
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  const Text("Username"),
                  AuthTextField(
                    controller: _usernameController,
                    hintText: "Masukkan username",
                  ),
                  SizedBox(height: 20),
                  const Text(
                    "Kata Sandi",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  AuthTextField(
                    controller: _passwordController,
                    hintText: "Masukkan password",
                    isPassword: true,
                  ),
                  SizedBox(height: 30),
                  if (state is LoginLoading)
                    const CircularProgressIndicator()
                  else
                    AuthButton(
                      caption: "Masuk",
                      action: () {
                        final username = _usernameController.text.trim();
                        final password = _passwordController.text.trim();

                        if (username.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Username dan password harus diisi',
                              ),
                            ),
                          );
                          return;
                        }

                        final authRequest = AuthRequest(
                          username: username,
                          password: password,
                        );

                        context.read<LoginAuthBloc>().add(
                          LoginSubmitted(authRequest: authRequest),
                        );
                      },
                    ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun ?",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        child: Text(
                          "Registrasi",
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap:
                            () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPageScreen(),
                                ),
                              ),
                            },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
