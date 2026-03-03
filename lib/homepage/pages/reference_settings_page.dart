import 'dart:typed_data';

import 'package:drift/drift.dart' show Variable;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/db/database.dart';
import '../../data/models/reference_service.dart';
import '../../data/models/sync_service_provider.dart';

class ReferenceSettingsPage extends StatefulWidget {
  const ReferenceSettingsPage({super.key});

  @override
  State<ReferenceSettingsPage> createState() => _ReferenceSettingsPageState();
}

class _ReferenceSettingsPageState extends State<ReferenceSettingsPage> {
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color pageBg = Color(0xFFF6F8FA);
  static const Color cardBg = Colors.white;
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  static const List<_ReferenceTableConfig> _tables = [
    _ReferenceTableConfig('sex', 'Sex'),
    _ReferenceTableConfig('nationality', 'Nationality'),
    _ReferenceTableConfig('airline', 'Airline'),
    _ReferenceTableConfig('travel_status', 'Travel Status'),
    _ReferenceTableConfig('location', 'Location'),
    _ReferenceTableConfig('incident_place_category', 'Incident Place Category'),
    _ReferenceTableConfig(
      'incident_place_category2',
      'Incident Place Category2',
    ),
    _ReferenceTableConfig('reporting_unit', 'Reporting Unit'),
    _ReferenceTableConfig('chief_complaint_type', 'Chief Complaint Type'),
    _ReferenceTableConfig('chief_complaint_detail', 'Chief Complaint Detail'),
    _ReferenceTableConfig('diagnosis_category', 'Diagnosis Category'),
    _ReferenceTableConfig('triage_level', 'Triage Level'),
    _ReferenceTableConfig('treatment_on_site', 'Treatment On Site'),
    _ReferenceTableConfig('treatment_result', 'Treatment Result'),
    _ReferenceTableConfig('referral_hospital', 'Referral Hospital'),
    _ReferenceTableConfig('action_item', 'Action Item'),
    _ReferenceTableConfig('medical_staff', 'Medical Staff'),
    _ReferenceTableConfig('nursing_phrase', 'Nursing Phrase'),
    _ReferenceTableConfig('payment_method', 'Payment Method'),
    _ReferenceTableConfig('collection_status', 'Collection Status'),
    _ReferenceTableConfig('currency_ref', 'Currency'),
    _ReferenceTableConfig('referral_purpose', 'Referral Purpose'),
    _ReferenceTableConfig('station_ref', 'Station'),
    _ReferenceTableConfig('relationship_type', 'Relationship Type'),
    _ReferenceTableConfig('visit_reason', 'Visit Reason'),
    _ReferenceTableConfig('drug_ref', 'Drug'),
    _ReferenceTableConfig('special_note_ref', 'Special Note'),
    _ReferenceTableConfig('intubation_method_ref', 'Intubation Method'),
    _ReferenceTableConfig('respiration_mode_ref', 'Respiration Mode'),
    _ReferenceTableConfig(
      'ambulance_reference_items',
      'Ambulance Reference Item',
    ),
    _ReferenceTableConfig(
      'ambulance_treatment_categories',
      'Ambulance Treatment Category',
    ),
    _ReferenceTableConfig(
      'ambulance_treatment_items',
      'Ambulance Treatment Item',
    ),
  ];

  final TextEditingController _searchController = TextEditingController();

  late _ReferenceTableConfig _selectedTable;
  List<_TableColumnSchema> _schema = [];
  List<Map<String, dynamic>> _rows = [];
  bool _isLoading = true;
  bool _isSyncing = false;
  String _search = '';
  int _loadRequestId = 0;

  @override
  void initState() {
    super.initState();
    _selectedTable = _tables.first;
    _searchController.addListener(() {
      setState(() => _search = _searchController.text.trim().toLowerCase());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSelectedTable();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String? get _primaryKeyColumn {
    for (final column in _schema) {
      if (column.isPrimaryKey) return column.name;
    }
    return null;
  }

  bool get _hasIsActiveColumn {
    return _schema.any((c) => c.name == 'is_active');
  }

  List<_TableColumnSchema> get _editableColumns {
    const excluded = {
      'created_at',
      'updated_at',
      'last_modified',
      'sync_status',
      'device_id',
      'remote_id',
    };

    return _schema
        .where((c) => !c.isPrimaryKey && !excluded.contains(c.name))
        .toList();
  }

  Future<void> _loadSelectedTable() async {
    final db = context.read<AppDatabase>();
    final tableConfig = _selectedTable;
    final requestId = ++_loadRequestId;

    if (mounted) {
      setState(() => _isLoading = true);
    }
    try {
      final schemaRows = await db
          .customSelect('PRAGMA table_info(${tableConfig.table})')
          .get();
      if (!mounted || requestId != _loadRequestId) return;
      final schema = schemaRows
          .map(
            (row) => _TableColumnSchema(
              name: row.read<String>('name'),
              type: row.read<String>('type'),
              isNullable: row.read<int>('notnull') == 0,
              hasDefaultValue: row.readNullable<String>('dflt_value') != null,
              isPrimaryKey: row.read<int>('pk') == 1,
            ),
          )
          .toList();

      final pk = schema.firstWhere(
        (c) => c.isPrimaryKey,
        orElse: () => const _TableColumnSchema.empty(),
      );
      final hasSort = schema.any((c) => c.name == 'sort_order');
      final orderBy = hasSort
          ? 'sort_order ASC, ${pk.name.isEmpty ? 'rowid' : pk.name} ASC'
          : '${pk.name.isEmpty ? 'rowid' : pk.name} ASC';

      final rows = await db
          .customSelect('SELECT * FROM ${tableConfig.table} ORDER BY $orderBy')
          .get();
      if (!mounted || requestId != _loadRequestId) return;

      setState(() {
        _schema = schema;
        _rows = rows.map((row) => Map<String, dynamic>.from(row.data)).toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Load failed: $e')));
      setState(() {
        _schema = [];
        _rows = [];
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  dynamic _toSyncJsonValue(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) {
      return value.toUtc().millisecondsSinceEpoch;
    }
    if (value is Uint8List) {
      return value.toList();
    }
    if (value is List) {
      return value.map(_toSyncJsonValue).toList();
    }
    if (value is Map) {
      return value.map(
        (key, val) => MapEntry(key.toString(), _toSyncJsonValue(val)),
      );
    }
    return value;
  }

  Map<String, dynamic> _buildSyncPayload(Map<String, dynamic> row) {
    final payload = <String, dynamic>{};
    for (final entry in row.entries) {
      payload[entry.key] = _toSyncJsonValue(entry.value);
    }
    payload['lastModified'] = DateTime.now().toUtc().millisecondsSinceEpoch;
    return payload;
  }

  Future<Map<String, dynamic>?> _loadRowByPrimaryKey(
    AppDatabase db,
    String tableName,
    String primaryKeyColumn,
    dynamic primaryKeyValue,
  ) async {
    final rows = await db
        .customSelect(
          'SELECT * FROM $tableName WHERE $primaryKeyColumn = ? LIMIT 1',
          variables: [Variable(primaryKeyValue)],
        )
        .get();
    if (rows.isEmpty) return null;
    return Map<String, dynamic>.from(rows.first.data);
  }

  Future<Map<String, dynamic>?> _loadLatestRow(
    AppDatabase db,
    String tableName,
    String primaryKeyColumn,
  ) async {
    final rows = await db
        .customSelect(
          'SELECT * FROM $tableName ORDER BY $primaryKeyColumn DESC LIMIT 1',
        )
        .get();
    if (rows.isEmpty) return null;
    return Map<String, dynamic>.from(rows.first.data);
  }

  Future<void> _queueReferenceUpsert({
    required String tableName,
    required String primaryKeyColumn,
    required Map<String, dynamic> row,
  }) async {
    final recordId = _toInt(row[primaryKeyColumn]);
    if (recordId == null) {
      debugPrint(
        'Reference queue skip(upsert): $tableName.$primaryKeyColumn is null/invalid',
      );
      return;
    }
    final payload = _buildSyncPayload(row);
    debugPrint('Reference queue upsert: $tableName#$recordId');
    await context.read<SyncServiceProvider>().markAsPending(
      tableName: tableName,
      recordId: recordId,
      operation: 'upsert',
      data: payload,
    );
  }

  Future<void> _queueReferenceDelete({
    required String tableName,
    required String primaryKeyColumn,
    required Map<String, dynamic> row,
  }) async {
    final recordId = _toInt(row[primaryKeyColumn]);
    if (recordId == null) {
      debugPrint(
        'Reference queue skip(delete): $tableName.$primaryKeyColumn is null/invalid',
      );
      return;
    }
    final payload = _buildSyncPayload(row);
    debugPrint('Reference queue delete: $tableName#$recordId');
    await context.read<SyncServiceProvider>().markAsPending(
      tableName: tableName,
      recordId: recordId,
      operation: 'delete',
      data: payload,
    );
  }

  Future<bool> _pushPendingReferenceChanges({bool showError = true}) async {
    try {
      await context.read<SyncServiceProvider>().pushPendingChanges();
      return true;
    } catch (e) {
      if (showError && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Push failed: $e')));
      }
      return false;
    }
  }

  Future<void> _syncReferenceTables() async {
    setState(() => _isSyncing = true);
    try {
      final service = context.read<ReferenceService>();
      final pushed = await _pushPendingReferenceChanges(showError: false);
      if (!pushed) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pending local changes push failed, sync canceled'),
          ),
        );
        return;
      }

      final result = await service.syncReferenceTablesFromServer();

      if (!mounted) return;
      await _loadSelectedTable();

      final message = result.success
          ? (result.changed
                ? 'Synced: ${result.tableCount} tables, ${result.rowCount} rows'
                : 'No server changes')
          : 'Sync failed: ${result.errorMessage ?? 'unknown error'}';

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _addOption() async {
    final tableName = _selectedTable.table;
    final primaryKeyColumn = _primaryKeyColumn;
    if (primaryKeyColumn == null) return;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _AddReferenceOptionDialog(
        tableLabel: _selectedTable.label,
        columns: _editableColumns,
      ),
    );

    if (result == null || result.isEmpty) return;
    if (!mounted) return;

    final db = context.read<AppDatabase>();
    final columns = result.keys.toList();
    final placeholders = List.filled(columns.length, '?').join(', ');
    final args = columns.map((key) => result[key]).toList();

    try {
      await db.customStatement(
        'INSERT INTO $tableName (${columns.join(', ')}) '
        'VALUES ($placeholders)',
        args,
      );
      final inserted = await _loadLatestRow(db, tableName, primaryKeyColumn);
      if (inserted != null) {
        await _queueReferenceUpsert(
          tableName: tableName,
          primaryKeyColumn: primaryKeyColumn,
          row: inserted,
        );
        final pushed = await _pushPendingReferenceChanges();
        if (!pushed && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added locally, upload pending')),
          );
        }
      } else {
        debugPrint(
          'Reference add warning: unable to fetch inserted row for $tableName',
        );
      }
      await _reloadReferencesAndRefreshTable();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Added successfully')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Add failed: $e')));
    }
  }

  Future<void> _toggleDisable(Map<String, dynamic> row) async {
    final db = context.read<AppDatabase>();
    final tableName = _selectedTable.table;
    final primaryKeyColumn = _primaryKeyColumn;
    if (primaryKeyColumn == null) return;

    final pkValue = row[primaryKeyColumn];
    if (pkValue == null) return;

    try {
      if (_hasIsActiveColumn) {
        final current = row['is_active'];
        final isActive = current == true || current == 1 || current == '1';
        final next = isActive ? 0 : 1;
        await db.customStatement(
          'UPDATE $tableName SET is_active = ? WHERE $primaryKeyColumn = ?',
          [next, pkValue],
        );
        final updatedRow = await _loadRowByPrimaryKey(
          db,
          tableName,
          primaryKeyColumn,
          pkValue,
        );
        if (updatedRow != null) {
          await _queueReferenceUpsert(
            tableName: tableName,
            primaryKeyColumn: primaryKeyColumn,
            row: updatedRow,
          );
          final pushed = await _pushPendingReferenceChanges();
          if (!pushed && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Updated locally, upload pending')),
            );
          }
        } else {
          debugPrint(
            'Reference toggle warning: unable to fetch updated row for $tableName#$pkValue',
          );
        }
      } else {
        final allowDelete = await _confirmDeleteFallback();
        if (!allowDelete) return;
        await db.customStatement(
          'DELETE FROM $tableName WHERE $primaryKeyColumn = ?',
          [pkValue],
        );
        await _queueReferenceDelete(
          tableName: tableName,
          primaryKeyColumn: primaryKeyColumn,
          row: row,
        );
        final pushed = await _pushPendingReferenceChanges();
        if (!pushed && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Deleted locally, upload pending')),
          );
        }
      }

      await _reloadReferencesAndRefreshTable();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Disable failed: $e')));
    }
  }

  Future<void> _reloadReferencesAndRefreshTable() async {
    final service = context.read<ReferenceService>();
    await service.reloadBasicReferences();
    await service.reloadTreatmentReferences();
    await _loadSelectedTable();
  }

  Future<bool> _confirmDeleteFallback() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Disable Option'),
              content: const Text(
                'This table has no is_active column.\n'
                'Disable will remove this row. Continue?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Continue'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  bool _isDisabledRow(Map<String, dynamic> row) {
    if (!_hasIsActiveColumn) return false;
    final value = row['is_active'];
    return value == false || value == 0 || value == '0';
  }

  String _titleForRow(Map<String, dynamic> row) {
    const preferredKeys = ['name', 'title', 'code'];
    for (final key in preferredKeys) {
      final value = row[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    final pk = _primaryKeyColumn;
    return pk == null ? 'Unknown' : 'ID ${row[pk]}';
  }

  String _subtitleForRow(Map<String, dynamic> row) {
    final pk = _primaryKeyColumn;
    final idText = pk == null ? '' : '$pk=${row[pk]}';
    final code = row['code'];
    if (code == null || code.toString().trim().isEmpty) return idText;
    if (idText.isEmpty) return 'code=$code';
    return '$idText   code=$code';
  }

  List<Map<String, dynamic>> get _filteredRows {
    if (_search.isEmpty) return _rows;
    return _rows.where((row) {
      return row.values.any((value) {
        if (value == null) return false;
        return value.toString().toLowerCase().contains(_search);
      });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: const Text('Reference Settings'),
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: Row(
        children: [
          _buildTableSidebar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildTableSidebar() {
    return Container(
      width: 290,
      decoration: const BoxDecoration(
        color: cardBg,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: _isSyncing ? null : _syncReferenceTables,
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size.fromHeight(44),
              ),
              icon: _isSyncing
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.sync),
              label: Text(_isSyncing ? 'Syncing...' : 'Sync Reference'),
            ),
          ),
          const Divider(height: 1, color: borderColor),
          Expanded(
            child: ListView.builder(
              itemCount: _tables.length,
              itemBuilder: (context, index) {
                final item = _tables[index];
                final selected = item.table == _selectedTable.table;
                return ListTile(
                  dense: true,
                  selected: selected,
                  selectedTileColor: primaryColor.withValues(alpha: 0.08),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: selected ? primaryColor : textDark,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    item.table,
                    style: const TextStyle(fontSize: 11, color: textMuted),
                  ),
                  onTap: () {
                    if (_selectedTable.table == item.table) return;
                    _searchController.clear();
                    setState(() {
                      _selectedTable = item;
                      _search = '';
                    });
                    _loadSelectedTable();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedTable.label,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _loadSelectedTable,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Refresh'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _isLoading ? null : _addOption,
                style: FilledButton.styleFrom(backgroundColor: primaryColor),
                icon: const Icon(Icons.add),
                label: const Text('Add Option'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _selectedTable.table,
            style: const TextStyle(color: textMuted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search in current table',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: borderColor),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildRowsList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowsList() {
    final rows = _filteredRows;
    if (rows.isEmpty) {
      return Center(
        child: Text(
          _rows.isEmpty
              ? 'No data in this table'
              : 'No matching data, clear search to view all',
          style: const TextStyle(color: textMuted),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: rows.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final row = rows[index];
        final disabled = _isDisabledRow(row);
        final supportsSoftDisable = _hasIsActiveColumn;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _titleForRow(row),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: disabled ? textMuted : textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _subtitleForRow(row),
                      style: const TextStyle(fontSize: 12, color: textMuted),
                    ),
                  ],
                ),
              ),
              if (_hasIsActiveColumn)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: disabled
                        ? Colors.orange.withValues(alpha: 0.15)
                        : Colors.green.withValues(alpha: 0.15),
                  ),
                  child: Text(
                    disabled ? 'Disabled' : 'Active',
                    style: TextStyle(
                      fontSize: 12,
                      color: disabled
                          ? Colors.orange.shade900
                          : Colors.green.shade900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              TextButton.icon(
                onPressed: () => _toggleDisable(row),
                icon: Icon(
                  supportsSoftDisable
                      ? (disabled ? Icons.toggle_on : Icons.toggle_off)
                      : Icons.delete_outline,
                ),
                label: Text(
                  supportsSoftDisable
                      ? (disabled ? 'Enable' : 'Disable')
                      : 'Disable',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddReferenceOptionDialog extends StatefulWidget {
  final String tableLabel;
  final List<_TableColumnSchema> columns;

  const _AddReferenceOptionDialog({
    required this.tableLabel,
    required this.columns,
  });

  @override
  State<_AddReferenceOptionDialog> createState() =>
      _AddReferenceOptionDialogState();
}

class _AddReferenceOptionDialogState extends State<_AddReferenceOptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _boolValues = {};

  @override
  void initState() {
    super.initState();
    for (final column in widget.columns) {
      if (_isBoolColumn(column)) {
        _boolValues[column.name] = column.name == 'is_active';
      } else {
        _controllers[column.name] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _isBoolColumn(_TableColumnSchema column) {
    final type = column.type.toUpperCase();
    return type.contains('BOOL') || column.name.startsWith('is_');
  }

  bool _isIntColumn(_TableColumnSchema column) {
    return column.type.toUpperCase().contains('INT');
  }

  bool _isRealColumn(_TableColumnSchema column) {
    final type = column.type.toUpperCase();
    return type.contains('REAL') || type.contains('DOUBLE');
  }

  String _label(String columnName) {
    return columnName
        .split('_')
        .map((part) {
          if (part.isEmpty) return part;
          return part[0].toUpperCase() + part.substring(1);
        })
        .join(' ');
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final payload = <String, dynamic>{};
    for (final column in widget.columns) {
      if (_isBoolColumn(column)) {
        final value = _boolValues[column.name];
        if (value != null) {
          payload[column.name] = value ? 1 : 0;
        }
        continue;
      }

      final raw = _controllers[column.name]?.text.trim() ?? '';
      if (raw.isEmpty) {
        continue;
      }

      if (_isIntColumn(column)) {
        final value = int.tryParse(raw);
        if (value == null) return;
        payload[column.name] = value;
        continue;
      }

      if (_isRealColumn(column)) {
        final value = double.tryParse(raw);
        if (value == null) return;
        payload[column.name] = value;
        continue;
      }

      payload[column.name] = raw;
    }

    Navigator.of(context).pop(payload);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Option - ${widget.tableLabel}'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.columns.map((column) {
                final required = !column.isNullable && !column.hasDefaultValue;

                if (_isBoolColumn(column)) {
                  return SwitchListTile(
                    title: Text(_label(column.name)),
                    value: _boolValues[column.name] ?? false,
                    onChanged: (value) {
                      setState(() => _boolValues[column.name] = value);
                    },
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: _controllers[column.name],
                    keyboardType: _isIntColumn(column)
                        ? TextInputType.number
                        : (_isRealColumn(column)
                              ? const TextInputType.numberWithOptions(
                                  decimal: true,
                                )
                              : TextInputType.text),
                    decoration: InputDecoration(
                      labelText: _label(column.name),
                      hintText: required ? 'Required' : 'Optional',
                    ),
                    validator: (value) {
                      final text = (value ?? '').trim();
                      if (required && text.isEmpty) {
                        return '${_label(column.name)} is required';
                      }
                      if (text.isEmpty) return null;
                      if (_isIntColumn(column) && int.tryParse(text) == null) {
                        return 'Must be an integer';
                      }
                      if (_isRealColumn(column) &&
                          double.tryParse(text) == null) {
                        return 'Must be a number';
                      }
                      return null;
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}

class _ReferenceTableConfig {
  final String table;
  final String label;

  const _ReferenceTableConfig(this.table, this.label);
}

class _TableColumnSchema {
  final String name;
  final String type;
  final bool isNullable;
  final bool hasDefaultValue;
  final bool isPrimaryKey;

  const _TableColumnSchema({
    required this.name,
    required this.type,
    required this.isNullable,
    required this.hasDefaultValue,
    required this.isPrimaryKey,
  });

  const _TableColumnSchema.empty()
    : name = '',
      type = '',
      isNullable = true,
      hasDefaultValue = false,
      isPrimaryKey = false;
}
