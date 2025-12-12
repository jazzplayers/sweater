import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweater/features/auth/presentation/login_page.dart';
import 'dart:async';
import 'package:sweater/features/auth/provider/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _displayNameCtrl.dispose();
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

  String? _validatedisplayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '닉네임을 입력해주세요';
    }
    return null;
  }

  Future<void> register() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signUp(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        displayName: _displayNameCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('회원 가입 완료!')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = '이미 사용 중인 이메일입니다.';
          break;
        case 'invalid-email':
          message = '이메일 형식이 올바르지 않습니다.';
          break;
        case 'weak-password':
          message = '비밀번호가 너무 약합니다(6자 이상 권장).';
          break;
        case 'operation-not-allowed':
          message = '이 로그인 방식은 비활성화되어 있습니다.';
          break;
        case 'too-many-requests':
          message = '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.';
          break;
        default:
          message = '회원가입에 실패했습니다. (${e.code})';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      // 2. [추가!] 그 외 모든 오류 처리 (예: Firestore 오류, 네트워크 오류 등)
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('알 수 없는 오류가 발생했습니다: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void onReset() {
    _formKey.currentState!.reset();
    _emailCtrl.clear();
    _passwordCtrl.clear();
    _displayNameCtrl.clear();
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
                  TextFormField(
                    controller: _displayNameCtrl,
                    validator: _validatedisplayName,
                    decoration: InputDecoration(
                      labelText: 'NickName',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : register,
                      child: Text('회원가입'),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
