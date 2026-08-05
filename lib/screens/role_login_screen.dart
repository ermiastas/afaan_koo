import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/backend_config.dart';

/// Authenticates adult-only areas through Supabase Auth.
class RoleLoginScreen extends StatefulWidget {
  final String role;
  final Widget dashboard;

  const RoleLoginScreen({super.key, required this.role, required this.dashboard});

  @override
  State<RoleLoginScreen> createState() => _RoleLoginScreenState();
}

class _RoleLoginScreenState extends State<RoleLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _creatingAccount = false;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      if (!BackendConfig.isConfigured) {
        throw AuthException('Adult sign-in is not configured yet.');
      }
      final auth = Supabase.instance.client.auth;
      if (_creatingAccount) {
        await auth.signUp(
          email: _email.text.trim(),
          password: _password.text,
          data: {'role': widget.role.toLowerCase()},
        );
      } else {
        await auth.signInWithPassword(email: _email.text.trim(), password: _password.text);
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => widget.dashboard));
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adult sign-in needs an internet connection and Supabase setup.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.role == 'Teacher' ? Colors.indigo : Colors.deepPurple;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  CircleAvatar(radius: 44, backgroundColor: color.withValues(alpha: .12), child: Icon(widget.role == 'Teacher' ? Icons.school_rounded : Icons.family_restroom_rounded, color: color, size: 50)),
                  const SizedBox(height: 20),
                  Text('${widget.role} sign in', textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  const Text('This is an adult-only area. Learning stays safe and separate for children.', textAlign: TextAlign.center),
                  const SizedBox(height: 28),
                  TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.email_outlined)), validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email address.'),
                  const SizedBox(height: 14),
                  TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)), validator: (value) => value != null && value.length >= 6 ? null : 'Use at least 6 characters.'),
                  const SizedBox(height: 22),
                  FilledButton(onPressed: _busy ? null : _submit, style: FilledButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(vertical: 16)), child: _busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(_creatingAccount ? 'Create adult account' : 'Sign in')),
                  TextButton(onPressed: _busy ? null : () => setState(() => _creatingAccount = !_creatingAccount), child: Text(_creatingAccount ? 'I already have an account' : 'Create an adult account')),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Back to learning')),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
