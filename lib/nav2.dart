import 'dart:convert';
// import 'package:chikawa_airport/nav3.dart'; // 【移除】
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AccidentRecord.dart';
import 'PersonalInformation.dart';
import 'data/models/patient_data.dart';
import 'data/db/daos.dart';
import 'providers/routes_config.dart';
import 'widgets/nav_common.dart';
import 'l10n/app_translations.dart';

mixin SavableStateMixin<T extends StatefulWidget> on State<T> {
  Future<void> saveData();
}

class Nav2Page extends StatefulWidget {
  final int visitId;
  final int initialIndex;

  const Nav2Page({super.key, required this.visitId, this.initialIndex = 0});

  @override
  State<Nav2Page> createState() => _Nav2PageState();
}

class _Nav2PageState extends State<Nav2Page> with WidgetsBindingObserver {
  late int currentIndex;
  final Map<int, GlobalKey> _pageKeys = {};
  final Map<int, Widget> _cachedPages = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addObserver(this);

    // 初始化所有頁面的 GlobalKey
    _initializePageKeys();

    // 延遲建立頁面，確保 context 準備好
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buildAllPages();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _initializePageKeys() {
    for (int i = 0; i < routeItems.length; i++) {
      _pageKeys[i] = GlobalKey();
    }
  }

  void _buildAllPages() {
    if (!mounted) return;

    setState(() {
      for (int i = 0; i < routeItems.length; i++) {
        try {
          _cachedPages[i] = routeItems[i].builder(
            widget.visitId,
            _pageKeys[i]!,
          );
        } catch (e) {}
      }
    });
  }

  Future<void> _saveCurrentPage() async {
    if (_isSaving) return;

    final key = _pageKeys[currentIndex];
    if (key?.currentState == null) return;

    try {
      await _savePageByIndex(currentIndex);
    } catch (e) {}
  }

  Future<bool> _savePageByIndex(int index) async {
    final key = _pageKeys[index];
    final pageName = routeItems[index].label;

    if (key?.currentState == null) {
      return false;
    }

    try {
      final state = key!.currentState!;

      // 檢查是否有 SavableStateMixin
      if (state is SavableStateMixin) {
        await (state as SavableStateMixin).saveData();
        return true;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveAllPages() async {
    final t = AppTranslations.of(context);

    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    bool hasErrors = false;
    List<String> errorMessages = [];
    List<String> successMessages = [];

    try {
      // 首先確保所有頁面都已建立
      if (_cachedPages.length != routeItems.length) {
        _buildAllPages();
        // 等待頁面建立完成
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // 遍歷所有頁面並儲存
      for (int i = 0; i < routeItems.length; i++) {
        final pageName = routeItems[i].label;

        try {
          bool success = await _savePageByIndex(i);
          if (success) {
            successMessages.add(pageName);
          } else {
            hasErrors = true;
            errorMessages.add('$pageName: ${t.saveFailed}');
          }
        } catch (e) {
          hasErrors = true;
          errorMessages.add('$pageName: ${e.toString()}');
        }

        // 每個頁面之間稍作延遲
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // 儲存公共資料
      try {
        await _saveCommonData();
        successMessages.add(t.commonData);
      } catch (e) {
        hasErrors = true;
        errorMessages.add('${t.commonData}: ${e.toString()}');
      }

      // 儲存完成後，清除快取並重建所有頁面
      debugPrint("🔄 清除頁面快取並重建...");
      _cachedPages.clear();
      _pageKeys.clear();
      _initializePageKeys();

      // 延遲一下再重建，確保狀態已清除
      await Future.delayed(const Duration(milliseconds: 200));
      _buildAllPages();
    } catch (e) {
      hasErrors = true;
      errorMessages.add('系統錯誤: ${e.toString()}');
    }

    setState(() {
      _isSaving = false;
    });

    // 顯示結果
    if (!mounted) return;

    if (hasErrors) {
      _showErrorDialog(t, errorMessages, successMessages);
    } else {
      _showSuccessMessage(t);
      // 延遲一下再返回，讓用戶看到成功訊息
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  void _showErrorDialog(
    AppTranslations t,
    List<String> errors,
    List<String> successes,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.saveResult),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (successes.isNotEmpty) ...[
                  Text(
                    t.savedSuccessfully,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  ...successes.map((msg) => Text('✅ $msg')),
                  const SizedBox(height: 10),
                ],
                if (errors.isNotEmpty) ...[
                  Text(
                    t.saveFailedLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  ...errors.map((msg) => Text('❌ $msg')),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.confirm),
            ),
            if (errors.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _saveAllPages();
                },
                child: Text(t.retry),
              ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage(AppTranslations t) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.saveSuccess),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveCommonData() async {
    final patientData = context.read<PatientData>();
    final patientDao = context.read<PatientProfilesDao>();
    final visitsDao = context.read<VisitsDao>();

    // ✅ 正確做法：一行程式碼，呼叫您在 PatientData 中完美封裝好的方法
    await patientData.saveToDatabase(widget.visitId, patientDao, visitsDao);

    // 儲存完畢後清空 PatientData
    patientData.clear();
  }

  void _onPageChanged(int index) {
    if (index == currentIndex) return;

    // 在切換頁面前儲存當前頁面
    _saveCurrentPage().then((_) {
      if (mounted) {
        setState(() {
          currentIndex = index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            // 導航列
            Row(
              children: [
                // 左側導航按鈕
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: routeItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: NavPillButton(
                            label: item.label,
                            active: currentIndex == index,
                            onTap: () => _onPageChanged(index),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 右側儲存按鈕
                _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.save),
                        tooltip: '儲存所有頁面',
                        onPressed: _saveAllPages,
                      ),
              ],
            ),
            // 【移除】Nav3Section
            // const Padding(
            //   padding: EdgeInsets.only(top: 12),
            //   child: Nav3Section(),
            // ),
            const SizedBox(height: 12), // 【新增】替代的間距
            // 頁面內容
            Expanded(
              child: _cachedPages.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : IndexedStack(
                      index: currentIndex,
                      children: List.generate(
                        routeItems.length,
                        (index) => _cachedPages[index] ?? Container(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 當應用程式進入背景時自動儲存
    if (state == AppLifecycleState.paused) {
      _saveCurrentPage();
    }
  }
}
