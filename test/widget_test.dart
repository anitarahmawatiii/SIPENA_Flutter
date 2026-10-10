import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sipena/activity_pages.dart';
import 'package:sipena/activity_detail_page.dart';
import 'package:sipena/main.dart';

class _ActivityFormLauncher extends StatefulWidget {
  const _ActivityFormLauncher({
    required this.initial,
    this.pickDocument,
  });

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

void main() {
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
    await tester.tap(removeButton);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('document-empty')), findsOneWidget);
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

    expect(find.byType(TextFormField), findsNWidgets(8));
    expect(find.byKey(const Key('field-title')), findsOneWidget);
  });

  testWidgets('shows SIPENA dashboard content', (WidgetTester tester) async {
    await tester.pumpWidget(const SipenaApp());

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
    await tester.pumpWidget(const SipenaApp());
    await _selectTab(tester, 'Penelitian');

    await tester.tap(find.byTooltip('Tambah penelitian'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Penelitian'), findsOneWidget);
    expect(find.byType(ActivityFormPage), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(8));
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
    await tester.pumpWidget(const SipenaApp());
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
      await tester.pumpWidget(const SipenaApp());
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
    await tester.pumpWidget(const SipenaApp());
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
    await tester.pumpWidget(const SipenaApp());
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
      Theme.of(tester.element(find.text('Selamat Datang di SIPENA'))).brightness,
      Brightness.dark,
    );
    await _selectTab(tester, 'Pengaturan');
    expect(
      Theme.of(tester.element(find.text('Tentang SIPENA').last)).brightness,
      Brightness.dark,
    );

    await tester.tap(find.byKey(const Key('settings-guide')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Lihat kegiatan melalui'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

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

    await tester.pumpWidget(const SipenaApp());

    expect(tester.takeException(), isNull);
    expect(find.text('Selamat Datang di SIPENA'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
