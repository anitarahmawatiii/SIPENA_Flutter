import 'package:flutter/material.dart';

import 'activity_pages.dart';
import 'sipena_design.dart';

enum ActivityValidationStatus { pending, approved, revision, rejected }

extension ActivityValidationPresentation on ActivityValidationStatus {
  String get label => switch (this) {
    ActivityValidationStatus.pending => 'Menunggu',
    ActivityValidationStatus.approved => 'Disetujui',
    ActivityValidationStatus.revision => 'Perlu revisi',
    ActivityValidationStatus.rejected => 'Ditolak',
  };

  SipenaStatusTone get tone => switch (this) {
    ActivityValidationStatus.pending => SipenaStatusTone.waiting,
    ActivityValidationStatus.approved => SipenaStatusTone.success,
    ActivityValidationStatus.revision => SipenaStatusTone.revision,
    ActivityValidationStatus.rejected => SipenaStatusTone.rejected,
  };
}

class AdminValidationPage extends StatefulWidget {
  const AdminValidationPage({
    super.key,
    required this.items,
    required this.statuses,
    required this.onBack,
    required this.onStatusChanged,
    required this.onDetail,
  });

  final List<ActivityEntry> items;
  final Map<int, ActivityValidationStatus> statuses;
  final VoidCallback onBack;
  final void Function(ActivityEntry item, ActivityValidationStatus status)
  onStatusChanged;
  final ValueChanged<ActivityEntry> onDetail;

  @override
  State<AdminValidationPage> createState() => _AdminValidationPageState();
}

class _AdminValidationPageState extends State<AdminValidationPage> {
  ActivityValidationStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((item) {
      final status =
          widget.statuses[item.id] ?? ActivityValidationStatus.pending;
      return _filter == null || status == _filter;
    }).toList();
    final pendingCount = widget.items
        .where(
          (item) =>
              (widget.statuses[item.id] ?? ActivityValidationStatus.pending) ==
              ActivityValidationStatus.pending,
        )
        .length;

    return _AdminPageBody(
      title: 'Validasi Kegiatan',
      subtitle: 'Tinjau dan tentukan status kegiatan yang diajukan mahasiswa.',
      onBack: widget.onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SipenaSurfaceCard(
            child: Row(
              children: [
                SipenaIconTile(
                  icon: Icons.fact_check_outlined,
                  color: context.sipenaStatusWaitingColor,
                  background: context.sipenaStatusWaitingTint,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$pendingCount kegiatan menunggu',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Periksa data dan dokumen sebelum mengambil keputusan.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusFilterChip(
                label: 'Semua',
                selected: _filter == null,
                onTap: () => setState(() => _filter = null),
              ),
              for (final status in ActivityValidationStatus.values)
                _StatusFilterChip(
                  label: status.label,
                  selected: _filter == status,
                  onTap: () => setState(() => _filter = status),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (filteredItems.isEmpty)
            const _AdminEmptyState(
              icon: Icons.check_circle_outline_rounded,
              message: 'Tidak ada kegiatan dengan status ini.',
            )
          else
            ...filteredItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ValidationActivityCard(
                  item: item,
                  status:
                      widget.statuses[item.id] ??
                      ActivityValidationStatus.pending,
                  onDetail: () => widget.onDetail(item),
                  onStatusChanged: (status) =>
                      widget.onStatusChanged(item, status),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ValidationActivityCard extends StatelessWidget {
  const _ValidationActivityCard({
    required this.item,
    required this.status,
    required this.onDetail,
    required this.onStatusChanged,
  });

  final ActivityEntry item;
  final ActivityValidationStatus status;
  final VoidCallback onDetail;
  final ValueChanged<ActivityValidationStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return SipenaSurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SipenaIconTile(
                icon: item.type.icon,
                color: context.activityColor(item.type),
                background: context.activityTint(item.type),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${item.type.label} · ${item.studentName} · ${item.studentId}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SipenaStatusBadge(label: status.label, tone: status.tone),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Program Studi: ${item.studyProgram}  ·  Tahun: ${item.year}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: onDetail,
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: const Text('Tinjau detail'),
              ),
              if (status != ActivityValidationStatus.approved)
                FilledButton.tonalIcon(
                  onPressed: () =>
                      onStatusChanged(ActivityValidationStatus.approved),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Setujui'),
                ),
              if (status != ActivityValidationStatus.revision)
                OutlinedButton.icon(
                  onPressed: () =>
                      onStatusChanged(ActivityValidationStatus.revision),
                  icon: const Icon(Icons.edit_note_rounded, size: 18),
                  label: const Text('Minta revisi'),
                ),
              if (status != ActivityValidationStatus.rejected)
                TextButton.icon(
                  onPressed: () =>
                      onStatusChanged(ActivityValidationStatus.rejected),
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: const Text('Tolak'),
                  style: TextButton.styleFrom(
                    foregroundColor: context.sipenaDangerColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusFilterChip extends StatelessWidget {
  const _StatusFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => FilterChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onTap(),
  );
}

class _AdminPageBody extends StatelessWidget {
  const _AdminPageBody({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.child,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final Widget child;

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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        key: const Key('admin-page-back'),
                        tooltip: 'Kembali',
                        onPressed: onBack,
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              subtitle,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AdminEmptyState extends StatelessWidget {
  const _AdminEmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => SipenaSurfaceCard(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icon, size: 34, color: context.sipenaMutedTextColor),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}
