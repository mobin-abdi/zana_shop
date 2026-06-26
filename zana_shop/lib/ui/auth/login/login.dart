import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zana_shop/common/http_client.dart';
import 'package:zana_shop/common/storage.dart';
import 'package:zana_shop/data/repo/auth_repository.dart';
import 'package:zana_shop/data/source/auth_data_source.dart';
import 'package:zana_shop/theme/light_theme.dart';
import 'package:zana_shop/ui/auth/login/login_bloc/login_bloc.dart';
import 'package:zana_shop/ui/auth/signup/signup.dart';
import 'package:zana_shop/ui/home/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: "mobin");
  final _passwordController = TextEditingController(text: "mobin");

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        AuthRepository(dataSource: AuthRemoteDataSource(dio: httpClient)),
      ),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoaded) {
            TokenManager.instance.saveToken(state.token);
            // اینجا نویگیشن به صفحه اصلی
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (state is LoginError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      const Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Text(
                          "Login into",
                          style: TextStyle(
                            color: AppColors.textMain,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Text(
                          "your account",
                          style: TextStyle(
                            color: AppColors.textMain,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
                        child: TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            hintText: "username",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                        child: TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: "password",
                          ),
                          obscureText: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text("Forgot Password?"),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: 140,
                          child: TextButton(
                            onPressed: () {
                              context.read<LoginBloc>().add(
                                LoginStarted(
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("login was successfully!"),
                                ),
                              );
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.textMain,
                              foregroundColor: AppColors.background,
                            ),
                            child: state is LoginLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "LOG IN",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                            const SizedBox(height: 32),
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
                          const Text("Don’t have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignupScreen(),
                                ),
                              );
                            },
                            child: const Text("Sign Up"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
