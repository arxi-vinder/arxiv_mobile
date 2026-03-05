import 'package:arxivinder/blocs/bottom_nav_bar_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomAuthWidget(
        title: "Masuk Ke akun anda",
        logoPath: 'assets/images/arxiv_register_logo.png',
        child: Column(
          children: [
            Text("username"),

            Positioned(child: AuthTextField(hintText: "Halo")),

            SizedBox(height: 20),

            const Text("Kata Sandi", style: TextStyle(color: Colors.black)),

            SizedBox(height: 20),

            AuthTextField(hintText: "Kata sandi anda", isPassword: true),

            SizedBox(height: 30),

            AuthButton(
              caption: "Masuk",
              action:
                  () => {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => BlocProvider(
                              create: (context) => BottomNavBarBloc(),
                              child: const RootNavigationScreen(),
                            ),
                      ),
                      (route) => false,
                    ),
                  },
            ),

            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Belum punya akun ?",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
        ),
      ),
    );
  }
}
