import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/db/database.dart';
import '../../data/models/medical/treatment_view.dart';

class DrugSearchSheet extends StatefulWidget {
  final String title;
  final String initialValue;
  final TreatmentViewModel viewModel;

  const DrugSearchSheet({
    super.key,
    required this.title,
    required this.initialValue,
    required this.viewModel,
  });

  static Future<DrugRefData?> show(
    BuildContext context, {
    required String title,
    String initialValue = '',
    required TreatmentViewModel viewModel,
  }) async {
    return showModalBottomSheet<DrugRefData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DrugSearchSheet(
        title: title,
        initialValue: initialValue,
        viewModel: viewModel,
      ),
    );
  }

  @override
  State<DrugSearchSheet> createState() => _DrugSearchSheetState();
}

class _DrugSearchSheetState extends State<DrugSearchSheet> {
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  final TextEditingController _searchController = TextEditingController();
  List<DrugRefData> _results = [];
  bool _isLoading = false;
  Timer? _debounceTimer;

  // Category Filtering
  List<String> _categories = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _initCategories();
    // Initially load all drugs or perform search if initialValue is provided
    if (widget.initialValue.isNotEmpty) {
      _searchController.text = widget.initialValue;
      _performSearch(widget.initialValue);
    } else {
      _performSearch('');
    }
  }

  void _initCategories() {
    final drugs = widget.viewModel.refService.drugList;
    _categories = drugs.map((d) => d.category).toSet().toList()..sort();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isLoading = true);

    try {
      var results = await widget.viewModel.searchDrugs(query);

      // Filter by category if selected
      if (_selectedCategory != null) {
        results =
            results.where((d) => d.category == _selectedCategory).toList();
      }

      if (mounted) {
        setState(() {
          _results = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Drug search failed: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: textDark),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search field
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: '輸入藥物名稱...',
                      hintStyle: TextStyle(
                        color: textMuted.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Icons.search, color: primaryColor),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: textMuted),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: bgField,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),

                  // Category Filter
                  if (_categories.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          _buildCategoryChip('全部', null),
                          ..._categories.map((c) => _buildCategoryChip(c, c)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Results
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : _results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medication_outlined,
                            size: 48,
                            color: textMuted.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '未找到符合的藥物',
                            style: TextStyle(
                              color: textMuted.withValues(alpha: 0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final item = _results[index];
                        return _buildResultItem(item);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryChip(String label, String? category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : textDark,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedColor: primaryColor,
        backgroundColor: bgField,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : borderColor,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        onSelected: (selected) {
          setState(() {
            if (category == null) {
              _selectedCategory = null;
            } else {
              _selectedCategory = isSelected ? null : category;
            }
            _performSearch(_searchController.text);
          });
        },
      ),
    );
  }

  Widget _buildResultItem(DrugRefData item) {
    final isSelected = widget.initialValue == item.name;

    return InkWell(
      onTap: () => Navigator.pop(context, item),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.05)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: borderColor.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          children: [
            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : bgField,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? primaryColor : borderColor,
                ),
              ),
              child: Text(
                item.category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Drug Name
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 14,
                  color: textDark,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: primaryColor, size: 20),
          ],
        ),
      ),
    );
  }
}
