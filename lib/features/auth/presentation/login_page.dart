import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweater/features/feed/presentation/page/feed_page.dart';
import 'package:sweater/features/auth/presentation/register_page.dart';
import 'dart:async';
import 'package:sweater/features/auth/provider/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  final bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '이메일을 입력해주세요';
    }
    final email = value.trim();
    final emailReg = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailReg.hasMatch(email)) {
      return '이메일 형식이 올바르지 않습니다.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    if (value.length < 6) {
      return '비밀번호는 6자 이상이어야 합니다.';
    }
    return null;
  }

  Future<void> logIn() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signIn(_emailCtrl.text.trim(), _passwordCtrl.text);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그인 성공')));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const FeedPage()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = '이메일 형식이 올바르지 않습니다.';
          break;
        case 'user-not-found':
          message = '존재하지 않는 계정입니다.';
          break;
        case 'wrong-password':
          message = '비밀번호가 올바르지 않습니다.';
          break;
        case 'user-disabled':
          message = '이 계정은 비활성화되어 있습니다.';
          break;
        case 'too-many-requests':
          message = '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.';
          break;
        default:
          message = '로그인에 실패했습니다. (${e.code})';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('알 수 없는 오류가 발생했습니다.')));
    }
  }

  void onReset() {
    _formKey.currentState!.reset();
    _emailCtrl.clear();
    _passwordCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailCtrl,
                    validator: _validateEmail,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  Container(height: 20),
                  TextFormField(
                    controller: _passwordCtrl,
                    validator: _validatePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  Container(height: 10),
                  TextButton(
                    onPressed: _isLoading ? null : logIn,
                    child: const Text('Login'),
                  ),
                  Row(
                    children: [
                      Text('Do you wanna register?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text('Click Here'),
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
