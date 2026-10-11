import 'package:flutter/material.dart';

import 'activity_pages.dart';
import 'sipena_design.dart';

class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage({
    super.key,
    required this.activity,
    this.onEdit,
    this.onDelete,
  });

  final ActivityEntry activity;
  final Future<void> Function()? onEdit;
  final Future<bool> Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final isResearch = activity.type == ActivityType.penelitian;
    final detailTitle = isResearch ? 'Detail Penelitian' : 'Detail Pengabdian';
    final informationTitle = isResearch
        ? 'Informasi Penelitian'
        : 'Informasi Pengabdian';
    final descriptionTitle = isResearch
        ? 'Deskripsi Penelitian'
        : 'Deskripsi Kegiatan';
    final dateLabel = isResearch ? 'Tanggal Penelitian' : 'Tanggal Kegiatan';
    final date = formatActivityDate(
      activity.activityDate.isEmpty
          ? '${activity.year}-01-01'
          : activity.activityDate,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text(detailTitle)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 620 ? 16.0 : 32.0;
            final contentWidth = constraints.maxWidth > 1180
                ? 900.0
                : constraints.maxWidth - horizontalPadding * 2;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                28,
              ),
              child: Center(
                child: SizedBox(
                  width: contentWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailHero(activity: activity, date: date),
                      const SizedBox(height: 16),
                      _DetailSection(
                        title: informationTitle,
                        icon: Icons.info_outline_rounded,
                        child: _InformationGrid(
                          items: [
                            _InformationItem(
                              label: isResearch
                                  ? 'Nama Mahasiswa'
                                  : 'Nama Mahasiswa / Pelaksana',
                              value: activity.studentName,
                              icon: Icons.person_outline_rounded,
                            ),
                            if (activity.studentId.isNotEmpty)
                              _InformationItem(
                                label: 'NIM',
                                value: activity.studentId,
                                icon: Icons.badge_outlined,
                              ),
                            if (activity.studyProgram.isNotEmpty)
                              _InformationItem(
                                label: 'Program Studi',
                                value: activity.studyProgram,
                                icon: Icons.school_outlined,
                              ),
                            _InformationItem(
                              label: isResearch
                                  ? 'Dosen Pembimbing'
                                  : 'Dosen Pendamping',
                              value: activity.supervisor,
                              icon: Icons.co_present_outlined,
                            ),
                            _InformationItem(
                              label: dateLabel,
                              value: date,
                              icon: Icons.calendar_month_outlined,
                            ),
                            if (!isResearch && activity.location.isNotEmpty)
                              _InformationItem(
                                label: 'Lokasi Kegiatan',
                                value: activity.location,
                                icon: Icons.location_on_outlined,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _DetailSection(
                        title: descriptionTitle,
                        icon: Icons.subject_rounded,
                        child: Text(
                          activity.description.trim().isEmpty
                              ? 'Belum ada deskripsi.'
                              : activity.description.trim(),
                          style: TextStyle(
                            color: context.sipenaTextColor,
                            fontSize: 15,
                            height: 1.65,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _DetailSection(
                        title: 'Dokumen Pendukung',
                        icon: Icons.attach_file_rounded,
                        child: activity.documents.isEmpty
                            ? const _NoDocuments()
                            : Column(
                                children: activity.documents
                                    .map(
                                      (document) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: _DocumentAttachment(
                                          document: document,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: onEdit == null && onDelete == null
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Align(
                alignment: Alignment.center,
                heightFactor: 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 840),
                  child: Row(
                    children: [
                      if (onEdit != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            key: Key('detail-edit-${activity.id}'),
                            onPressed: () async {
                              await onEdit!();
                              if (context.mounted) Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Edit'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: SipenaPalette.navy,
                              minimumSize: const Size.fromHeight(50),
                              side: const BorderSide(color: Color(0xFFB8CBE2)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      if (onEdit != null && onDelete != null)
                        const SizedBox(width: 12),
                      if (onDelete != null)
                        Expanded(
                          child: FilledButton.icon(
                            key: Key('detail-delete-${activity.id}'),
                            onPressed: () async {
                              final deleted = await onDelete!();
                              if (deleted && context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: const Text('Hapus'),
                            style: FilledButton.styleFrom(
                              backgroundColor: SipenaPalette.red,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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

class _DetailHero extends StatelessWidget {
  const _DetailHero({required this.activity, required this.date});

  final ActivityEntry activity;
  final String date;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(compact ? 20 : 26),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SipenaPalette.navy, Color(0xFF245B9A)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1D173B70),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            activity.type.label.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          'TAHUN ${activity.year}',
                          style: const TextStyle(
                            color: Color(0xFFD0DFF1),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      activity.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFFD0DFF1),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            date,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!compact) ...[
                const SizedBox(width: 20),
                Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Icon(
                    activity.type.icon,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SipenaSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: SipenaPalette.blue, size: 20),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: context.sipenaTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InformationItem {
  const _InformationItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class _InformationGrid extends StatelessWidget {
  const _InformationGrid({required this.items});

  final List<_InformationItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 580 ? 2 : 1;
        const spacing = 10.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items
              .map(
                (item) => SizedBox(
                  width: itemWidth,
                  child: _InformationTile(item: item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _InformationTile extends StatelessWidget {
  const _InformationTile({required this.item});

  final _InformationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 78),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.isSipenaDark
            ? SipenaPalette.darkSection
            : SipenaPalette.section,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: const Color(0xFF55769C), size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    color: context.sipenaSubtleTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.value.isEmpty ? '-' : item.value,
                  style: TextStyle(
                    color: context.sipenaTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
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

class _NoDocuments extends StatelessWidget {
  const _NoDocuments();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: context.sipenaInsetColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            color: context.sipenaSubtleTextColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Belum ada dokumen pendukung.',
              style: TextStyle(
                color: context.sipenaMutedTextColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentAttachment extends StatelessWidget {
  const _DocumentAttachment({required this.document});

  final ActivityDocument document;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.sipenaInsetColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.sipenaBorderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 46,
            decoration: BoxDecoration(
              color: context.sipenaAccentSurfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              document.fileType.toLowerCase() == 'pdf'
                  ? Icons.picture_as_pdf_outlined
                  : Icons.insert_drive_file_outlined,
              color: SipenaPalette.blue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.sipenaTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${document.fileType.toUpperCase()}  •  ${document.size}',
                  style: TextStyle(
                    color: context.sipenaSubtleTextColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          TextButton.icon(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Dokumen pendukung'),
                  content: Text(
                    '"${document.name}" adalah dokumen contoh. Pratinjau file belum terhubung.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.open_in_new_rounded, size: 16),
            label: const Text('Lihat'),
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }
}
