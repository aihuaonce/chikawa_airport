// lib/maintain/maintain_menu_sheet.dart
import 'package:flutter/material.dart';
import 'generic_list_page.dart';
import 'simple_list_page.dart';


class MenuSection {
  final String title;         // 群組標題（不可點）
  final List<String> entries; // 這組底下可點的項目
  const MenuSection(this.title, this.entries);
}

class MaintainMenuSheet extends StatelessWidget {
  const MaintainMenuSheet({super.key});

  // === 這裡把你的清單分群 ===c
  List<MenuSection> get sections => const [
    MenuSection('各式單據內列表', [
      // （這組我暫時沒有子項，若未來要補就加在這）
    ]),
    MenuSection('個人資料頁面', [
      '性別', '為何至機場', '國籍', '其他國籍',
    ]),
    MenuSection('飛航記錄頁面', [
      '航空公司', '其他航空公司', '啟程地', '經過地', '目的地', '旅行狀態',
    ]),
    MenuSection('通報單位', [
      '通報單位',
    ]),
    MenuSection('10分鐘內未到達的原因', [
      '10分鐘內未到達的原因',
    ]),
    // 事故地點分類/列表
    MenuSection('事故地點分類列表', ['事故地點分類', '事故地點分類2']),
    MenuSection('事故地點列表', [
      // 第一航廈
      '事故地點-第一航廈-1', '事故地點-第一航廈-2', '事故地點-第一航廈-3', '事故地點-第一航廈-4',
      // 第二航廈
      '事故地點-第二航廈-1', '事故地點-第二航廈-2', '事故地點-第二航廈-3', '事故地點-第二航廈-4',
      // 遠端機坪
      '事故地點-遠端機坪-1','事故地點-遠端機坪-2','事故地點-遠端機坪-3','事故地點-遠端機坪-4',
      // 貨運站/機坪其他
      '事故地點-貨運站/機坪其他-1','事故地點-貨運站/機坪其他-2','事故地點-貨運站/機坪其他-3','事故地點-貨運站/機坪其他-4',
      // 其他
      '事故地點-機場旅館','事故地點-飛機機艙內',
    ]),
    // 處置紀錄頁面
    MenuSection('處置紀錄頁面', [
      '協助篩檢方式','左瞳孔收縮情況','右瞳孔收縮情況','過去病史','藥物過敏','照片類別','ICD-10',
      '診斷類別','檢傷分類','現場處置','處理摘要','插管方式','氧氣使用','診斷書種類','後續結果',
      '轉院醫院','通關方式','緊急通關方式','救護車單位','民間救護車單位','消防隊救護車單位',
      '救護車轉送醫院','醫囑片語','負責醫師','隨行護理師','EMT','特別註記',
    ]),
    // 主訴列表
    MenuSection('主訴列表', [
      '外傷','頭部非外傷','胸部非外傷','腹部非外傷','四肢非外傷','其他非外傷',
    ]),
    // 藥物
    MenuSection('藥物紀錄表', [
      '藥物用量單位','藥物使用頻率-1','藥物使用頻率-2',
      // 藥物列表（示意，先列幾個，之後可繼續補）
      '噴劑/吸入劑','水劑-1','水劑-2','點滴注射-1','點滴注射-2',
      '藥膏-1','藥膏-2','眼藥水','耳滴劑','肛門塞劑',
      '注射藥物-1','注射藥物-2','注射藥物-3','注射藥物-4',
      '口服藥物-1','口服藥物-2','口服藥物-3','口服藥物-4',
    ]),
    // 醫療費用頁面
    MenuSection('醫療費用頁面', [
      '收費表PDF檔案網址','收費匯率表','醫療費用收取方式','醫療費用非自付方式收款狀態','自付方式','貨幣清單',
    ]),
    // 電傳文件頁面
    MenuSection('電傳文件頁面', [
      '桃機營運安全處','聯新機場醫療中心',
    ]),
    // 轉診單頁面
    MenuSection('轉診單頁面', [
      '轉診目的','轉診科別',
    ]),
    // 護理紀錄表頁面
    MenuSection('護理紀錄表頁面', [
      '護理紀錄片語',
    ]),
    // 常見症狀列表
    MenuSection('常見症狀列表', [
      '頭部症狀Top10','腹部症狀Top10','左臂症狀Top10','右小腿症狀Top10',
    ]),
    // 其他列表
    MenuSection('其他列表', ['處置']),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, controller) {
          return Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: ListView.builder(
              controller: controller,
              itemCount: sections.length,
              itemBuilder: (context, i) {
                final s = sections[i];
                return ExpansionTile(
                  title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  children: [
                    for (final e in s.entries)
                      ListTile(
                        title: Text(e),
                       onTap: () {
                              Navigator.pop(context);
                              final items = seedData[e] ?? const []; // 如果沒設定就給空清單
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SimpleListPage(
                                    title: e,
                                    initialItems: items,
                                  ),
                                ),
                              );
                            },

                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
const Map<String, List<String>> seedData = {
  '性別': ['男', '女'],
  '為何至機場': ['航空公司機組員', '旅客/民眾', '機場內部員工'],
  '航空公司': [
    'BR長榮航空','CI中華航空','CX國泰航空','UA聯合航空',
    'KL荷蘭航空','CZ中國南方航空','IT台灣虎航',
    'EK阿聯酋航空','CA中國國際航空','其他航空公司'
  ],
  // 之後要補的清單就繼續加在這裡
};
