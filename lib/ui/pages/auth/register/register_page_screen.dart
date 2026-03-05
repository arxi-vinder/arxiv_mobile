import 'package:arxivinder/blocs/bottom_nav_bar_bloc.dart';
import 'package:arxivinder/ui/pages/home/home_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Registrasi ke\nakun Anda',
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
                      child: Column(
                        children: [
                          Text("username"),
                          Positioned(child: AuthTextField(hintText: "Halo")),

                          SizedBox(height: 20),
                          const Text(
                            "Kata Sandi",
                            style: TextStyle(color: Colors.black),
                          ),

                          SizedBox(height: 20),

                          AuthTextField(hintText: "Hali", isPassword: true),

                          SizedBox(height: 30),
                          AuthButton(
                            caption: "Registrasi",
                            action:
                                () => {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => BlocProvider(
                                            create:
                                                (context) => BottomNavBarBloc(),
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
                                "Sudah Punya akun ?",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Registrasi",
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
    );
  }
}
