import 'package:flutter/material.dart';

class CustomAuthWidget extends StatelessWidget {
  final String title;
  final String logoPath;
  final Widget child;

  const CustomAuthWidget({
    super.key,
    required this.title,
    required this.logoPath,
    required this.child,
  });

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
                  width: double.infinity,
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
                      logoPath,
                      width: 124,
                      height: 124,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                        letterSpacing: -0.5,
                        fontFamily: 'Roboto',
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      width: 384,
                      padding: const EdgeInsets.all(32),
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
                      child: child,
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
