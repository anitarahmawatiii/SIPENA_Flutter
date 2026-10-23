import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'activity_pages.dart';
import 'sipena_design.dart';

class AdminReportPage extends StatefulWidget {
  const AdminReportPage({super.key, required this.items, required this.onBack});

  final List<ActivityEntry> items;
  final VoidCallback onBack;

  @override
  State<AdminReportPage> createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
  String? _selectedYear;
  ActivityType? _selectedType;
  bool _isPrinting = false;

  List<String> get _years =>
      widget.items.map((item) => item.year).toSet().toList()..sort();

  List<ActivityEntry> get _filteredItems => widget.items.where((item) {
    final matchesYear = _selectedYear == null || item.year == _selectedYear;
    final matchesType = _selectedType == null || item.type == _selectedType;
    return matchesYear && matchesType;
  }).toList()..sort((a, b) => a.activityDate.compareTo(b.activityDate));

  Future<void> _printReport() async {
    setState(() => _isPrinting = true);
    try {
      final rows = List<ActivityEntry>.of(_filteredItems);
      final yearLabel = _selectedYear ?? 'Semua Tahun';
      final typeLabel = _selectedType?.label ?? 'Semua Kegiatan';
      final document = pw.Document();
      document.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            pw.Text(
              'LAPORAN KEGIATAN SIPENA',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(SipenaPalette.navy.toARGB32()),
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Text('Filter: $typeLabel · $yearLabel'),
            pw.SizedBox(height: 4),
            pw.Text('Total kegiatan: ${rows.length}'),
            pw.SizedBox(height: 18),
            if (rows.isEmpty)
              pw.Text('Tidak ada kegiatan untuk filter yang dipilih.')
            else
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2.6),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(1.7),
                  3: pw.FlexColumnWidth(1.5),
                  4: pw.FlexColumnWidth(0.7),
                  5: pw.FlexColumnWidth(1),
                },
                children: [
                  _reportRow(const [
                    'Judul Kegiatan',
                    'Jenis',
                    'Mahasiswa',
                    'Program Studi',
                    'Tahun',
                    'Tanggal',
                  ], header: true),
                  for (final item in rows)
                    _reportRow([
                      item.title,
                      item.type.label,
                      '${item.studentName} (${item.studentId})',
                      item.studyProgram,
                      item.year,
                      formatActivityDate(item.activityDate),
                    ]),
                ],
              ),
            pw.SizedBox(height: 18),
            pw.Text(
              'Dicetak melalui Sistem Informasi Pendataan Kegiatan Penelitian dan Pengabdian Mahasiswa.',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
      );
      await Printing.layoutPdf(
        onLayout: (_) async => document.save(),
        name: 'laporan-kegiatan-sipena.pdf',
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Laporan tidak dapat dicetak: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  pw.TableRow _reportRow(List<String> values, {bool header = false}) {
    return pw.TableRow(
      decoration: header
          ? const pw.BoxDecoration(color: PdfColors.blueGrey100)
          : null,
      children: [
        for (final value in values)
          pw.Padding(
            padding: const pw.EdgeInsets.all(7),
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: header ? 9 : 8,
                fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    final researchCount = items
        .where((item) => item.type == ActivityType.penelitian)
        .length;
    final communityCount = items
        .where((item) => item.type == ActivityType.pengabdian)
        .length;

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
                        onPressed: widget.onBack,
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cetak Laporan',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Pilih cakupan laporan dan cetak atau simpan sebagai PDF.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  SipenaSurfaceCard(
                    child: LayoutBuilder(
                      builder: (context, cardConstraints) {
                        final compact = cardConstraints.maxWidth < 600;
                        final filters = [
                          DropdownButtonFormField<String?>(
                            key: const Key('report-year-filter'),
                            initialValue: _selectedYear,
                            decoration: const InputDecoration(
                              labelText: 'Tahun',
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                            ),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('Semua tahun'),
                              ),
                              for (final year in _years)
                                DropdownMenuItem<String?>(
                                  value: year,
                                  child: Text(year),
                                ),
                            ],
                            onChanged: (year) =>
                                setState(() => _selectedYear = year),
                          ),
                          DropdownButtonFormField<ActivityType?>(
                            key: const Key('report-type-filter'),
                            initialValue: _selectedType,
                            decoration: const InputDecoration(
                              labelText: 'Jenis kegiatan',
                              prefixIcon: Icon(Icons.category_outlined),
                            ),
                            items: [
                              const DropdownMenuItem<ActivityType?>(
                                value: null,
                                child: Text('Semua jenis'),
                              ),
                              for (final type in ActivityType.values)
                                DropdownMenuItem<ActivityType?>(
                                  value: type,
                                  child: Text(type.label),
                                ),
                            ],
                            onChanged: (type) =>
                                setState(() => _selectedType = type),
                          ),
                        ];
                        if (compact) {
                          return Column(
                            children: [
                              filters[0],
                              const SizedBox(height: 12),
                              filters[1],
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(child: filters[0]),
                            const SizedBox(width: 14),
                            Expanded(child: filters[1]),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, countConstraints) {
                      final columns = countConstraints.maxWidth < 620 ? 1 : 3;
                      final cardWidth =
                          (countConstraints.maxWidth - 12 * (columns - 1)) /
                          columns;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: cardWidth,
                            child: _ReportCountCard(
                              label: 'Total kegiatan',
                              value: items.length,
                              color: context.sipenaAccentColor,
                              tint: context.sipenaAccentSurfaceColor,
                              icon: Icons.assessment_outlined,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _ReportCountCard(
                              label: 'Penelitian',
                              value: researchCount,
                              color: context.sipenaActivityResearchColor,
                              tint: context.sipenaActivityResearchTint,
                              icon: Icons.science_outlined,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _ReportCountCard(
                              label: 'Pengabdian',
                              value: communityCount,
                              color: context.sipenaActivityCommunityColor,
                              tint: context.sipenaActivityCommunityTint,
                              icon: Icons.volunteer_activism_outlined,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  SipenaSurfaceCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Pratinjau Data',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              FilledButton.icon(
                                key: const Key('print-activity-report'),
                                onPressed: _isPrinting ? null : _printReport,
                                icon: _isPrinting
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.print_outlined),
                                label: Text(
                                  _isPrinting ? 'Menyiapkan...' : 'Cetak PDF',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        if (items.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(
                              child: Text(
                                'Tidak ada data untuk filter yang dipilih.',
                              ),
                            ),
                          )
                        else
                          for (final item in items)
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: context.activityTint(
                                  item.type,
                                ),
                                foregroundColor: context.activityColor(
                                  item.type,
                                ),
                                child: Icon(item.type.icon),
                              ),
                              title: Text(item.title),
                              subtitle: Text(
                                '${item.studentName} · ${item.type.label} · ${item.year}',
                              ),
                              trailing: Text(
                                formatActivityDate(item.activityDate),
                                style: Theme.of(context).textTheme.bodySmall,
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

class _ReportCountCard extends StatelessWidget {
  const _ReportCountCard({
    required this.label,
    required this.value,
    required this.color,
    required this.tint,
    required this.icon,
  });

  final String label;
  final int value;
  final Color color;
  final Color tint;
  final IconData icon;

  @override
  Widget build(BuildContext context) => SipenaSurfaceCard(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        SipenaIconTile(
          icon: icon,
          color: context.isSipenaDark
              ? Color.lerp(color, Colors.white, 0.42)!
              : color,
          background: context.isSipenaDark ? SipenaPalette.darkSection : tint,
          size: 40,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$value', style: Theme.of(context).textTheme.titleLarge),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    ),
  );
}
