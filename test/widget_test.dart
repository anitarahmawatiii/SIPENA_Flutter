import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sipena/activity_pages.dart';
import 'package:sipena/activity_detail_page.dart';
import 'package:sipena/login_page.dart';
import 'package:sipena/main.dart';

class _ActivityFormLauncher extends StatefulWidget {
  const _ActivityFormLauncher({required this.initial, this.pickDocument});

  final ActivityEntry initial;
  final Future<ActivityDocument?> Function()? pickDocument;

  @override
  State<_ActivityFormLauncher> createState() => _ActivityFormLauncherState();
}

class _ActivityFormLauncherState extends State<_ActivityFormLauncher> {
  ActivityEntry? _saved;

  Future<void> _openEditor() async {
    final result = await Navigator.of(context).push<ActivityEntry>(
      MaterialPageRoute(
        builder: (_) => ActivityFormPage(
          type: widget.initial.type,
          id: widget.initial.id,
          initial: widget.initial,
          pickDocument: widget.pickDocument,
        ),
      ),
    );
    if (result == null || !mounted) return;
    setState(() => _saved = result);
  }

  @override
  Widget build(BuildContext context) {
    final savedDocuments = _saved?.documents.map((document) => document.name);
    return Scaffold(
      body: Column(
        children: [
          TextButton(onPressed: _openEditor, child: const Text('Buka Edit')),
          Text(
            _saved == null
                ? 'Belum disimpan'
                : 'Tersimpan: ${savedDocuments!.isEmpty ? 'tanpa dokumen' : savedDocuments.join(', ')}',
          ),
        ],
      ),
    );
  }
}

Future<void> _selectTab(WidgetTester tester, String label) async {
  final navigation = find.byType(NavigationBar);
  await tester.tap(find.descendant(of: navigation, matching: find.text(label)));
  await tester.pumpAndSettle();
}

Future<void> _fillField(
  WidgetTester tester,
  String keyName,
  String value,
) async {
  final field = find.byKey(Key(keyName));
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
}

Future<void> _dismissSnackBar(WidgetTester tester) async {
  tester
      .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
      .hideCurrentSnackBar();
  await tester.pumpAndSettle();
}

Future<void> _signInAs(WidgetTester tester, String role) async {
  await tester.pumpWidget(const SipenaApp());
  if (role != 'Mahasiswa') {
    await tester.tap(find.text(role));
  }
  await _fillField(tester, 'login-email', '${role.toLowerCase()}@sipena.test');
  await _fillField(tester, 'login-password', 'simulasi');
  await tester.ensureVisible(find.byKey(const Key('login-submit')));
  await tester.tap(find.byKey(const Key('login-submit')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('login validates credentials and opens selected dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SipenaApp());

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byKey(const Key('login-email')), findsOneWidget);
    expect(find.byKey(const Key('login-password')), findsOneWidget);
    expect(find.byKey(const Key('login-role-selector')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('login-submit')));
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Email wajib diisi.'), findsOneWidget);
    expect(find.text('Password wajib diisi.'), findsOneWidget);

    await tester.tap(find.text('Admin'));
    await _fillField(tester, 'login-email', 'admin@sipena.test');
    await _fillField(tester, 'login-password', 'apa-saja');
    await tester.ensureVisible(find.byKey(const Key('login-submit')));
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsNothing);
    expect(find.text('ADMIN'), findsOneWidget);
    expect(find.textContaining('admin@sipena.test'), findsOneWidget);
  });

  testWidgets('registration validates fields and returns to login', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SipenaApp());

    await tester.tap(find.text('Daftar di sini'));
    await tester.pumpAndSettle();
    expect(find.byType(RegistrationPage), findsOneWidget);
    for (final key in [
      'register-name',
      'register-nim',
      'register-program',
      'register-email',
      'register-password',
    ]) {
      expect(find.byKey(Key(key)), findsOneWidget);
    }

    await tester.ensureVisible(find.byKey(const Key('register-submit')));
    await tester.tap(find.byKey(const Key('register-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Nama lengkap wajib diisi.'), findsOneWidget);

    await _fillField(tester, 'register-name', 'Anita Mahasiswa');
    await _fillField(tester, 'register-nim', '2210101001');
    await _fillField(tester, 'register-program', 'Informatika');
    await _fillField(tester, 'register-email', 'anita@sipena.test');
    await _fillField(tester, 'register-password', 'password123');
    await tester.ensureVisible(find.byKey(const Key('register-submit')));
    await tester.tap(find.byKey(const Key('register-submit')));
    await tester.pumpAndSettle();

    expect(find.byType(RegistrationPage), findsNothing);
    expect(find.byType(LoginPage), findsOneWidget);
    expect(
      find.text('Pendaftaran simulasi berhasil. Silakan masuk.'),
      findsOneWidget,
    );
  });

  testWidgets('registration login link returns to the login screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SipenaApp());
    await tester.ensureVisible(find.text('Daftar di sini'));
    await tester.tap(find.text('Daftar di sini'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Login di sini'));
    await tester.tap(find.text('Login di sini'));
    await tester.pumpAndSettle();

    expect(find.byType(RegistrationPage), findsNothing);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('auth card is centered on desktop and fits mobile width', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SipenaApp());
    final desktopCard = find.byKey(const Key('auth-card'));
    final desktopSize = tester.getSize(desktopCard);
    final desktopPosition = tester.getTopLeft(desktopCard);
    expect(desktopSize.width, lessThanOrEqualTo(460));
    expect(desktopPosition.dx + desktopSize.width / 2, closeTo(720, 1));

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpWidget(const SipenaApp());
    final mobileCard = find.byKey(const Key('auth-card'));
    final mobileSize = tester.getSize(mobileCard);
    expect(mobileSize.width, lessThanOrEqualTo(358));
    expect(mobileSize.width, greaterThan(300));

    await tester.ensureVisible(find.text('Daftar di sini'));
    await tester.tap(find.text('Daftar di sini'));
    await tester.pumpAndSettle();
    final registrationSize = tester.getSize(find.byKey(const Key('auth-card')));
    expect(registrationSize.width, lessThanOrEqualTo(358));
    expect(tester.takeException(), isNull);
  });

  testWidgets('admin dashboard uses desktop navigation at laptop width', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _signInAs(tester, 'Admin');

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Pengaturan'), findsWidgets);
    await tester.tap(find.text('Penelitian').first);
    await tester.pumpAndSettle();
    expect(find.text('Daftar Penelitian'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('admin can open validation, user, and report tools', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _signInAs(tester, 'Admin');

    await tester.tap(find.text('Validasi Kegiatan'));
    await tester.pumpAndSettle();
    expect(
      find.text('Tinjau dan tentukan status kegiatan yang diajukan mahasiswa.'),
      findsOneWidget,
    );
    expect(find.text('Menunggu'), findsWidgets);
    await tester.tap(find.text('Setujui').first);
    await tester.pumpAndSettle();
    expect(find.text('Disetujui'), findsWidgets);
    await tester.tap(find.byKey(const Key('admin-page-back')));
    await tester.pumpAndSettle();
    expect(find.text('Ringkasan Kegiatan'), findsOneWidget);

    await tester.tap(find.text('Kelola Pengguna'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('admin-user-search')), findsOneWidget);
    expect(find.text('Alya Putri Ramadhani'), findsOneWidget);
    await tester.tap(find.byKey(const Key('admin-page-back')));
    await tester.pumpAndSettle();
    expect(find.text('Ringkasan Kegiatan'), findsOneWidget);

    await tester.tap(find.text('Cetak Laporan'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('report-year-filter')), findsOneWidget);
    expect(find.byKey(const Key('print-activity-report')), findsOneWidget);
    await tester.tap(find.byKey(const Key('admin-page-back')));
    await tester.pumpAndSettle();
    expect(find.text('Ringkasan Kegiatan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('admin can navigate to the new tools from mobile settings', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _signInAs(tester, 'Admin');

    await _selectTab(tester, 'Pengaturan');
    await tester.tap(find.text('Kelola Pengguna').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('admin-user-search')), findsOneWidget);
    await tester.tap(find.byKey(const Key('admin-page-back')));
    await tester.pumpAndSettle();
    expect(find.text('Pengaturan'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('student manages only personal activities across four tabs', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _signInAs(tester, 'Mahasiswa');

    expect(find.text('Kegiatan'), findsOneWidget);
    expect(find.text('Tambah'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    expect(find.textContaining('mahasiswa@sipena.test'), findsOneWidget);
    expect(
      find.text('Pengembangan Aplikasi Literasi Digital untuk Mahasiswa'),
      findsNothing,
    );
    expect(find.text('00'), findsNWidgets(3));

    await _selectTab(tester, 'Tambah');
    await tester.tap(find.byKey(const Key('student-add-penelitian')));
    await tester.pumpAndSettle();
    expect(find.byType(ActivityFormPage), findsOneWidget);
    expect(find.byKey(const Key('field-location')), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Tambah Kegiatan'), findsOneWidget);
    expect(find.text('Kegiatan Saya'), findsNothing);

    await tester.tap(find.byKey(const Key('student-add-penelitian')));
    await tester.pumpAndSettle();
    expect(find.byType(ActivityFormPage), findsOneWidget);
    await _fillField(tester, 'field-title', 'Riset Mahasiswa Mandiri');
    await _fillField(tester, 'field-student-name', 'Mahasiswa Tes');
    await _fillField(tester, 'field-student-id', '2310101099');
    await _fillField(tester, 'field-study-program', 'Informatika');
    await _fillField(tester, 'field-supervisor', 'Dr. Pembimbing');
    await _fillField(tester, 'field-location', 'Laboratorium Kampus');
    await _fillField(tester, 'field-year', '2026');
    await _fillField(tester, 'field-description', 'Deskripsi kegiatan tes.');
    await tester.ensureVisible(find.text('Simpan Data'));
    await tester.tap(find.text('Simpan Data'));
    await tester.pumpAndSettle();

    expect(find.text('Kegiatan berhasil ditambahkan.'), findsOneWidget);
    await _dismissSnackBar(tester);
    expect(find.text('Riset Mahasiswa Mandiri'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('student-activity-search')),
      'mandiri',
    );
    await tester.pumpAndSettle();
    expect(find.text('Riset Mahasiswa Mandiri'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('student-activity-search')),
      'judul tidak ada',
    );
    await tester.pumpAndSettle();
    expect(find.text('Riset Mahasiswa Mandiri'), findsNothing);
    await tester.enterText(
      find.byKey(const Key('student-activity-search')),
      '',
    );
    await tester.tap(find.byKey(const Key('student-filter-pengabdian')));
    await tester.pumpAndSettle();
    expect(find.text('Riset Mahasiswa Mandiri'), findsNothing);
    await tester.tap(find.byKey(const Key('student-filter-all')));
    await tester.pumpAndSettle();

    final activityDetail = find.byKey(const Key('activity-detail-5'));
    await tester.ensureVisible(activityDetail);
    await tester.tap(activityDetail);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('detail-edit-5')), findsOneWidget);
    await tester.tap(find.byKey(const Key('detail-edit-5')));
    await tester.pumpAndSettle();
    await _fillField(tester, 'field-title', 'Riset Mahasiswa Diperbarui');
    await tester.ensureVisible(find.text('Simpan Perubahan'));
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();
    expect(find.text('Riset Mahasiswa Diperbarui'), findsOneWidget);

    final updatedDetail = find.byKey(const Key('activity-detail-5'));
    await tester.ensureVisible(updatedDetail);
    await tester.tap(updatedDetail);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('detail-delete-5')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(FilledButton, 'Hapus'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Riset Mahasiswa Diperbarui'), findsNothing);

    await _selectTab(tester, 'Tambah');
    await tester.tap(find.byKey(const Key('student-add-pengabdian')));
    await tester.pumpAndSettle();
    await _fillField(tester, 'field-title', 'Edukasi Digital Warga');
    await _fillField(tester, 'field-student-name', 'Mahasiswa Tes');
    await _fillField(tester, 'field-student-id', '2310101099');
    await _fillField(tester, 'field-study-program', 'Informatika');
    await _fillField(tester, 'field-supervisor', 'Dr. Pembimbing');
    await _fillField(tester, 'field-location', 'Kelurahan Sukamaju');
    await _fillField(tester, 'field-year', '2026');
    await _fillField(tester, 'field-description', 'Pelatihan untuk warga.');
    await tester.ensureVisible(find.text('Simpan Data'));
    await tester.tap(find.text('Simpan Data'));
    await tester.pumpAndSettle();
    expect(find.text('Kegiatan berhasil ditambahkan.'), findsOneWidget);
    await _dismissSnackBar(tester);
    expect(find.text('Edukasi Digital Warga'), findsOneWidget);
    await tester.tap(find.byKey(const Key('student-filter-penelitian')));
    await tester.pumpAndSettle();
    expect(find.text('Edukasi Digital Warga'), findsNothing);
    await tester.tap(find.byKey(const Key('student-filter-pengabdian')));
    await tester.pumpAndSettle();
    expect(find.text('Edukasi Digital Warga'), findsOneWidget);

    await _selectTab(tester, 'Profil');
    expect(find.text('Profil Mahasiswa'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('student-logout')));
    await tester.tap(find.byKey(const Key('student-logout')));
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari akun?'), findsOneWidget);
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsNothing);
    await tester.ensureVisible(find.byKey(const Key('student-logout')));
    await tester.tap(find.byKey(const Key('student-logout')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('student-logout-confirm')));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('student profile information can be edited in the session', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _signInAs(tester, 'Mahasiswa');
    await _selectTab(tester, 'Profil');

    expect(find.text('Belum diisi'), findsNWidgets(3));
    await tester.tap(find.byKey(const Key('profile-edit')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('profile-edit-name')),
      'Alya Putri',
    );
    await tester.enterText(
      find.byKey(const Key('profile-edit-nim')),
      '2310101001',
    );
    await tester.enterText(
      find.byKey(const Key('profile-edit-program')),
      'Informatika',
    );
    await tester.tap(find.byKey(const Key('profile-save')));
    await tester.pumpAndSettle();

    expect(find.text('Alya Putri'), findsOneWidget);
    expect(find.text('2310101001'), findsOneWidget);
    expect(find.text('Informatika'), findsOneWidget);
    await _selectTab(tester, 'Beranda');
    expect(find.text('Selamat Datang, Alya Putri'), findsOneWidget);
  });

  testWidgets('student sees sample notifications and profile help actions', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _signInAs(tester, 'Mahasiswa');

    expect(find.byKey(const Key('student-notification-badge')), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    await tester.tap(find.byKey(const Key('student-notification-bell')));
    await tester.pumpAndSettle();
    expect(find.byType(StudentNotificationsPage), findsOneWidget);
    expect(find.text('Menunggu Validasi'), findsOneWidget);
    expect(find.text('Tervalidasi'), findsOneWidget);
    expect(find.text('Perlu Revisi'), findsOneWidget);
    expect(find.text('Ditolak'), findsOneWidget);
    expect(find.textContaining('bukan status nyata'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('student-notification-badge')), findsNothing);

    await _selectTab(tester, 'Profil');
    await tester.tap(find.byKey(const Key('student-help')));
    await tester.pumpAndSettle();
    expect(find.text('Bantuan SIPENA'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('student-feedback')));
    await tester.tap(find.byKey(const Key('student-feedback')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('feedback-message')),
      'Mohon tambahkan informasi status kegiatan.',
    );
    await tester.tap(find.byKey(const Key('feedback-submit')));
    await tester.pumpAndSettle();
    expect(
      find.text('Terima kasih. Feedback simulasi tidak dikirim ke server.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(const Key('student-about')));
    await tester.tap(find.byKey(const Key('student-about')));
    await tester.pumpAndSettle();
    expect(find.text('Tentang SIPENA'), findsNWidgets(2));
    await tester.tap(find.text('Tutup'));
  });

  testWidgets('edit form views, preserves, replaces, and removes documents', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const previousDocument = ActivityDocument(
      name: 'proposal-lama.pdf',
      fileType: 'PDF',
      size: '1.2 MB',
      path: '/local/proposal-lama.pdf',
    );
    const initial = ActivityEntry(
      id: 40,
      type: ActivityType.penelitian,
      title: 'Judul penelitian',
      studentName: 'Rafi Pratama',
      studentId: '2210201042',
      studyProgram: 'Teknik Elektro',
      supervisor: 'Ir. Siti Rahmawati, M.T.',
      year: '2024',
      activityDate: '2024-10-15',
      description: 'Deskripsi lama.',
      documents: [previousDocument],
    );

    await tester.pumpWidget(
      const MaterialApp(home: _ActivityFormLauncher(initial: initial)),
    );
    await tester.tap(find.text('Buka Edit'));
    await tester.pumpAndSettle();
    expect(find.text('proposal-lama.pdf'), findsOneWidget);
    final viewButton = find.byKey(const Key('edit-document-view-0'));
    await tester.ensureVisible(viewButton);
    await tester.tap(viewButton);
    await tester.pumpAndSettle();
    expect(find.text('Jenis file: PDF'), findsOneWidget);
    expect(find.text('/local/proposal-lama.pdf'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();
    expect(find.text('Tersimpan: proposal-lama.pdf'), findsOneWidget);

    const replacement = ActivityDocument(
      name: 'proposal-baru.docx',
      fileType: 'DOCX',
      size: '850 KB',
      path: '/local/proposal-baru.docx',
      bytes: [1, 2, 3],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: _ActivityFormLauncher(
          initial: initial,
          pickDocument: () async => replacement,
        ),
      ),
    );
    await tester.tap(find.text('Buka Edit'));
    await tester.pumpAndSettle();
    final replaceButton = find.byKey(const Key('edit-document-replace-0'));
    await tester.ensureVisible(replaceButton);
    await tester.tap(replaceButton);
    await tester.pumpAndSettle();
    expect(find.text('proposal-baru.docx'), findsOneWidget);
    expect(find.text('proposal-lama.pdf'), findsNothing);
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();
    expect(find.text('Tersimpan: proposal-baru.docx'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(home: _ActivityFormLauncher(initial: initial)),
    );
    await tester.tap(find.text('Buka Edit'));
    await tester.pumpAndSettle();
    final removeButton = find.byKey(const Key('edit-document-remove-0'));
    await tester.ensureVisible(removeButton);
    await tester.drag(find.byType(ListView).last, const Offset(0, -320));
    await tester.pumpAndSettle();
    await tester.tap(removeButton);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('document-empty')), findsOneWidget);
    await tester.ensureVisible(find.text('Simpan Perubahan'));
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();
    expect(find.text('Tersimpan: tanpa dokumen'), findsOneWidget);
  });

  testWidgets('activity form renders the required fields', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: ActivityFormPage(type: ActivityType.penelitian, id: 1),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(9));
    expect(find.byKey(const Key('field-title')), findsOneWidget);
  });

  testWidgets('shows SIPENA dashboard content', (WidgetTester tester) async {
    await _signInAs(tester, 'Admin');

    expect(find.text('SIPENA'), findsOneWidget);
    expect(find.text('Selamat Datang di SIPENA'), findsOneWidget);
    expect(find.text('Penelitian'), findsWidgets);
    expect(find.text('Pengabdian'), findsWidgets);
    expect(find.text('Total Kegiatan'), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);
    expect(find.text('Menu Utama'), findsNothing);
    expect(find.byKey(const Key('activity-search')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Kegiatan'),
      ),
      findsNothing,
    );
    final destinations = tester
        .widget<NavigationBar>(find.byType(NavigationBar))
        .destinations
        .cast<NavigationDestination>();
    expect((destinations[0].icon as Icon).icon, Icons.home);
    expect((destinations[1].icon as Icon).icon, Icons.science);
    expect((destinations[2].icon as Icon).icon, Icons.volunteer_activism);
    expect((destinations[3].icon as Icon).icon, Icons.settings);
  });

  testWidgets('research supports add, detail, edit, and delete', (
    WidgetTester tester,
  ) async {
    await _signInAs(tester, 'Admin');
    await _selectTab(tester, 'Penelitian');

    await tester.tap(find.byTooltip('Tambah penelitian'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Penelitian'), findsOneWidget);
    expect(find.byType(ActivityFormPage), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(9));
    expect(find.byKey(const Key('field-title')), findsOneWidget);

    await _fillField(tester, 'field-title', 'Riset Air Bersih Kampus');
    await _fillField(tester, 'field-student-name', 'Alya Contoh');
    await _fillField(tester, 'field-student-id', '2310101001');
    await _fillField(tester, 'field-study-program', 'Informatika');
    await _fillField(tester, 'field-supervisor', 'Dr. Budi Santoso');
    await _fillField(tester, 'field-year', '2026');
    await _fillField(
      tester,
      'field-description',
      'Riset kualitas air bersih di lingkungan kampus.',
    );
    await tester.ensureVisible(find.text('Simpan Data'));
    await tester.tap(find.text('Simpan Data'));
    await tester.pumpAndSettle();
    expect(find.text('Riset Air Bersih Kampus'), findsOneWidget);

    final detailButton = find.byKey(const Key('activity-detail-5'));
    await tester.ensureVisible(detailButton);
    await tester.tap(detailButton);
    await tester.pumpAndSettle();
    expect(find.text('Detail Penelitian'), findsOneWidget);
    expect(find.byType(ActivityDetailPage), findsOneWidget);
    expect(find.text('Informasi Penelitian'), findsOneWidget);
    expect(find.text('Deskripsi Penelitian'), findsOneWidget);
    expect(
      find.text('Riset kualitas air bersih di lingkungan kampus.'),
      findsOneWidget,
    );
    expect(find.text('Tanggal Penelitian'), findsOneWidget);
    expect(find.text('1 Januari 2026'), findsNWidgets(2));
    expect(find.text('Belum ada dokumen pendukung.'), findsOneWidget);
    expect(find.text('2310101001'), findsOneWidget);
    await tester.tap(find.byKey(const Key('detail-edit-5')));
    await tester.pumpAndSettle();
    await _fillField(tester, 'field-title', 'Riset Air Bersih Terbaru');
    await tester.ensureVisible(find.text('Simpan Perubahan'));
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();
    expect(find.text('Riset Air Bersih Terbaru'), findsOneWidget);
    expect(find.text('Riset Air Bersih Kampus'), findsNothing);

    await tester.tap(find.byKey(const Key('activity-detail-5')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('detail-delete-5')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(FilledButton, 'Hapus'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Riset Air Bersih Terbaru'), findsNothing);
  });

  testWidgets('pengabdian form includes location and appears in activities', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _signInAs(tester, 'Admin');
    await _selectTab(tester, 'Pengabdian');

    await tester.tap(find.byTooltip('Tambah pengabdian'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Pengabdian'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(9));
    await _fillField(tester, 'field-title', 'Pelatihan Kompos Warga');
    await _fillField(tester, 'field-student-name', 'Nadia Contoh');
    await _fillField(tester, 'field-student-id', '2310302028');
    await _fillField(tester, 'field-study-program', 'Biologi');
    await _fillField(tester, 'field-supervisor', 'Dr. Maya Lestari');
    await _fillField(tester, 'field-location', 'Desa Sukamaju');
    await _fillField(tester, 'field-year', '2026');
    await tester.ensureVisible(find.text('Simpan Data'));
    await tester.tap(find.text('Simpan Data'));
    await tester.pumpAndSettle();
    expect(find.text('Pelatihan Kompos Warga'), findsOneWidget);

    await tester.tap(find.byKey(const Key('activity-detail-5')));
    await tester.pumpAndSettle();
    expect(find.text('Informasi Pengabdian'), findsOneWidget);
    expect(find.text('Deskripsi Kegiatan'), findsOneWidget);
    expect(find.text('Dosen Pendamping'), findsOneWidget);
    expect(find.text('Lokasi Kegiatan'), findsOneWidget);
    expect(find.text('Tanggal Kegiatan'), findsOneWidget);
    expect(find.text('Belum ada deskripsi.'), findsOneWidget);
    Navigator.of(tester.element(find.byType(ActivityDetailPage))).pop();
    await tester.pumpAndSettle();

    await _selectTab(tester, 'Beranda');
    await tester.enterText(
      find.byKey(const Key('activity-search')),
      'Pelatihan Kompos Warga',
    );
    await tester.pumpAndSettle();
    expect(find.text('Nadia Contoh'), findsOneWidget);
  });

  testWidgets(
    'seeded details show date, description, and attachment metadata',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await _signInAs(tester, 'Admin');
      await _selectTab(tester, 'Penelitian');
      await tester.tap(find.byKey(const Key('activity-detail-1')));
      await tester.pumpAndSettle();

      expect(find.text('17 Maret 2025'), findsNWidgets(2));
      expect(find.text('proposal-literasi-digital.pdf'), findsOneWidget);
      expect(find.text('PDF  •  2.4 MB'), findsOneWidget);
      expect(
        find.textContaining('mengembangkan aplikasi literasi digital'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Lihat'));
      await tester.tap(find.text('Lihat'));
      await tester.pumpAndSettle();
      expect(find.textContaining('adalah dokumen contoh'), findsOneWidget);
    },
  );

  testWidgets('home search matches activity title and student name', (
    WidgetTester tester,
  ) async {
    await _signInAs(tester, 'Admin');
    await tester.enterText(find.byKey(const Key('activity-search')), 'Dimas');
    await tester.pumpAndSettle();
    expect(find.text('Dimas Aditya Nugraha'), findsOneWidget);
    expect(find.text('Alya Putri Ramadhani'), findsNothing);

    await tester.enterText(
      find.byKey(const Key('activity-search')),
      'Literasi Digital',
    );
    await tester.pumpAndSettle();
    expect(find.text('Alya Putri Ramadhani'), findsOneWidget);
    expect(find.text('Nadia Permata Sari'), findsNothing);
  });

  testWidgets('settings toggles global dark mode and opens help dialogs', (
    WidgetTester tester,
  ) async {
    await _signInAs(tester, 'Admin');
    await _selectTab(tester, 'Pengaturan');

    expect(find.text('Pengaturan'), findsNWidgets(2));
    expect(find.text('Kelola preferensi aplikasi'), findsOneWidget);
    expect(find.text('Mode Gelap'), findsOneWidget);
    expect(find.text('Panduan Penggunaan'), findsOneWidget);
    expect(find.text('Bantuan'), findsOneWidget);
    expect(find.text('Tentang SIPENA'), findsWidgets);
    expect(find.byKey(const Key('settings-dark-mode-switch')), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );

    final darkSwitch = find.byKey(const Key('settings-dark-mode-switch'));
    expect(tester.widget<SwitchListTile>(darkSwitch).value, isFalse);
    await tester.tap(darkSwitch);
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(darkSwitch).value, isTrue);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );

    await _selectTab(tester, 'Penelitian');
    expect(
      Theme.of(tester.element(find.text('Daftar Penelitian'))).brightness,
      Brightness.dark,
    );
    await _selectTab(tester, 'Pengabdian');
    expect(
      Theme.of(tester.element(find.text('Daftar Pengabdian'))).brightness,
      Brightness.dark,
    );
    await _selectTab(tester, 'Beranda');
    expect(
      Theme.of(tester.element(find.text('Selamat Datang di SIPENA')))
          .brightness,
      Brightness.dark,
    );
    await _selectTab(tester, 'Pengaturan');
    expect(
      Theme.of(tester.element(find.text('Tentang SIPENA').last)).brightness,
      Brightness.dark,
    );

    await tester.ensureVisible(find.byKey(const Key('settings-guide')));
    await tester.tap(find.byKey(const Key('settings-guide')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Lihat kegiatan melalui'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('settings-help')));
    await tester.tap(find.byKey(const Key('settings-help')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Bantuan'),
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('settings-about')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('SIPENA'),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Versi 1.0.0'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    await tester.tap(darkSwitch);
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );

    expect(
      find.textContaining('Sistem Informasi Pendataan Kegiatan Penelitian'),
      findsOneWidget,
    );
    expect(find.textContaining('Versi aplikasi'), findsOneWidget);
  });

  testWidgets('renders the dashboard on a narrow screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _signInAs(tester, 'Admin');

    expect(tester.takeException(), isNull);
    expect(find.text('Selamat Datang di SIPENA'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
