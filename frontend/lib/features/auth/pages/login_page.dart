import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/auth/cubit/auth_cubit.dart';
import 'package:taskapp/features/auth/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void loginUser() {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().logIn(email: emailController.text.trim(), password: passwordController.text.trim());
     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError ) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }else if(state is AuthLoggedIn){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>HomePage()), (Route<dynamic> route) => false );
          }
        },
        builder: (context, state) {
          if (state is AuthLoggedIn) {
            return Center( child:  CircularProgressIndicator(),);
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: "Email"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email cannot be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(hintText: "Password"),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Password cannot be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: loginUser,
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: 'Sign Up.',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate back to signup
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
