import 'package:arxivinder/blocs/bottom_nav_bar_bloc.dart';
import 'package:arxivinder/blocs/register/register_auth_bloc.dart';
import 'package:arxivinder/blocs/register/register_auth_event.dart';
import 'package:arxivinder/blocs/register/state_register_auth.dart';
import 'package:arxivinder/data/model/auth_request.dart';
import 'package:arxivinder/data/services/auth_api.dart';
import 'package:arxivinder/ui/pages/auth/login/login_page_screen.dart';
import 'package:arxivinder/ui/pages/root/root_navigation_screen.dart';
import 'package:arxivinder/ui/utils/auth_button.dart';
import 'package:arxivinder/ui/utils/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPageScreen extends StatefulWidget {
  const RegisterPageScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPageScreen> {
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
      create: (context) => RegisterAuthBloc(authApi: AuthApi()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: 439,
                    height: 567,
                    decoration: const ShapeDecoration(
                      color: Color.fromRGBO(54, 116, 181, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      const SizedBox(height: 60),
                      Image.asset(
                        'assets/images/arxiv_register_logo.png',
                        width: 124,
                        height: 124,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Registrasi ke\nakun Anddasda',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          letterSpacing: -0.5,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 30),

                      Container(
                        width: 384,
                        height: 478,
                        padding: const EdgeInsets.all(32.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x19000000),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: BlocConsumer<
                          RegisterAuthBloc,
                          StateRegisterAuth
                        >(
                          listener: (context, state) {
                            if (state is RegisterSuccess) {
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

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.msg)),
                              );
                            } else if (state is RegisterFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error)),
                              );

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPageScreen(),
                                ),
                              );
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

                                const SizedBox(height: 20),
                                const Text(
                                  "Kata Sandi",
                                  style: TextStyle(color: Colors.black),
                                ),

                                const SizedBox(height: 20),

                                AuthTextField(
                                  controller: _passwordController,
                                  hintText: "Masukkan password",
                                  isPassword: true,
                                ),

                                const SizedBox(height: 30),
                                if (state is RegisterLoading)
                                  const CircularProgressIndicator()
                                else
                                  AuthButton(
                                    caption: "Registrasi",
                                    action: () {
                                      final username =
                                          _usernameController.text.trim();
                                      final password =
                                          _passwordController.text.trim();

                                      if (username.isEmpty ||
                                          password.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
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

                                      context.read<RegisterAuthBloc>().add(
                                        RegisterSubmitted(
                                          authRequest: authRequest,
                                        ),
                                      );
                                    },
                                  ),

                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Sudah Punya akun ?",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
