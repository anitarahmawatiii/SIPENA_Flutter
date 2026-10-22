import 'package:flutter/material.dart';

import 'sipena_design.dart';

enum ManagedUserRole { mahasiswa, admin }

extension ManagedUserRoleLabel on ManagedUserRole {
  String get label => switch (this) {
    ManagedUserRole.mahasiswa => 'Mahasiswa',
    ManagedUserRole.admin => 'Admin',
  };
}

class _ManagedUser {
  const _ManagedUser({
    required this.name,
    required this.identity,
    required this.email,
    required this.program,
    required this.role,
    this.isActive = true,
  });

  final String name;
  final String identity;
  final String email;
  final String program;
  final ManagedUserRole role;
  final bool isActive;

  _ManagedUser copyWith({ManagedUserRole? role, bool? isActive}) =>
      _ManagedUser(
        name: name,
        identity: identity,
        email: email,
        program: program,
        role: role ?? this.role,
        isActive: isActive ?? this.isActive,
      );
}

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final _searchController = TextEditingController();
  ManagedUserRole? _roleFilter;
  final List<_ManagedUser> _users = [
    const _ManagedUser(
      name: 'Alya Putri Ramadhani',
      identity: '2210101001',
      email: 'alya@sipena.test',
      program: 'Informatika',
      role: ManagedUserRole.mahasiswa,
    ),
    const _ManagedUser(
      name: 'Rafi Pratama',
      identity: '2210201042',
      email: 'rafi@sipena.test',
      program: 'Teknik Elektro',
      role: ManagedUserRole.mahasiswa,
    ),
    const _ManagedUser(
      name: 'Nadia Permata Sari',
      identity: '2210302028',
      email: 'nadia@sipena.test',
      program: 'Kesehatan Masyarakat',
      role: ManagedUserRole.mahasiswa,
    ),
    const _ManagedUser(
      name: 'Administrator SIPENA',
      identity: 'ADM-001',
      email: 'admin@sipena.test',
      program: 'Akademik',
      role: ManagedUserRole.admin,
    ),
    const _ManagedUser(
      name: 'Dimas Aditya Nugraha',
      identity: '2210403015',
      email: 'dimas@sipena.test',
      program: 'Manajemen',
      role: ManagedUserRole.mahasiswa,
      isActive: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final visibleUsers = _users.where((user) {
      final matchesRole = _roleFilter == null || user.role == _roleFilter;
      final matchesQuery =
          query.isEmpty ||
          user.name.toLowerCase().contains(query) ||
          user.identity.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          user.program.toLowerCase().contains(query);
      return matchesRole && matchesQuery;
    }).toList();
    final activeCount = _users.where((user) => user.isActive).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 620 ? 20.0 : 36.0;
        final contentWidth = (constraints.maxWidth - padding * 2)
            .clamp(0.0, 1160.0)
            .toDouble();
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1160),
              child: SizedBox(
                width: contentWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelola Pengguna',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Cari akun, atur peran, dan aktifkan atau nonaktifkan akses.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 22),
                    SipenaSurfaceCard(
                      child: Row(
                        children: [
                          const SipenaIconTile(
                            icon: Icons.groups_outlined,
                            color: SipenaPalette.blue,
                            background: SipenaPalette.paleBlue,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_users.length} akun terdaftar',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                Text(
                                  '$activeCount akun aktif',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      key: const Key('admin-user-search'),
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        hintText: 'Cari nama, NIM, email, atau program studi',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Semua peran'),
                          selected: _roleFilter == null,
                          onSelected: (_) => setState(() => _roleFilter = null),
                        ),
                        for (final role in ManagedUserRole.values)
                          ChoiceChip(
                            label: Text(role.label),
                            selected: _roleFilter == role,
                            onSelected: (_) => setState(() {
                              _roleFilter = _roleFilter == role ? null : role;
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (visibleUsers.isEmpty)
                      const SipenaSurfaceCard(
                        child: Center(child: Text('Pengguna tidak ditemukan.')),
                      )
                    else
                      ...visibleUsers.map((user) {
                        final index = _users.indexOf(user);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _UserCard(
                            user: user,
                            onRoleChanged: (role) => setState(
                              () => _users[index] = user.copyWith(role: role),
                            ),
                            onActiveChanged: (isActive) => setState(
                              () => _users[index] = user.copyWith(
                                isActive: isActive,
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.user,
    required this.onRoleChanged,
    required this.onActiveChanged,
  });

  final _ManagedUser user;
  final ValueChanged<ManagedUserRole> onRoleChanged;
  final ValueChanged<bool> onActiveChanged;

  @override
  Widget build(BuildContext context) {
    return SipenaSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: SipenaPalette.paleBlue,
                foregroundColor: SipenaPalette.navy,
                child: Text(user.name.substring(0, 1).toUpperCase()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${user.identity} · ${user.email}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      user.program,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: user.isActive
                      ? SipenaPalette.paleTeal
                      : SipenaPalette.paleRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  user.isActive ? 'Aktif' : 'Nonaktif',
                  style: TextStyle(
                    color: user.isActive
                        ? SipenaPalette.teal
                        : SipenaPalette.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 22),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Peran'),
                  const SizedBox(width: 8),
                  DropdownButton<ManagedUserRole>(
                    value: user.role,
                    onChanged: (role) {
                      if (role != null) onRoleChanged(role);
                    },
                    items: [
                      for (final role in ManagedUserRole.values)
                        DropdownMenuItem(value: role, child: Text(role.label)),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(user.isActive ? 'Akses aktif' : 'Akses nonaktif'),
                  Switch(value: user.isActive, onChanged: onActiveChanged),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
