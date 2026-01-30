import 'dart:async';
import 'package:flutter/material.dart';

class ReferenceSearchSheet<T> extends StatefulWidget {
  final String title;
  final String hintText;
  final Future<List<T>> Function(String query) searchFunction;
  final Widget Function(BuildContext context, T item, bool isSelected) itemBuilder;
  final T? initialSelection;
  final bool Function(T item, T? selected)? isSelectedComparator;

  const ReferenceSearchSheet({
    super.key,
    required this.title,
    this.hintText = 'Search...',
    required this.searchFunction,
    required this.itemBuilder,
    this.initialSelection,
    this.isSelectedComparator,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String hintText = 'Search...',
    required Future<List<T>> Function(String query) searchFunction,
    required Widget Function(BuildContext context, T item, bool isSelected) itemBuilder,
    T? initialSelection,
    bool Function(T item, T? selected)? isSelectedComparator,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ReferenceSearchSheet<T>(
        title: title,
        hintText: hintText,
        searchFunction: searchFunction,
        itemBuilder: itemBuilder,
        initialSelection: initialSelection,
        isSelectedComparator: isSelectedComparator,
      ),
    );
  }

  @override
  State<ReferenceSearchSheet<T>> createState() => _ReferenceSearchSheetState<T>();
}

class _ReferenceSearchSheetState<T> extends State<ReferenceSearchSheet<T>> {
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  final TextEditingController _searchController = TextEditingController();
  List<T> _results = [];
  bool _isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _performSearch('');
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
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final results = await widget.searchFunction(query);
      if (mounted) {
        setState(() {
          _results = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Search failed: $e');
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
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
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
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
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
                                Icons.search_off,
                                size: 48,
                                color: textMuted.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No results found',
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
                            final isSelected = widget.isSelectedComparator != null
                                ? widget.isSelectedComparator!(item, widget.initialSelection)
                                : item == widget.initialSelection;
                            
                            return InkWell(
                              onTap: () => Navigator.pop(context, item),
                              child: widget.itemBuilder(context, item, isSelected),
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }
}
