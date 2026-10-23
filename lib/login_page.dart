import 'package:flutter/material.dart';

import 'sipena_design.dart';

enum SipenaRole { mahasiswa, admin }

extension SipenaRoleLabel on SipenaRole {
  String get label => switch (this) {
    SipenaRole.mahasiswa => 'Mahasiswa',
    SipenaRole.admin => 'Admin',
  };
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin});

  final void Function(SipenaRole role, String email) onLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  SipenaRole _selectedRole = SipenaRole.mahasiswa;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onLogin(_selectedRole, _emailController.text.trim());
  }

  Future<void> _openRegistration() async {
    final registered = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const RegistrationPage()));
    if (registered == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran simulasi berhasil. Silakan masuk.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _AuthPageFrame(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AuthHeading(title: 'Selamat Datang', centered: true),
              const SizedBox(height: 24),
              const _FieldLabel('Email'),
              const SizedBox(height: 7),
              TextFormField(
                key: const Key('login-email'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.username],
                decoration: _authInputDecoration(
                  context,
                  hint: 'Masukkan email',
                  icon: Icons.mail_outline_rounded,
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Password'),
              const SizedBox(height: 7),
              TextFormField(
                key: const Key('login-password'),
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => _submit(),
                decoration:
                    _authInputDecoration(
                      context,
                      hint: 'Masukkan password',
                      icon: Icons.lock_outline_rounded,
                    ).copyWith(
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Tampilkan password'
                            : 'Sembunyikan password',
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                validator: (value) =>
                    (value ?? '').isEmpty ? 'Password wajib diisi.' : null,
              ),
              const SizedBox(height: 18),
              const _FieldLabel('Masuk sebagai'),
              const SizedBox(height: 7),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<SipenaRole>(
                  key: const Key('login-role-selector'),
                  segments: const [
                    ButtonSegment(
                      value: SipenaRole.mahasiswa,
                      label: Text('Mahasiswa'),
                      icon: Icon(Icons.school_outlined),
                    ),
                    ButtonSegment(
                      value: SipenaRole.admin,
                      label: Text('Admin'),
                      icon: Icon(Icons.admin_panel_settings_outlined),
                    ),
                  ],
                  selected: {_selectedRole},
                  onSelectionChanged: (selection) =>
                      setState(() => _selectedRole = selection.first),
                  showSelectedIcon: false,
                ),
              ),
              const SizedBox(height: 22),
              _PrimaryAuthButton(
                key: const Key('login-submit'),
                label: 'Masuk',
                onPressed: _submit,
              ),
              const SizedBox(height: 20),
              _AuthNavigationText(
                lead: 'Belum punya akun?',
                action: 'Daftar di sini',
                onTap: _openRegistration,
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Login simulasi tanpa database atau API.',
                  style: TextStyle(
                    color: context.sipenaSubtleTextColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _programController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _programController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _AuthPageFrame(
          showBackButton: true,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _AuthHeading(
                  title: 'Buat akun baru',
                  subtitle: 'Lengkapi data diri untuk mendaftar di SIPENA.',
                  centered: true,
                ),
                const SizedBox(height: 20),
                const _FieldLabel('Nama lengkap'),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('register-name'),
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: _authInputDecoration(
                    context,
                    hint: 'Masukkan nama lengkap',
                    icon: Icons.person_outline_rounded,
                  ),
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'Nama lengkap wajib diisi.'
                      : null,
                ),
                const SizedBox(height: 13),
                const _FieldLabel('NIM'),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('register-nim'),
                  controller: _nimController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: _authInputDecoration(
                    context,
                    hint: 'Masukkan NIM',
                    icon: Icons.badge_outlined,
                  ),
                  validator: (value) =>
                      (value ?? '').trim().isEmpty ? 'NIM wajib diisi.' : null,
                ),
                const SizedBox(height: 13),
                const _FieldLabel('Program studi'),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('register-program'),
                  controller: _programController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: _authInputDecoration(
                    context,
                    hint: 'Masukkan program studi',
                    icon: Icons.menu_book_outlined,
                  ),
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'Program studi wajib diisi.'
                      : null,
                ),
                const SizedBox(height: 13),
                const _FieldLabel('Email'),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('register-email'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _authInputDecoration(
                    context,
                    hint: 'Masukkan email',
                    icon: Icons.mail_outline_rounded,
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 13),
                const _FieldLabel('Password'),
                const SizedBox(height: 6),
                TextFormField(
                  key: const Key('register-password'),
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration:
                      _authInputDecoration(
                        context,
                        hint: 'Buat password',
                        icon: Icons.lock_outline_rounded,
                      ).copyWith(
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Tampilkan password'
                              : 'Sembunyikan password',
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                  validator: (value) => (value ?? '').length < 6
                      ? 'Password minimal 6 karakter.'
                      : null,
                ),
                const SizedBox(height: 20),
                _PrimaryAuthButton(
                  key: const Key('register-submit'),
                  label: 'Daftar',
                  onPressed: _submit,
                ),
                const SizedBox(height: 18),
                _AuthNavigationText(
                  lead: 'Sudah punya akun?',
                  action: 'Login di sini',
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthPageFrame extends StatelessWidget {
  const _AuthPageFrame({required this.child, this.showBackButton = false});

  final Widget child;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 600;
          final isWide = constraints.maxWidth >= 1100;
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ColoredBox(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                  if (isWide)
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      width: constraints.maxWidth * 0.35,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [SipenaPalette.navy, Color(0xFF245B9A)],
                          ),
                        ),
                      ),
                    )
                  else
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: isCompact ? 184 : 224,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [SipenaPalette.navy, Color(0xFF245B9A)],
                          ),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  if (isWide)
                    Positioned(
                      left: 56,
                      top: constraints.maxHeight * 0.27,
                      width: constraints.maxWidth * 0.25,
                      child: const _AuthBrandPanel(),
                    ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isCompact ? 16 : 24,
                        vertical: 24,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 460),
                        child: Container(
                          key: const Key('auth-card'),
                          width: double.infinity,
                          padding: EdgeInsets.all(isCompact ? 22 : 32),
                          decoration: BoxDecoration(
                            color: context.sipenaCardColor,
                            border: Border.all(
                              color: context.sipenaBorderColor,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1B173B70),
                                blurRadius: 30,
                                offset: Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (showBackButton)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    tooltip: 'Kembali ke login',
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: const Icon(Icons.arrow_back_rounded),
                                  ),
                                ),
                              if (showBackButton) const SizedBox(height: 2),
                              const _BrandMark(),
                              const SizedBox(height: 24),
                              child,
                            ],
                          ),
                        ),
                      ),
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

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SipenaPalette.navy, SipenaPalette.blue],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x242B67B1),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            Icons.account_balance_rounded,
            color: context.sipenaAccentColor,
            size: 28,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          'SIPENA',
          style: TextStyle(
            color: context.sipenaHeadingColor,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Academic Management System',
          style: TextStyle(color: context.sipenaMutedTextColor, fontSize: 12),
        ),
      ],
    );
  }
}

class _AuthBrandPanel extends StatelessWidget {
  const _AuthBrandPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.account_balance_rounded, color: Colors.white, size: 40),
        SizedBox(height: 26),
        Text(
          'SIPENA',
          style: TextStyle(
            color: Color(0xFF8CE0D2),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Riset dan pengabdian, lebih tertata.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1.12,
          ),
        ),
        SizedBox(height: 14),
        Text(
          'Satu ruang untuk mencatat, mengelola, dan meninjau aktivitas akademik.',
          style: TextStyle(
            color: Color(0xFFD8E6F6),
            fontSize: 15,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _AuthHeading extends StatelessWidget {
  const _AuthHeading({
    required this.title,
    this.subtitle,
    this.centered = false,
  });

  final String title;
  final String? subtitle;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: context.sipenaHeadingColor,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 5),
          Text(
            subtitle!,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              color: context.sipenaMutedTextColor,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: context.sipenaTextColor,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _PrimaryAuthButton extends StatelessWidget {
  const _PrimaryAuthButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: context.sipenaAccentColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
    );
  }
}

class _AuthNavigationText extends StatelessWidget {
  const _AuthNavigationText({
    required this.lead,
    required this.action,
    required this.onTap,
  });

  final String lead;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            lead,
            style: TextStyle(color: context.sipenaMutedTextColor, fontSize: 13),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: context.sipenaAccentColor,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              action,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _authInputDecoration(
  BuildContext context, {
  required String hint,
  required IconData icon,
}) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, size: 19, color: context.sipenaMutedTextColor),
    filled: true,
    fillColor: context.sipenaInsetColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: context.sipenaInputBorderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: context.sipenaInputBorderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: context.sipenaAccentColor, width: 1.5),
    ),
  );
}

String? _validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Email wajib diisi.';
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return 'Masukkan alamat email yang valid.';
  }
  return null;
}
