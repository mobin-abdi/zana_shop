import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zana_shop/common/http_client.dart';
import 'package:zana_shop/data/repo/auth_repository.dart';
import 'package:zana_shop/data/source/auth_data_source.dart';
import 'package:zana_shop/theme/light_theme.dart';
import 'package:zana_shop/ui/auth/login/login.dart';
import 'package:zana_shop/ui/auth/signup/signup_bloc/signup_bloc.dart';
import 'package:zana_shop/ui/home/home.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => SignupBloc(
            AuthRepository(dataSource: AuthRemoteDataSource(dio: httpClient)),
          ),
          child: BlocListener<SignupBloc, SignupState>(
            listener: (context, state) {
              if (state is SignupLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("signup was successfully!")),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              } else if (state is SignupError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
                    child: const Text(
                      "Create",
                      style: TextStyle(color: AppColors.textMain, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                    child: const Text(
                      "your account",
                      style: TextStyle(color: AppColors.textMain, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(hintText: "username"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(hintText: "password"),
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                    child: TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(hintText: "confirm password"),
                      obscureText: true,
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 140,
                      // دورِ دکمه رو با BlocBuilder میگیریم تا استیت رو چک کنیم
                      child: BlocBuilder<SignupBloc, SignupState>(
                        builder: (context, state) {
                          return TextButton(
                            onPressed: () {
                              // جلوگیری از کلیکِ مجدد وقتی لودینگ است
                              if (state is SignupLoading) return;

                              if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("passwords do not match"),
                                  ),
                                );
                              } else {
                                context.read<SignupBloc>().add(
                                  SignupStarted(
                                    username: _usernameController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.textMain,
                              foregroundColor: AppColors.background,
                            ),
                            // اینجا شرطِ نمایش لودینگ یا متن
                            child: state is SignupLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: AppColors.background,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "or login with",
                          style: TextStyle(color: AppColors.dotInactive),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.apple),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.g_mobiledata_sharp),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.facebook,
                                color: Color(0xff3266CE),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: const Text("Log In"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
