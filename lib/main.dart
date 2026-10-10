import 'package:flutter/material.dart';

import 'activity_detail_page.dart';
import 'activity_pages.dart';

void main() {
  runApp(const SipenaApp());
}

class SipenaApp extends StatefulWidget {
  const SipenaApp({super.key});

  @override
  State<SipenaApp> createState() => _SipenaAppState();
}

class _SipenaAppState extends State<SipenaApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1557A6);
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: blue,
        surface: const Color(0xFFF4F7FB),
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F7FB),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE4EAF1),
      useMaterial3: true,
    );
    final darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8FB9ED),
        brightness: Brightness.dark,
        surface: const Color(0xFF101923),
      ),
      scaffoldBackgroundColor: const Color(0xFF101923),
      cardColor: const Color(0xFF1B2838),
      dividerColor: const Color(0xFF384B61),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF101923),
        foregroundColor: Color(0xFFEAF1F8),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF1B2838),
        indicatorColor: Color(0xFF29425D),
      ),
      useMaterial3: true,
    );
    return MaterialApp(
      title: 'SIPENA',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: DashboardPage(
        isDarkMode: _isDarkMode,
        onDarkModeChanged: (value) => setState(() => _isDarkMode = value),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  int _nextActivityId = 5;
  final List<ActivityEntry> _researchItems = [
    const ActivityEntry(
      id: 1,
      type: ActivityType.penelitian,
      title: 'Pengembangan Aplikasi Literasi Digital untuk Mahasiswa',
      studentName: 'Alya Putri Ramadhani',
      studentId: '2210101001',
      studyProgram: 'Informatika',
      supervisor: 'Dr. Budi Santoso, M.Kom.',
      year: '2025',
      activityDate: '2025-03-17',
      description: 'Penelitian ini mengembangkan aplikasi literasi digital yang membantu mahasiswa menemukan materi belajar tepercaya dan mengukur perkembangan pemahaman mereka.',
      documents: [
        ActivityDocument(
          name: 'proposal-literasi-digital.pdf',
          fileType: 'PDF',
          size: '2.4 MB',
        ),
      ],
    ),
    const ActivityEntry(
      id: 2,
      type: ActivityType.penelitian,
      title: 'Analisis Pemanfaatan Energi Terbarukan di Lingkungan Kampus',
      studentName: 'Rafi Pratama',
      studentId: '2210201042',
      studyProgram: 'Teknik Elektro',
      supervisor: 'Ir. Siti Rahmawati, M.T.',
      year: '2024',
      activityDate: '2024-10-15',
      description: 'Kajian mengenai potensi penerapan energi terbarukan dan pola pemanfaatannya untuk mendukung lingkungan kampus yang lebih berkelanjutan.',
    ),
  ];
  final List<ActivityEntry> _communityItems = [
    const ActivityEntry(
      id: 3,
      type: ActivityType.pengabdian,
      title: 'Edukasi Pengelolaan Sampah untuk Warga',
      studentName: 'Nadia Permata Sari',
      studentId: '2210302028',
      studyProgram: 'Kesehatan Masyarakat',
      supervisor: 'Dr. Andi Wijaya, M.Kes.',
      location: 'Kelurahan Sukamaju',
      year: '2025',
      activityDate: '2025-08-12',
      description: 'Program edukasi dan pendampingan warga mengenai pemilahan sampah rumah tangga, pengurangan sampah, serta praktik pengelolaan yang berkelanjutan.',
      documents: [
        ActivityDocument(
          name: 'laporan-edukasi-sampah.pdf',
          fileType: 'PDF',
          size: '1.8 MB',
        ),
      ],
    ),
    const ActivityEntry(
      id: 4,
      type: ActivityType.pengabdian,
      title: 'Pendampingan UMKM dalam Pemasaran Digital',
      studentName: 'Dimas Aditya Nugraha',
      studentId: '2210403015',
      studyProgram: 'Manajemen',
      supervisor: 'Dr. Maya Lestari, S.E., M.M.',
      location: 'Desa Cibiru',
      year: '2024',
      activityDate: '2024-06-04',
      description: 'Pendampingan bagi pelaku UMKM untuk memperluas jangkauan pemasaran melalui kanal digital dan pengelolaan katalog produk.',
    ),
  ];

  List<ActivityEntry> get _allItems => [..._researchItems, ..._communityItems];

  List<_StatData> get _stats => [
    _StatData(
      label: 'Penelitian',
      value: _researchItems.length.toString().padLeft(2, '0'),
      detail: 'kegiatan terdata',
      icon: Icons.science_outlined,
      color: const Color(0xFF1557A6),
      background: const Color(0xFFE9F1FC),
    ),
    _StatData(
      label: 'Pengabdian',
      value: _communityItems.length.toString().padLeft(2, '0'),
      detail: 'kegiatan terdata',
      icon: Icons.volunteer_activism_outlined,
      color: const Color(0xFF21836B),
      background: const Color(0xFFE8F5F0),
    ),
    _StatData(
      label: 'Total Kegiatan',
      value: _allItems.length.toString().padLeft(2, '0'),
      detail: 'seluruh kegiatan',
      icon: Icons.assessment_outlined,
      color: const Color(0xFFC47B20),
      background: const Color(0xFFFFF3E3),
    ),
  ];

  Future<void> _openActivityForm(
    ActivityType type, {
    ActivityEntry? initial,
  }) async {
    final result = await Navigator.of(context).push<ActivityEntry>(
      MaterialPageRoute(
        builder: (_) =>
            ActivityFormPage(type: type, id: _nextActivityId, initial: initial),
      ),
    );
    if (result == null || !mounted) return;

    setState(() {
      final items = type == ActivityType.penelitian
          ? _researchItems
          : _communityItems;
      final index = items.indexWhere((item) => item.id == result.id);
      if (index == -1) {
        items.insert(0, result);
        _nextActivityId++;
      } else {
        items[index] = result;
      }
    });
  }

  Future<bool> _deleteActivity(ActivityEntry item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus kegiatan?'),
        content: Text('Data "${item.title}" akan dihapus dari daftar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB23B3B),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return false;

    setState(() {
      final items = item.type == ActivityType.penelitian
          ? _researchItems
          : _communityItems;
      items.removeWhere((entry) => entry.id == item.id);
    });
    return true;
  }

  Future<void> _openActivityDetail(ActivityEntry item) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ActivityDetailPage(
          activity: item,
          onEdit: () => _openActivityForm(item.type, initial: item),
          onDelete: () => _deleteActivity(item),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: KeyedSubtree(
            key: ValueKey(_selectedIndex),
            child: switch (_selectedIndex) {
              0 => _DashboardHome(
                stats: _stats,
                activities: _allItems,
                onDetail: _openActivityDetail,
              ),
              1 => ActivityCollectionPage(
                type: ActivityType.penelitian,
                items: _researchItems,
                onDetail: _openActivityDetail,
                onEdit: (item) =>
                    _openActivityForm(ActivityType.penelitian, initial: item),
                onDelete: _deleteActivity,
              ),
              2 => ActivityCollectionPage(
                type: ActivityType.pengabdian,
                items: _communityItems,
                onDetail: _openActivityDetail,
                onEdit: (item) =>
                    _openActivityForm(ActivityType.pengabdian, initial: item),
                onDelete: _deleteActivity,
              ),
              _ => _SettingsPage(
                isDarkMode: widget.isDarkMode,
                onDarkModeChanged: widget.onDarkModeChanged,
              ),
            },
          ),
        ),
      ),
      floatingActionButton: _selectedIndex == 1 || _selectedIndex == 2
          ? FloatingActionButton(
              tooltip: _selectedIndex == 1
                  ? 'Tambah penelitian'
                  : 'Tambah pengabdian',
              onPressed: () => _openActivityForm(
                _selectedIndex == 1
                    ? ActivityType.penelitian
                    : ActivityType.pengabdian,
              ),
              backgroundColor: const Color(0xFF1557A6),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add_rounded),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        backgroundColor: Theme.of(context).cardColor,
        indicatorColor: context.sipenaAccentSurfaceColor,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.science),
            selectedIcon: Icon(Icons.science),
            label: 'Penelitian',
          ),
          NavigationDestination(
            icon: Icon(Icons.volunteer_activism),
            selectedIcon: Icon(Icons.volunteer_activism),
            label: 'Pengabdian',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome({
    required this.stats,
    required this.activities,
    required this.onDetail,
  });

  final List<_StatData> stats;
  final List<ActivityEntry> activities;
  final ValueChanged<ActivityEntry> onDetail;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 620;
        final horizontalPadding = isCompact ? 20.0 : 36.0;
        final contentWidth = constraints.maxWidth > 1232
            ? 1160.0
            : constraints.maxWidth - horizontalPadding * 2;
        final statColumns = contentWidth > 700 ? 3 : 1;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: isCompact ? 20 : 32,
          ),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(isCompact: isCompact),
                  SizedBox(height: isCompact ? 28 : 40),
                  _WelcomePanel(isCompact: isCompact),
                  const SizedBox(height: 20),
                  HomeActivitySearch(items: activities, onDetail: onDetail),
                  const SizedBox(height: 32),
                  const _SectionHeading(
                    title: 'Ringkasan Kegiatan',
                    subtitle: 'Gambaran kegiatan mahasiswa saat ini',
                  ),
                  const SizedBox(height: 16),
                  _ResponsiveItems(
                    columns: statColumns,
                    spacing: 14,
                    children: stats
                        .map((stat) => _StatCard(data: stat))
                        .toList(),
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      'SIPENA  •  Sistem Informasi Pendataan Kegiatan Penelitian dan Pengabdian Mahasiswa',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage({
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  void _showGuide(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Panduan Penggunaan'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• Lihat kegiatan melalui menu Penelitian dan Pengabdian.'),
              SizedBox(height: 10),
              Text('• Tambah penelitian atau pengabdian dengan tombol +.'),
              SizedBox(height: 10),
              Text('• Tekan Lihat Detail untuk membaca informasi lengkap.'),
              SizedBox(height: 10),
              Text('• Gunakan Edit untuk mengubah informasi kegiatan.'),
              SizedBox(height: 10),
              Text('• Dokumen dapat dilihat, diganti, atau dihapus dari form edit.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bantuan'),
        content: const Text(
          'Gunakan menu Penelitian dan Pengabdian untuk mengelola data kegiatan. '
          'Untuk dokumen, buka Edit pada kegiatan lalu pilih Lihat, Ganti File, atau Hapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SIPENA'),
        content: const Text(
          'Sistem Informasi Pendataan Kegiatan Penelitian dan Pengabdian Mahasiswa.\n\nVersi 1.0.0',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 620 ? 20.0 : 36.0;
        final contentWidth = constraints.maxWidth > 1232
            ? 760.0
            : constraints.maxWidth - horizontalPadding * 2;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: constraints.maxWidth < 620 ? 24 : 32,
          ),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengaturan',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: context.sipenaHeadingColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Kelola preferensi aplikasi',
                    style: TextStyle(
                      color: context.sipenaMutedTextColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _SettingsSectionTitle('TAMPILAN'),
                  const SizedBox(height: 10),
                  Material(
                    color: context.sipenaCardColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: context.sipenaBorderColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SwitchListTile(
                      key: const Key('settings-dark-mode-switch'),
                      secondary: const Icon(Icons.dark_mode_outlined),
                      title: const Text('Mode Gelap'),
                      subtitle: const Text('Gunakan tema gelap pada aplikasi'),
                      value: isDarkMode,
                      onChanged: onDarkModeChanged,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _SettingsSectionTitle('BANTUAN & INFORMASI'),
                  const SizedBox(height: 10),
                  Material(
                    color: context.sipenaCardColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: context.sipenaBorderColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        ListTile(
                          key: const Key('settings-guide'),
                          leading: const Icon(Icons.menu_book_outlined),
                          title: const Text('Panduan Penggunaan'),
                          subtitle: const Text('Pelajari fitur utama SIPENA'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => _showGuide(context),
                        ),
                        Divider(height: 1, color: context.sipenaBorderColor),
                        ListTile(
                          key: const Key('settings-help'),
                          leading: const Icon(Icons.help_outline_rounded),
                          title: const Text('Bantuan'),
                          subtitle: const Text('Informasi penggunaan aplikasi'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => _showHelp(context),
                        ),
                        Divider(height: 1, color: context.sipenaBorderColor),
                        ListTile(
                          key: const Key('settings-about'),
                          leading: const Icon(Icons.info_outline_rounded),
                          title: const Text('Tentang SIPENA'),
                          subtitle: const Text('Informasi versi dan aplikasi'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => _showAbout(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: context.sipenaCardColor,
                      border: Border.all(color: context.sipenaBorderColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: context.sipenaAccentSurfaceColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.account_balance_outlined,
                            color: Color(0xFF1557A6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SIPENA',
                                style: TextStyle(
                                  color: context.sipenaHeadingColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sistem Informasi Pendataan Kegiatan Penelitian dan Pengabdian Mahasiswa',
                                style: TextStyle(
                                  color: context.sipenaMutedTextColor,
                                  fontSize: 12,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Versi aplikasi  1.0.0',
                                style: TextStyle(
                                  color: context.sipenaSubtleTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: context.sipenaMutedTextColor,
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF1557A6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.account_balance_outlined,
            color: Colors.white,
            size: 25,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SIPENA',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: context.sipenaHeadingColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'KEGIATAN MAHASISWA',
              style: TextStyle(
                color: context.sipenaMutedTextColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Spacer(),
        if (!isCompact)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: context.sipenaCardColor,
              border: Border.all(color: context.sipenaBorderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Color(0xFF1557A6),
                  size: 17,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tahun Akademik 2025/2026',
                  style: TextStyle(
                    color: context.sipenaTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 22 : 32),
      decoration: BoxDecoration(
        color: context.isSipenaDark
            ? const Color(0xFF1A2A3D)
            : const Color(0xFFE8F1FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.isSipenaDark
              ? const Color(0xFF35506C)
              : const Color(0xFFD7E5F6),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang di SIPENA',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: context.sipenaHeadingColor,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sistem informasi untuk mendata dan mengenal kegiatan penelitian serta pengabdian mahasiswa di lingkungan kampus.',
                  style: TextStyle(
                    color: context.sipenaTextColor,
                    fontSize: 14,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          if (!isCompact) ...[
            const SizedBox(width: 24),
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: context.sipenaCardColor.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                color: Color(0xFF1557A6),
                size: 38,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: context.sipenaTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(color: context.sipenaMutedTextColor, fontSize: 13),
        ),
      ],
    );
  }
}

class _ResponsiveItems extends StatelessWidget {
  const _ResponsiveItems({
    required this.columns,
    required this.spacing,
    required this.children,
  });

  final int columns;
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((child) => SizedBox(width: itemWidth, child: child))
              .toList(),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});

  final _StatData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.sipenaCardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.sipenaBorderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                color: context.isSipenaDark
                  ? data.color.withValues(alpha: 0.18)
                  : data.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.color, size: 23),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.sipenaMutedTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.value,
                  style: TextStyle(
                    color: context.sipenaTextColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  data.detail,
                  style: TextStyle(
                    color: context.sipenaSubtleTextColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatData {
  const _StatData({
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;
  final Color background;
}
