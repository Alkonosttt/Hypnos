import 'package:flutter/material.dart';

class LoginProfileScreen extends StatefulWidget {
  const LoginProfileScreen({super.key});

  @override
  State<LoginProfileScreen> createState() => _LoginProfileScreenState();
}

class _LoginProfileScreenState extends State<LoginProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Login and Profile screen'));
  }
}
