import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'sipena_design.dart';

extension SipenaThemeColors on BuildContext {
  bool get isSipenaDark => Theme.of(this).brightness == Brightness.dark;

  Color get sipenaCardColor =>
      isSipenaDark ? const Color(0xFF1B2838) : Colors.white;

  Color get sipenaInsetColor =>
      isSipenaDark ? const Color(0xFF253447) : const Color(0xFFF7F9FC);

  Color get sipenaBorderColor =>
      isSipenaDark ? const Color(0xFF384B61) : SipenaPalette.line;

  Color get sipenaInputBorderColor =>
      isSipenaDark ? const Color(0xFF455970) : const Color(0xFFE1E7EF);

  Color get sipenaHeadingColor =>
      isSipenaDark ? const Color(0xFFEAF1F8) : SipenaPalette.ink;

  Color get sipenaTextColor =>
      isSipenaDark ? const Color(0xFFD5DFEA) : SipenaPalette.body;

  Color get sipenaMutedTextColor =>
      isSipenaDark ? const Color(0xFFA6B5C7) : SipenaPalette.muted;

  Color get sipenaSubtleTextColor =>
      isSipenaDark ? const Color(0xFF91A2B7) : const Color(0xFF8290A1);

  Color get sipenaAccentSurfaceColor =>
      isSipenaDark ? SipenaPalette.darkSection : SipenaPalette.paleBlue;
}

enum ActivityType { penelitian, pengabdian }

extension ActivityTypePresentation on ActivityType {
  String get label => switch (this) {
    ActivityType.penelitian => 'Penelitian',
    ActivityType.pengabdian => 'Pengabdian',
  };

  IconData get icon => switch (this) {
    ActivityType.penelitian => Icons.science_outlined,
    ActivityType.pengabdian => Icons.volunteer_activism_outlined,
  };

  Color get color => switch (this) {
    ActivityType.penelitian => SipenaPalette.blue,
    ActivityType.pengabdian => SipenaPalette.teal,
  };

  Color get tint => switch (this) {
    ActivityType.penelitian => SipenaPalette.paleBlue,
    ActivityType.pengabdian => SipenaPalette.paleTeal,
  };
}

class ActivityEntry {
  const ActivityEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.studentName,
    required this.studentId,
    required this.studyProgram,
    required this.supervisor,
    required this.year,
    this.location = '',
    this.activityDate = '',
    this.description = '',
    this.documents = const [],
  });

  final int id;
  final ActivityType type;
  final String title;
  final String studentName;
  final String studentId;
  final String studyProgram;
  final String supervisor;
  final String year;
  final String location;
  final String activityDate;
  final String description;
  final List<ActivityDocument> documents;
}

class ActivityDocument {
  const ActivityDocument({
    required this.name,
    required this.fileType,
    required this.size,
    this.path,
    this.bytes,
  });

  final String name;
  final String fileType;
  final String size;
  final String? path;
  final List<int>? bytes;
}

String formatActivityDate(String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return value.isEmpty ? '-' : value;

  const monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
}

class ActivityCollectionPage extends StatelessWidget {
  const ActivityCollectionPage({
    super.key,
    required this.type,
    required this.items,
    required this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  final ActivityType type;
  final List<ActivityEntry> items;
  final ValueChanged<ActivityEntry> onDetail;
  final ValueChanged<ActivityEntry>? onEdit;
  final ValueChanged<ActivityEntry>? onDelete;

  @override
  Widget build(BuildContext context) {
    return _ActivityPageLayout(
      title: 'Daftar ${type.label}',
      subtitle: type == ActivityType.penelitian
          ? 'Data penelitian mahasiswa yang telah tercatat'
          : 'Data kegiatan pengabdian mahasiswa yang telah tercatat',
      count: items.length,
      child: items.isEmpty
          ? _EmptyActivities(
              message: 'Belum ada data ${type.label.toLowerCase()}.',
            )
          : Column(
              children: items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ActivityCard(
                        item: item,
                        onDetail: () => onDetail(item),
                        onEdit: onEdit == null ? null : () => onEdit!(item),
                        onDelete: onDelete == null
                            ? null
                            : () => onDelete!(item),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class StudentActivityManagementPage extends StatefulWidget {
  const StudentActivityManagementPage({
    super.key,
    required this.items,
    required this.onDetail,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ActivityEntry> items;
  final ValueChanged<ActivityEntry> onDetail;
  final ValueChanged<ActivityEntry> onEdit;
  final ValueChanged<ActivityEntry> onDelete;

  @override
  State<StudentActivityManagementPage> createState() =>
      _StudentActivityManagementPageState();
}

class _StudentActivityManagementPageState
    extends State<StudentActivityManagementPage> {
  final _searchController = TextEditingController();
  ActivityType? _selectedType;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filteredItems = widget.items.where((item) {
      final matchesType = _selectedType == null || item.type == _selectedType;
      final matchesQuery =
          query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.type.label.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);
      return matchesType && matchesQuery;
    }).toList()..sort((a, b) => b.activityDate.compareTo(a.activityDate));

    return _ActivityPageLayout(
      title: 'Kegiatan Saya',
      subtitle: 'Kelola penelitian dan pengabdian yang Anda daftarkan',
      count: filteredItems.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            key: const Key('student-activity-search'),
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Cari judul atau kategori kegiatan',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: context.sipenaInsetColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.sipenaInputBorderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.sipenaInputBorderColor),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                key: const Key('student-filter-all'),
                label: const Text('Semua'),
                selected: _selectedType == null,
                onSelected: (_) => setState(() => _selectedType = null),
              ),
              for (final type in ActivityType.values)
                ChoiceChip(
                  key: Key('student-filter-${type.name}'),
                  label: Text(type.label),
                  selected: _selectedType == type,
                  onSelected: (_) => setState(() => _selectedType = type),
                ),
            ],
          ),
          const SizedBox(height: 18),
          if (filteredItems.isEmpty)
            _EmptyActivities(
              message: widget.items.isEmpty
                  ? 'Belum ada kegiatan. Tambahkan kegiatan pertama Anda.'
                  : 'Tidak ada kegiatan yang sesuai dengan filter.',
            )
          else
            ...filteredItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ActivityCard(
                  item: item,
                  onDetail: () => widget.onDetail(item),
                  onEdit: () => widget.onEdit(item),
                  onDelete: () => widget.onDelete(item),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HomeActivitySearch extends StatefulWidget {
  const HomeActivitySearch({
    super.key,
    required this.items,
    required this.onDetail,
  });

  final List<ActivityEntry> items;
  final ValueChanged<ActivityEntry> onDetail;

  @override
  State<HomeActivitySearch> createState() => _HomeActivitySearchState();
}

class _HomeActivitySearchState extends State<HomeActivitySearch> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = _query.trim().toLowerCase();
    final results = normalizedQuery.isEmpty
        ? <ActivityEntry>[]
        : widget.items
              .where(
                (item) =>
                    item.title.toLowerCase().contains(normalizedQuery) ||
                    item.studentName.toLowerCase().contains(normalizedQuery),
              )
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('activity-search'),
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: 'Cari kegiatan atau nama mahasiswa',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: context.sipenaInsetColor,
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
              borderSide: const BorderSide(
                color: SipenaPalette.blue,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (_query.trim().isNotEmpty) ...[
          const SizedBox(height: 14),
          if (results.isEmpty)
            const _EmptyActivities(
              message: 'Tidak ada kegiatan yang cocok dengan pencarian.',
            )
          else
            Column(
              children: results
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ActivityCard(
                        item: item,
                        onDetail: () => widget.onDetail(item),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ],
    );
  }
}

class _ActivityPageLayout extends StatelessWidget {
  const _ActivityPageLayout({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.child,
  });

  final String title;
  final String subtitle;
  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 620 ? 20.0 : 36.0;
        final contentWidth = constraints.maxWidth > 1232
            ? 1160.0
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: context.sipenaHeadingColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: context.sipenaMutedTextColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: SipenaPalette.navy,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$count KEGIATAN',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
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

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.item,
    required this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  final ActivityEntry item;
  final VoidCallback onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.sipenaCardColor,
        border: Border.all(color: context.sipenaBorderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SipenaIconTile(
                icon: item.type.icon,
                color: item.type.color,
                background: item.type.tint,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: item.type.tint,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            item.type.label,
                            style: TextStyle(
                              color: item.type.color,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          'Tahun ${item.year}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: context.sipenaMutedTextColor),
                        ),
                        if (item.activityDate.isNotEmpty)
                          Text(
                            formatActivityDate(item.activityDate),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: context.sipenaMutedTextColor),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _ActivityMeta(
                icon: Icons.person_outline_rounded,
                text: item.studentName,
              ),
              if (item.studentId.isNotEmpty)
                _ActivityMeta(icon: Icons.badge_outlined, text: item.studentId),
              if (item.studyProgram.isNotEmpty)
                _ActivityMeta(
                  icon: Icons.school_outlined,
                  text: item.studyProgram,
                ),
              if (item.location.isNotEmpty)
                _ActivityMeta(
                  icon: Icons.location_on_outlined,
                  text: item.location,
                ),
            ],
          ),
          if (item.description.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              item.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: context.sipenaMutedTextColor),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 2,
            runSpacing: 0,
            children: [
              TextButton.icon(
                key: Key('activity-detail-${item.id}'),
                onPressed: onDetail,
                icon: const Icon(Icons.visibility_outlined, size: 17),
                label: const Text('Lihat Detail'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              if (onEdit != null)
                TextButton.icon(
                  key: Key('activity-edit-${item.id}'),
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: SipenaPalette.navy,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              if (onDelete != null)
                TextButton.icon(
                  key: Key('activity-delete-${item.id}'),
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, size: 17),
                  label: const Text('Hapus'),
                  style: TextButton.styleFrom(
                    foregroundColor: SipenaPalette.red,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityMeta extends StatelessWidget {
  const _ActivityMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: context.sipenaSubtleTextColor),
        const SizedBox(width: 5),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: context.sipenaTextColor),
        ),
      ],
    );
  }
}

class _EmptyActivities extends StatelessWidget {
  const _EmptyActivities({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      decoration: BoxDecoration(
        color: context.sipenaInsetColor,
        border: Border.all(color: context.sipenaBorderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            color: context.sipenaSubtleTextColor,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.sipenaMutedTextColor, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class ActivityFormPage extends StatefulWidget {
  const ActivityFormPage({
    super.key,
    required this.type,
    required this.id,
    this.initial,
    this.pickDocument,
  });

  final ActivityType type;
  final int id;
  final ActivityEntry? initial;
  final Future<ActivityDocument?> Function()? pickDocument;

  @override
  State<ActivityFormPage> createState() => _ActivityFormPageState();
}

class _FormGroupHeading extends StatelessWidget {
  const _FormGroupHeading({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SipenaIconTile(
            icon: icon,
            color: SipenaPalette.navy,
            background: SipenaPalette.paleBlue,
            size: 38,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: context.sipenaMutedTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityFormPageState extends State<ActivityFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _studentNameController;
  late final TextEditingController _studentIdController;
  late final TextEditingController _programController;
  late final TextEditingController _supervisorController;
  late final TextEditingController _locationController;
  late final TextEditingController _yearController;
  late final TextEditingController _dateController;
  late final TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late List<ActivityDocument> _documents;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _titleController = TextEditingController(text: initial?.title ?? '');
    _studentNameController = TextEditingController(
      text: initial?.studentName ?? '',
    );
    _studentIdController = TextEditingController(
      text: initial?.studentId ?? '',
    );
    _programController = TextEditingController(
      text: initial?.studyProgram ?? '',
    );
    _supervisorController = TextEditingController(
      text: initial?.supervisor ?? '',
    );
    _locationController = TextEditingController(text: initial?.location ?? '');
    _yearController = TextEditingController(text: initial?.year ?? '');
    _selectedDate =
        DateTime.tryParse(initial?.activityDate ?? '') ??
        DateTime(int.tryParse(initial?.year ?? '') ?? DateTime.now().year);
    _dateController = TextEditingController(
      text: formatActivityDate(_dateIso(_selectedDate)),
    );
    _descriptionController = TextEditingController(
      text: initial?.description ?? '',
    );
    _documents = List.of(initial?.documents ?? const []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _studentNameController.dispose();
    _studentIdController.dispose();
    _programController.dispose();
    _supervisorController.dispose();
    _locationController.dispose();
    _yearController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _dateIso(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Future<void> _chooseDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: widget.type == ActivityType.penelitian
          ? 'Pilih tanggal penelitian'
          : 'Pilih tanggal kegiatan',
    );
    if (selected == null) return;
    setState(() {
      _selectedDate = selected;
      _dateController.text = formatActivityDate(_dateIso(selected));
      _yearController.text = selected.year.toString();
    });
  }

  String _formatFileSize(int? bytes) {
    if (bytes == null) return '';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<ActivityDocument?> _pickDocument() async {
    final testPicker = widget.pickDocument;
    if (testPicker != null) return testPicker();

    final file = await FilePicker.pickFile();
    if (file == null) return null;
    final extension = file.extension?.toUpperCase() ?? 'FILE';
    final sizeInBytes = file.lengthSync() ?? await file.length();
    final bytes = await file.readAsBytes();
    return ActivityDocument(
      name: file.name,
      fileType: extension,
      size: _formatFileSize(sizeInBytes),
      path: file.path,
      bytes: bytes,
    );
  }

  Future<void> _selectDocument({int? replaceIndex}) async {
    final document = await _pickDocument();
    if (document == null || !mounted) return;

    setState(() {
      if (replaceIndex == null) {
        _documents.add(document);
      } else {
        _documents[replaceIndex] = document;
      }
    });
  }

  Future<void> _viewDocument(ActivityDocument document) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dokumen pendukung'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(document.name),
            const SizedBox(height: 8),
            Text('Jenis file: ${document.fileType}'),
            if (document.size.isNotEmpty) Text('Ukuran: ${document.size}'),
            if (document.path != null) ...[
              const SizedBox(height: 8),
              Text(
                document.path!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            const Text('File tersimpan sementara di perangkat ini.'),
          ],
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

  Widget _documentSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Dokumen Pendukung',
              style: TextStyle(
                color: context.sipenaTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (_documents.isEmpty)
            Container(
              key: const Key('document-empty'),
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.sipenaInsetColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                'Belum ada dokumen pendukung.',
                style: TextStyle(
                  color: context.sipenaMutedTextColor,
                  fontSize: 13,
                ),
              ),
            )
          else
            ..._documents.indexed.map((entry) {
              final (index, document) = entry;
              return Container(
                key: Key('edit-document-$index'),
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.sipenaInsetColor,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: context.sipenaBorderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.insert_drive_file_outlined,
                          color: Color(0xFF1557A6),
                        ),
                        const SizedBox(width: 10),
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
                              const SizedBox(height: 3),
                              Text(
                                '${document.fileType}  •  ${document.size}',
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
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 2,
                      children: [
                        TextButton.icon(
                          key: Key('edit-document-view-$index'),
                          onPressed: () => _viewDocument(document),
                          icon: const Icon(Icons.visibility_outlined, size: 16),
                          label: const Text('Lihat'),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        TextButton.icon(
                          key: Key('edit-document-replace-$index'),
                          onPressed: () => _selectDocument(replaceIndex: index),
                          icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                          label: const Text('Ganti File'),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        TextButton.icon(
                          key: Key('edit-document-remove-$index'),
                          onPressed: () =>
                              setState(() => _documents.removeAt(index)),
                          icon: const Icon(Icons.delete_outline, size: 16),
                          label: const Text('Hapus'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFB23B3B),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              key: const Key('edit-document-add'),
              onPressed: () => _selectDocument(),
              icon: const Icon(Icons.attach_file_rounded, size: 18),
              label: Text(_documents.isEmpty ? 'Pilih File' : 'Tambah Dokumen'),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      ActivityEntry(
        id: widget.initial?.id ?? widget.id,
        type: widget.type,
        title: _titleController.text.trim(),
        studentName: _studentNameController.text.trim(),
        studentId: _studentIdController.text.trim(),
        studyProgram: _programController.text.trim(),
        supervisor: _supervisorController.text.trim(),
        location: _locationController.text.trim(),
        year: _yearController.text.trim(),
        activityDate: _dateIso(_selectedDate),
        description: _descriptionController.text.trim(),
        documents: List.unmodifiable(_documents),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Bagian ini wajib diisi';
    return null;
  }

  Widget _field({
    required String label,
    required String keyName,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: TextFormField(
        key: Key(keyName),
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: maxLines > 1,
          filled: true,
          fillColor: context.sipenaInsetColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 9,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(color: context.sipenaInputBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(color: context.sipenaInputBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: SipenaPalette.blue, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _dateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        key: const Key('field-date'),
        controller: _dateController,
        readOnly: true,
        onTap: _chooseDate,
        validator: _required,
        decoration: InputDecoration(
          labelText: widget.type == ActivityType.penelitian
              ? 'Tanggal penelitian'
              : 'Tanggal kegiatan',
          suffixIcon: const Icon(Icons.calendar_month_outlined),
          filled: true,
          fillColor: context.sipenaInsetColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 9,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(color: context.sipenaInputBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(color: context.sipenaInputBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: SipenaPalette.blue, width: 1.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_isEditing ? 'Edit' : 'Tambah'} ${widget.type.label}'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 88),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    children: [
                      _FormGroupHeading(
                        icon: widget.type.icon,
                        title: 'Identitas Kegiatan',
                        subtitle:
                            'Informasi kegiatan, pengusul, dan pembimbing.',
                      ),
                      const SizedBox(height: 8),
                      _field(
                        label: widget.type == ActivityType.penelitian
                            ? 'Judul penelitian'
                            : 'Judul kegiatan',
                        keyName: 'field-title',
                        controller: _titleController,
                        validator: _required,
                        maxLines: 2,
                      ),
                      _field(
                        label: 'Nama mahasiswa',
                        keyName: 'field-student-name',
                        controller: _studentNameController,
                        validator: _required,
                      ),
                      _field(
                        label: 'NIM',
                        keyName: 'field-student-id',
                        controller: _studentIdController,
                        validator: _required,
                        keyboardType: TextInputType.number,
                      ),
                      _field(
                        label: 'Program studi',
                        keyName: 'field-study-program',
                        controller: _programController,
                        validator: _required,
                      ),
                      _field(
                        label: 'Dosen pembimbing',
                        keyName: 'field-supervisor',
                        controller: _supervisorController,
                        validator: _required,
                      ),
                      const SizedBox(height: 2),
                      const _FormGroupHeading(
                        icon: Icons.event_note_rounded,
                        title: 'Pelaksanaan',
                        subtitle: 'Tentukan waktu dan lokasi kegiatan.',
                      ),
                      const SizedBox(height: 8),
                      _dateField(),
                      _field(
                        label: 'Lokasi kegiatan',
                        keyName: 'field-location',
                        controller: _locationController,
                        validator: widget.type == ActivityType.pengabdian
                            ? _required
                            : (_) => null,
                      ),
                      _field(
                        label: 'Tahun',
                        keyName: 'field-year',
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final requiredError = _required(value);
                          if (requiredError != null) return requiredError;
                          if (int.tryParse(value!.trim()) == null) {
                            return 'Masukkan tahun yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 2),
                      const _FormGroupHeading(
                        icon: Icons.subject_rounded,
                        title: 'Deskripsi',
                        subtitle: 'Ringkas tujuan dan rangkaian kegiatan.',
                      ),
                      const SizedBox(height: 8),
                      _field(
                        label: widget.type == ActivityType.penelitian
                            ? 'Deskripsi penelitian'
                            : 'Deskripsi kegiatan',
                        keyName: 'field-description',
                        controller: _descriptionController,
                        validator: (_) => null,
                        maxLines: 2,
                      ),
                      _documentSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Align(
          alignment: Alignment.center,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: Text(_isEditing ? 'Simpan Perubahan' : 'Simpan Data'),
                style: FilledButton.styleFrom(
                  backgroundColor: SipenaPalette.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
