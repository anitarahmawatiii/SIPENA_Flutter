import 'package:flutter/material.dart';

import 'activity_detail_page.dart';
import 'activity_pages.dart';
import 'admin_report_page.dart';
import 'admin_validation_page.dart';
import 'login_page.dart';
import 'sipena_design.dart';
import 'sipena_snackbar.dart';
import 'user_management_page.dart';

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
  SipenaRole? _activeRole;
  String _activeEmail = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIPENA',
      debugShowCheckedModeBanner: false,
      theme: SipenaTheme.light,
      darkTheme: SipenaTheme.dark,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: _activeRole == null
          ? LoginPage(
              onLogin: (role, email) => setState(() {
                _activeRole = role;
                _activeEmail = email;
              }),
            )
          : DashboardPage(
              role: _activeRole!,
              email: _activeEmail,
              onLogout: () => setState(() => _activeRole = null),
              isDarkMode: _isDarkMode,
              onDarkModeChanged: (value) => setState(() => _isDarkMode = value),
            ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.role,
    required this.email,
    required this.onLogout,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  final SipenaRole role;
  final String email;
  final VoidCallback onLogout;
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final List<int> _navigationHistory = [];
  int _nextActivityId = 5;
  final List<ActivityEntry> _studentActivities = [];
  final Map<int, ActivityValidationStatus> _activityValidationStatuses = {};
  final List<bool> _sampleNotificationRead = List<bool>.filled(4, false);
  _StudentProfileData _studentProfile = const _StudentProfileData();
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

  List<ActivityEntry> get _allItems => widget.role == SipenaRole.mahasiswa
      ? List.of(_studentActivities)
      : [..._researchItems, ..._communityItems];

  void _navigateTo(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _navigationHistory.add(_selectedIndex);
      _selectedIndex = index;
    });
  }

  void _goBack() {
    setState(() {
      _selectedIndex = _navigationHistory.isEmpty
          ? 0
          : _navigationHistory.removeLast();
    });
  }

  List<_StatData> get _stats => [
    _StatData(
      label: 'Penelitian',
      value: _allItems
          .where((item) => item.type == ActivityType.penelitian)
          .length
          .toString()
          .padLeft(2, '0'),
      detail: 'kegiatan terdata',
      icon: Icons.science_outlined,
      color: SipenaPalette.blue,
      background: SipenaPalette.paleBlue,
    ),
    _StatData(
      label: 'Pengabdian',
      value: _allItems
          .where((item) => item.type == ActivityType.pengabdian)
          .length
          .toString()
          .padLeft(2, '0'),
      detail: 'kegiatan terdata',
      icon: Icons.volunteer_activism_outlined,
      color: SipenaPalette.teal,
      background: SipenaPalette.paleTeal,
    ),
    _StatData(
      label: 'Total Kegiatan',
      value: _allItems.length.toString().padLeft(2, '0'),
      detail: 'seluruh kegiatan',
      icon: Icons.assessment_outlined,
      color: SipenaPalette.gold,
      background: SipenaPalette.paleGold,
    ),
  ];

  Future<bool> _openActivityForm(
    ActivityType type, {
    ActivityEntry? initial,
  }) async {
    final result = await Navigator.of(context).push<ActivityEntry>(
      MaterialPageRoute(
        builder: (_) =>
            ActivityFormPage(type: type, id: _nextActivityId, initial: initial),
      ),
    );
    if (result == null || !mounted) return false;

    setState(() {
      final items = widget.role == SipenaRole.mahasiswa
          ? _studentActivities
          : type == ActivityType.penelitian
          ? _researchItems
          : _communityItems;
      final index = items.indexWhere((item) => item.id == result.id);
      if (index == -1) {
        items.insert(0, result);
        _nextActivityId++;
      } else {
        items[index] = result;
      }
      if (widget.role == SipenaRole.mahasiswa) {
        _studentProfile = _StudentProfileData(
          name: _studentProfile.name.isEmpty
              ? result.studentName
              : _studentProfile.name,
          studentId: _studentProfile.studentId.isEmpty
              ? result.studentId
              : _studentProfile.studentId,
          studyProgram: _studentProfile.studyProgram.isEmpty
              ? result.studyProgram
              : _studentProfile.studyProgram,
        );
      }
    });
    if (initial == null) {
      SipenaSnackBar.showSuccess(context, 'Kegiatan berhasil ditambahkan.');
    }
    return true;
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
      final items = widget.role == SipenaRole.mahasiswa
          ? _studentActivities
          : item.type == ActivityType.penelitian
          ? _researchItems
          : _communityItems;
      items.removeWhere((entry) => entry.id == item.id);
    });
    return true;
  }

  Future<void> _openActivityDetail(ActivityEntry item) async {
    final canManage =
        widget.role == SipenaRole.admin || _studentActivities.contains(item);
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ActivityDetailPage(
          activity: item,
          onEdit: canManage
              ? () => _openActivityForm(item.type, initial: item)
              : null,
          onDelete: canManage ? () => _deleteActivity(item) : null,
        ),
      ),
    );
  }

  Future<void> _openStudentNotifications() async {
    setState(() {
      for (var index = 0; index < _sampleNotificationRead.length; index++) {
        _sampleNotificationRead[index] = true;
      }
    });
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const StudentNotificationsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canManageActivities = widget.role == SipenaRole.admin;
    final destinations = widget.role == SipenaRole.mahasiswa
        ? const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon: Icon(Icons.list_alt_rounded),
              label: 'Kegiatan',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline_rounded),
              selectedIcon: Icon(Icons.add_circle_rounded),
              label: 'Tambah',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ]
        : <NavigationDestination>[
            const NavigationDestination(
              icon: Icon(Icons.home),
              selectedIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            const NavigationDestination(
              icon: Icon(Icons.science),
              selectedIcon: Icon(Icons.science),
              label: 'Penelitian',
            ),
            const NavigationDestination(
              icon: Icon(Icons.volunteer_activism),
              selectedIcon: Icon(Icons.volunteer_activism),
              label: 'Pengabdian',
            ),
            const NavigationDestination(
              icon: Icon(Icons.settings),
              selectedIcon: Icon(Icons.settings),
              label: 'Pengaturan',
            ),
          ];

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (MediaQuery.sizeOf(context).width >= 900)
              _DesktopSidebar(
                role: widget.role,
                selectedIndex: _selectedIndex,
                onSelected: _navigateTo,
              ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: KeyedSubtree(
                  key: ValueKey(_selectedIndex),
                  child: switch (_selectedIndex) {
                    0 => _DashboardHome(
                      role: widget.role,
                      email: widget.email,
                      studentName: _studentProfile.name,
                      onLogout: widget.onLogout,
                      onNotifications: widget.role == SipenaRole.mahasiswa
                          ? _openStudentNotifications
                          : null,
                      unreadNotificationCount: _sampleNotificationRead
                          .where((isRead) => !isRead)
                          .length,
                      onNavigate: (index) => _navigateTo(index),
                      stats: _stats,
                      activities: _allItems,
                      onDetail: _openActivityDetail,
                    ),
                    1 =>
                      widget.role == SipenaRole.mahasiswa
                          ? StudentActivityManagementPage(
                              items: _studentActivities,
                              onDetail: _openActivityDetail,
                              onEdit: (item) =>
                                  _openActivityForm(item.type, initial: item),
                              onDelete: (item) => _deleteActivity(item),
                            )
                          : ActivityCollectionPage(
                              type: ActivityType.penelitian,
                              items: _researchItems,
                              onDetail: _openActivityDetail,
                              onEdit: (item) => _openActivityForm(
                                ActivityType.penelitian,
                                initial: item,
                              ),
                              onDelete: _deleteActivity,
                            ),
                    2 =>
                      widget.role == SipenaRole.mahasiswa
                          ? _StudentAddPage(onAdd: _addStudentActivity)
                          : ActivityCollectionPage(
                              type: ActivityType.pengabdian,
                              items: _communityItems,
                              onDetail: _openActivityDetail,
                              onEdit: (item) => _openActivityForm(
                                ActivityType.pengabdian,
                                initial: item,
                              ),
                              onDelete: _deleteActivity,
                            ),
                    3 =>
                      widget.role == SipenaRole.mahasiswa
                          ? _StudentProfilePage(
                              email: widget.email,
                              profile: _studentProfile,
                              onProfileChanged: (profile) =>
                                  setState(() => _studentProfile = profile),
                              isDarkMode: widget.isDarkMode,
                              onDarkModeChanged: widget.onDarkModeChanged,
                              onLogout: widget.onLogout,
                            )
                          : _SettingsPage(
                              isDarkMode: widget.isDarkMode,
                              onDarkModeChanged: widget.onDarkModeChanged,
                              onAdminNavigate: _navigateTo,
                            ),
                    4 => AdminValidationPage(
                      items: _allItems,
                      statuses: _activityValidationStatuses,
                      onBack: _goBack,
                      onStatusChanged: (item, status) => setState(
                        () => _activityValidationStatuses[item.id] = status,
                      ),
                      onDetail: _openActivityDetail,
                    ),
                    5 => UserManagementPage(onBack: _goBack),
                    6 => AdminReportPage(items: _allItems, onBack: _goBack),
                    _ => const SizedBox.shrink(),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          canManageActivities && (_selectedIndex == 1 || _selectedIndex == 2)
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
      bottomNavigationBar: MediaQuery.sizeOf(context).width >= 900
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex < destinations.length
                  ? _selectedIndex
                  : destinations.length - 1,
              onDestinationSelected: (index) {
                _navigateTo(index);
              },
              backgroundColor: Theme.of(context).cardColor,
              indicatorColor: context.sipenaAccentSurfaceColor,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: destinations,
            ),
    );
  }

  Future<void> _addStudentActivity(ActivityType type) async {
    final saved = await _openActivityForm(type);
    if (saved && mounted) _navigateTo(1);
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({
    required this.role,
    required this.selectedIndex,
    required this.onSelected,
  });

  final SipenaRole role;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  List<NavigationDestination> get _destinations => role == SipenaRole.mahasiswa
      ? const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt_rounded),
            label: 'Kegiatan',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: 'Tambah',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ]
      : const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.science_outlined),
            selectedIcon: Icon(Icons.science_rounded),
            label: 'Penelitian',
          ),
          NavigationDestination(
            icon: Icon(Icons.volunteer_activism_outlined),
            selectedIcon: Icon(Icons.volunteer_activism_rounded),
            label: 'Pengabdian',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Pengaturan',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined),
            selectedIcon: Icon(Icons.fact_check_rounded),
            label: 'Validasi Kegiatan',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups_rounded),
            label: 'Kelola Pengguna',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment_outlined),
            selectedIcon: Icon(Icons.assessment_rounded),
            label: 'Cetak Laporan',
          ),
        ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 232,
      color: SipenaPalette.navy,
      padding: const EdgeInsets.fromLTRB(18, 28, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: SipenaPalette.navy,
                  size: 23,
                ),
              ),
              const SizedBox(width: 11),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SIPENA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    role.label.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFC5D8F0),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.only(left: 12, bottom: 12),
            child: Text(
              'MENU UTAMA',
              style: TextStyle(
                color: Color(0xFFA9C1DF),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          for (var index = 0; index < _destinations.length; index++)
            _DesktopNavigationItem(
              destination: _destinations[index],
              selected: selectedIndex == index,
              onTap: () => onSelected(index),
            ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: Color(0xFF70D1C0),
                  size: 18,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Sistem akademik SIPENA',
                    style: TextStyle(
                      color: Color(0xFFE1ECF8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
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

class _DesktopNavigationItem extends StatelessWidget {
  const _DesktopNavigationItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final NavigationDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : const Color(0xFFC5D8F0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: selected ? const Color(0xFF2B568C) : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                IconTheme(
                  data: IconThemeData(color: foreground, size: 20),
                  child: selected
                      ? destination.selectedIcon ?? destination.icon
                      : destination.icon,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    destination.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: foreground,
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome({
    required this.role,
    required this.email,
    required this.studentName,
    required this.onLogout,
    this.onNotifications,
    this.unreadNotificationCount = 0,
    required this.onNavigate,
    required this.stats,
    required this.activities,
    required this.onDetail,
  });

  final SipenaRole role;
  final String email;
  final String studentName;
  final VoidCallback onLogout;
  final VoidCallback? onNotifications;
  final int unreadNotificationCount;
  final ValueChanged<int> onNavigate;
  final List<_StatData> stats;
  final List<ActivityEntry> activities;
  final ValueChanged<ActivityEntry> onDetail;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 620;
        final horizontalPadding = isCompact ? SipenaSpacing.pageMobile : 24.0;
        final contentWidth = constraints.maxWidth - horizontalPadding * 2;
        final statColumns = contentWidth > 880
            ? 3
            : contentWidth > 520
            ? 2
            : 1;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: isCompact ? 20 : 28,
          ),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(
                    isCompact: isCompact,
                    role: role,
                    onLogout: onLogout,
                    onNotifications: onNotifications,
                    unreadNotificationCount: unreadNotificationCount,
                  ),
                  SizedBox(height: isCompact ? 24 : 32),
                  _WelcomePanel(
                    isCompact: isCompact,
                    role: role,
                    email: email,
                    studentName: studentName,
                  ),
                  const SizedBox(height: 28),
                  _SectionHeading(
                    title: 'Ringkasan Kegiatan',
                    subtitle: role == SipenaRole.mahasiswa
                        ? 'Rekap aktivitas akademik Anda'
                        : 'Rekap kegiatan mahasiswa yang terdata',
                  ),
                  const SizedBox(height: 18),
                  _ResponsiveItems(
                    columns: statColumns,
                    spacing: 16,
                    children: stats
                        .map((stat) => _StatCard(data: stat))
                        .toList(),
                  ),
                  const SizedBox(height: 28),
                  if (role == SipenaRole.admin)
                    HomeActivitySearch(items: activities, onDetail: onDetail),
                  if (role == SipenaRole.mahasiswa)
                    LayoutBuilder(
                      builder: (context, contentConstraints) {
                        final recent = _RecentStudentActivities(
                          items: activities,
                          onDetail: onDetail,
                        );
                        final quickActions = _StudentQuickActions(
                          onNavigate: onNavigate,
                        );
                        if (contentConstraints.maxWidth < 760) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _SectionHeading(
                                title: 'Aktivitas Terbaru',
                                subtitle:
                                    'Kegiatan yang terakhir Anda tambahkan',
                              ),
                              const SizedBox(height: 16),
                              recent,
                              const SizedBox(height: 26),
                              quickActions,
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _SectionHeading(
                                    title: 'Aktivitas Terbaru',
                                    subtitle:
                                        'Kegiatan yang terakhir Anda tambahkan',
                                  ),
                                  const SizedBox(height: 16),
                                  recent,
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(flex: 4, child: quickActions),
                          ],
                        );
                      },
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

class _StudentQuickActions extends StatelessWidget {
  const _StudentQuickActions({required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return SipenaSurfaceCard(
      color: SipenaPalette.section,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SipenaIconTile(
            icon: Icons.bolt_rounded,
            color: SipenaPalette.navy,
            background: SipenaPalette.white,
            size: 42,
          ),
          const SizedBox(height: 16),
          Text('Akses Cepat', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            'Lanjutkan pekerjaan akademik Anda.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: const Key('home-add-activity'),
              onPressed: () => onNavigate(2),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah kegiatan'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: const Key('home-view-activities'),
              onPressed: () => onNavigate(1),
              icon: const Icon(Icons.list_alt_rounded),
              label: const Text('Lihat semua kegiatan'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentStudentActivities extends StatelessWidget {
  const _RecentStudentActivities({required this.items, required this.onDetail});

  final List<ActivityEntry> items;
  final ValueChanged<ActivityEntry> onDetail;

  @override
  Widget build(BuildContext context) {
    final recent = List<ActivityEntry>.of(items)
      ..sort((a, b) => b.activityDate.compareTo(a.activityDate));
    if (recent.isEmpty) {
      return SipenaSurfaceCard(
        color: SipenaPalette.section,
        padding: const EdgeInsets.all(20),
        child: Text(
          'Belum ada aktivitas. Mulai dengan menambahkan kegiatan Anda.',
          style: TextStyle(color: context.sipenaMutedTextColor, fontSize: 13),
        ),
      );
    }

    return Column(
      children: recent.take(3).map((activity) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: context.sipenaCardColor,
            border: Border.all(color: context.sipenaBorderColor),
            borderRadius: BorderRadius.circular(SipenaSpacing.radius),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: activity.type.tint,
              child: Icon(activity.type.icon, color: activity.type.color),
            ),
            title: Text(
              activity.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Text(
              '${activity.type.label} · ${formatActivityDate(activity.activityDate)}',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => onDetail(activity),
          ),
        );
      }).toList(),
    );
  }
}

class StudentNotificationsPage extends StatelessWidget {
  const StudentNotificationsPage({super.key});

  static const _examples = [
    _NotificationExample(
      title: 'Menunggu Validasi',
      detail: 'Contoh status setelah kegiatan dikirim untuk ditinjau.',
      icon: Icons.hourglass_top_rounded,
      color: Color(0xFFB7791F),
      tint: Color(0xFFFFF4D9),
    ),
    _NotificationExample(
      title: 'Tervalidasi',
      detail: 'Contoh status kegiatan yang telah disetujui.',
      icon: Icons.check_circle_outline_rounded,
      color: Color(0xFF21836B),
      tint: Color(0xFFE8F5F0),
    ),
    _NotificationExample(
      title: 'Perlu Revisi',
      detail: 'Contoh status saat informasi kegiatan perlu diperbaiki.',
      icon: Icons.edit_note_rounded,
      color: Color(0xFF1557A6),
      tint: Color(0xFFE9F1FC),
    ),
    _NotificationExample(
      title: 'Ditolak',
      detail: 'Contoh status jika pengajuan tidak dapat diterima.',
      icon: Icons.cancel_outlined,
      color: Color(0xFFB23B3B),
      tint: Color(0xFFFCECEC),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 620;
          final padding = isCompact ? 20.0 : 24.0;
          final contentWidth = constraints.maxWidth - padding * 2;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: padding,
              vertical: isCompact ? 20 : 24,
            ),
            child: Center(
              child: SizedBox(
                width: contentWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pembaruan Kegiatan',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: context.sipenaHeadingColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Contoh status untuk pratinjau. Status ini bukan status nyata kegiatan Anda.',
                      style: TextStyle(
                        color: context.sipenaMutedTextColor,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (final example in _examples)
                      _NotificationExampleCard(example: example),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Notifikasi contoh · belum terhubung ke validasi kegiatan',
                        textAlign: TextAlign.center,
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
        },
      ),
    );
  }
}

class _NotificationExample {
  const _NotificationExample({
    required this.title,
    required this.detail,
    required this.icon,
    required this.color,
    required this.tint,
  });

  final String title;
  final String detail;
  final IconData icon;
  final Color color;
  final Color tint;
}

class _NotificationExampleCard extends StatelessWidget {
  const _NotificationExampleCard({required this.example});

  final _NotificationExample example;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('notification-example-${example.title}'),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.sipenaCardColor,
        border: Border.all(color: context.sipenaBorderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: example.tint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(example.icon, color: example.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  example.title,
                  style: TextStyle(
                    color: context.sipenaHeadingColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  example.detail,
                  style: TextStyle(
                    color: context.sipenaMutedTextColor,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: example.tint,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Contoh',
              style: TextStyle(
                color: example.color,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentAddPage extends StatelessWidget {
  const _StudentAddPage({required this.onAdd});

  final ValueChanged<ActivityType> onAdd;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 620;
        final padding = isCompact ? 20.0 : 24.0;
        final contentWidth = constraints.maxWidth - padding * 2;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: isCompact ? 20 : 24,
          ),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah Kegiatan',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: context.sipenaHeadingColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pilih jenis kegiatan yang ingin Anda daftarkan.',
                    style: TextStyle(color: context.sipenaMutedTextColor),
                  ),
                  const SizedBox(height: 24),
                  for (final type in ActivityType.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: context.sipenaCardColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: context.sipenaBorderColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          key: Key('student-add-${type.name}'),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: type.tint,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(type.icon, color: type.color),
                          ),
                          title: Text(
                            type.label,
                            style: TextStyle(
                              color: context.sipenaHeadingColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            type == ActivityType.penelitian
                                ? 'Catat penelitian yang Anda lakukan'
                                : 'Catat pengabdian kepada masyarakat',
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => onAdd(type),
                        ),
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

class _StudentProfileData {
  const _StudentProfileData({
    this.name = '',
    this.studentId = '',
    this.studyProgram = '',
  });

  final String name;
  final String studentId;
  final String studyProgram;
}

class _StudentProfilePage extends StatefulWidget {
  const _StudentProfilePage({
    required this.email,
    required this.profile,
    required this.onProfileChanged,
    required this.isDarkMode,
    required this.onDarkModeChanged,
    required this.onLogout,
  });

  final String email;
  final _StudentProfileData profile;
  final ValueChanged<_StudentProfileData> onProfileChanged;
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final VoidCallback onLogout;

  @override
  State<_StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<_StudentProfilePage> {
  Future<void> _editInformation() async {
    final result = await showDialog<_StudentProfileData>(
      context: context,
      builder: (_) => _StudentProfileEditorDialog(initial: widget.profile),
    );
    if (result != null) widget.onProfileChanged(result);
  }

  Future<void> _showFeedback() async {
    final feedback = await showDialog<String>(
      context: context,
      builder: (_) => const _StudentFeedbackDialog(),
    );
    if (feedback != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Terima kasih. Feedback simulasi tidak dikirim ke server.',
          ),
        ),
      );
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Anda perlu masuk kembali untuk membuka SIPENA.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            key: const Key('student-logout-confirm'),
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB23B3B),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (shouldLogout == true) widget.onLogout();
  }

  Future<void> _showInformation(String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
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
        final padding = constraints.maxWidth < 620 ? 20.0 : 36.0;
        final contentWidth = constraints.maxWidth - padding * 2;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: constraints.maxWidth < 620 ? 20 : 28,
          ),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profil Mahasiswa',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: context.sipenaHeadingColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Informasi akun dan preferensi aplikasi',
                    style: TextStyle(color: context.sipenaMutedTextColor),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          SipenaPalette.paleBlue,
                          SipenaPalette.paleTeal,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: SipenaPalette.navy,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Akun mahasiswa',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: context.sipenaHeadingColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: context.sipenaMutedTextColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _ProfileSection(
                    title: 'Informasi Mahasiswa',
                    trailing: IconButton(
                      key: const Key('profile-edit'),
                      tooltip: 'Edit informasi mahasiswa',
                      onPressed: _editInformation,
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    child: Column(
                      children: [
                        _ProfileValue(
                          label: 'Nama lengkap',
                          value: widget.profile.name,
                        ),
                        _ProfileValue(
                          label: 'NIM',
                          value: widget.profile.studentId,
                        ),
                        _ProfileValue(
                          label: 'Program studi',
                          value: widget.profile.studyProgram,
                        ),
                        _ProfileValue(label: 'Email akun', value: widget.email),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ProfileSection(
                    title: 'Pengaturan',
                    child: SwitchListTile(
                      key: const Key('student-dark-mode-switch'),
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Icons.dark_mode_outlined),
                      title: const Text('Mode Gelap'),
                      subtitle: const Text('Sesuaikan tampilan aplikasi'),
                      value: widget.isDarkMode,
                      onChanged: widget.onDarkModeChanged,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ProfileSection(
                    title: 'Bantuan & Informasi',
                    child: Column(
                      children: [
                        _ProfileAction(
                          key: const Key('student-help'),
                          icon: Icons.help_outline_rounded,
                          title: 'Help / Bantuan',
                          subtitle: 'Panduan mengelola kegiatan',
                          onTap: () => _showInformation(
                            'Bantuan SIPENA',
                            'Gunakan menu Kegiatan untuk mencari dan mengelola kegiatan sendiri. '
                                'Pilih Tambah untuk mendaftarkan penelitian atau pengabdian. '
                                'Data saat ini hanya tersimpan selama sesi aplikasi.',
                          ),
                        ),
                        _ProfileAction(
                          key: const Key('student-feedback'),
                          icon: Icons.chat_bubble_outline_rounded,
                          title: 'Feedback',
                          subtitle: 'Kirim saran untuk pengembangan SIPENA',
                          onTap: _showFeedback,
                        ),
                        _ProfileAction(
                          key: const Key('student-about'),
                          icon: Icons.info_outline_rounded,
                          title: 'Tentang SIPENA',
                          subtitle: 'Informasi aplikasi dan versi',
                          onTap: () => _showInformation(
                            'Tentang SIPENA',
                            'Sistem Informasi Pendataan Kegiatan Penelitian dan Pengabdian Mahasiswa.\n\nVersi 1.0.0',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      key: const Key('student-logout'),
                      onPressed: _confirmLogout,
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Keluar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFB23B3B),
                        side: const BorderSide(color: Color(0xFFE5BABA)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
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

class _StudentProfileEditorDialog extends StatefulWidget {
  const _StudentProfileEditorDialog({required this.initial});

  final _StudentProfileData initial;

  @override
  State<_StudentProfileEditorDialog> createState() =>
      _StudentProfileEditorDialogState();
}

class _StudentProfileEditorDialogState
    extends State<_StudentProfileEditorDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _studentIdController;
  late final TextEditingController _programController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial.name);
    _studentIdController = TextEditingController(
      text: widget.initial.studentId,
    );
    _programController = TextEditingController(
      text: widget.initial.studyProgram,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _programController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Informasi Mahasiswa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('profile-edit-name'),
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nama lengkap'),
            ),
            TextField(
              key: const Key('profile-edit-nim'),
              controller: _studentIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'NIM'),
            ),
            TextField(
              key: const Key('profile-edit-program'),
              controller: _programController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Program studi'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('profile-save'),
          onPressed: () => Navigator.pop(
            context,
            _StudentProfileData(
              name: _nameController.text.trim(),
              studentId: _studentIdController.text.trim(),
              studyProgram: _programController.text.trim(),
            ),
          ),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class _StudentFeedbackDialog extends StatefulWidget {
  const _StudentFeedbackDialog();

  @override
  State<_StudentFeedbackDialog> createState() => _StudentFeedbackDialogState();
}

class _StudentFeedbackDialogState extends State<_StudentFeedbackDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kirim Feedback'),
      content: TextField(
        key: const Key('feedback-message'),
        controller: _controller,
        minLines: 3,
        maxLines: 5,
        decoration: const InputDecoration(
          hintText: 'Bagikan saran atau masukan Anda',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('feedback-submit'),
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              Navigator.pop(context, _controller.text.trim());
            }
          },
          child: const Text('Kirim'),
        ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: context.sipenaCardColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: context.sipenaBorderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: context.sipenaHeadingColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  ?trailing,
                ],
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileValue extends StatelessWidget {
  const _ProfileValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: TextStyle(
                color: context.sipenaMutedTextColor,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Belum diisi' : value,
              style: TextStyle(
                color: value.isEmpty
                    ? context.sipenaSubtleTextColor
                    : context.sipenaTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFF1557A6)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage({
    required this.isDarkMode,
    required this.onDarkModeChanged,
    this.onAdminNavigate,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<int>? onAdminNavigate;

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
              Text(
                '• Dokumen dapat dilihat, diganti, atau dihapus dari form edit.',
              ),
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
        final isCompact = constraints.maxWidth < 620;
        final horizontalPadding = isCompact ? 20.0 : 24.0;
        final contentWidth = constraints.maxWidth - horizontalPadding * 2;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: isCompact ? 20 : 24,
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
                  if (onAdminNavigate != null) ...[
                    const SizedBox(height: 26),
                    const _SettingsSectionTitle('ADMINISTRASI'),
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
                            leading: const Icon(Icons.fact_check_outlined),
                            title: const Text('Validasi Kegiatan'),
                            subtitle: const Text(
                              'Tinjau dan verifikasi pengajuan kegiatan',
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => onAdminNavigate!(4),
                          ),
                          Divider(height: 1, color: context.sipenaBorderColor),
                          ListTile(
                            leading: const Icon(Icons.groups_outlined),
                            title: const Text('Kelola Pengguna'),
                            subtitle: const Text('Atur peran dan status akun'),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => onAdminNavigate!(5),
                          ),
                          Divider(height: 1, color: context.sipenaBorderColor),
                          ListTile(
                            leading: const Icon(Icons.assessment_outlined),
                            title: const Text('Cetak Laporan'),
                            subtitle: const Text(
                              'Pratinjau dan cetak rekap kegiatan',
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => onAdminNavigate!(6),
                          ),
                        ],
                      ),
                    ),
                  ],
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
  const _Header({
    required this.isCompact,
    required this.role,
    required this.onLogout,
    this.onNotifications,
    this.unreadNotificationCount = 0,
  });

  final bool isCompact;
  final SipenaRole role;
  final VoidCallback onLogout;
  final VoidCallback? onNotifications;
  final int unreadNotificationCount;

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
              role.label.toUpperCase(),
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
        if (onNotifications != null)
          IconButton(
            key: const Key('student-notification-bell'),
            tooltip: 'Notifikasi',
            onPressed: onNotifications,
            icon: SizedBox(
              width: 26,
              height: 26,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.notifications_none_rounded),
                  ),
                  if (unreadNotificationCount > 0)
                    Positioned(
                      top: -5,
                      right: -8,
                      child: Container(
                        key: const Key('student-notification-badge'),
                        constraints: const BoxConstraints(
                          minWidth: 17,
                          minHeight: 17,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC33D4D),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            unreadNotificationCount > 99
                                ? '99+'
                                : '$unreadNotificationCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        IconButton(
          tooltip: 'Keluar dari akun',
          onPressed: onLogout,
          icon: const Icon(Icons.logout_rounded),
          color: const Color(0xFF718096),
        ),
      ],
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel({
    required this.isCompact,
    required this.role,
    required this.email,
    required this.studentName,
  });

  final bool isCompact;
  final SipenaRole role;
  final String email;
  final String studentName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 22 : 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SipenaPalette.navy, Color(0xFF245B9A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1E173B70),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${role.label.toUpperCase()}  ·  $email',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFFC9D9EE),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  role == SipenaRole.mahasiswa && studentName.isNotEmpty
                      ? 'Selamat Datang, $studentName'
                      : 'Selamat Datang di SIPENA',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  role == SipenaRole.admin
                      ? 'Pantau data kegiatan dan kelola penelitian serta pengabdian mahasiswa.'
                      : 'Semua kegiatan penelitian dan pengabdian Anda, tersusun dalam satu tempat.',
                  style: TextStyle(
                    color: const Color(0xFFE2EBF6),
                    fontSize: 14,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          if (!isCompact) ...[
            const SizedBox(width: 24),
            SizedBox(
              width: 146,
              height: 128,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: -0.12,
                    child: Container(
                      width: 88,
                      height: 112,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3478F6).withValues(alpha: 0.62),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: 0.12,
                    child: Container(
                      width: 78,
                      height: 98,
                      decoration: BoxDecoration(
                        color: const Color(0xFF20A899),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),
                ],
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
    return SipenaSectionHeading(title: title, subtitle: subtitle);
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
        color: context.isSipenaDark ? context.sipenaCardColor : data.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.isSipenaDark
              ? context.sipenaBorderColor
              : data.color.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SipenaIconTile(
                icon: data.icon,
                color: data.color,
                background: context.isSipenaDark
                    ? data.color.withValues(alpha: 0.18)
                    : Colors.white.withValues(alpha: 0.84),
                size: 42,
              ),
              const Spacer(),
              Icon(
                Icons.north_east_rounded,
                color: data.color.withValues(alpha: 0.65),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            data.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.isSipenaDark
                  ? context.sipenaMutedTextColor
                  : data.color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: context.isSipenaDark
                  ? context.sipenaTextColor
                  : SipenaPalette.navy,
              fontSize: 30,
            ),
          ),
          Text(
            data.detail,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: context.sipenaMutedTextColor),
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
