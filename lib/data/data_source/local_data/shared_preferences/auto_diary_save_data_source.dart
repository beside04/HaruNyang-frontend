import 'dart:convert';

import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoDiarySaveDataSource {
  Future<void> saveDiary(String date, DiaryDetailData diary) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(diary);
    prefs.setString(date, jsonString);
  }

  Future<List<DiaryDetailData>> loadDiariesByMonth(String year, String month) async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    final monthPattern = '$year-$month-';
    List<DiaryDetailData> monthlyDiaries = [];

    for (var key in allKeys) {
      if (key.startsWith(monthPattern)) {
        String? diaryJsonString = prefs.getString(key);
        if (diaryJsonString != null) {
          Map<String, dynamic> diaryMap = json.decode(diaryJsonString);
          DiaryDetailData diary = DiaryDetailData.fromJson(diaryMap);
          monthlyDiaries.add(diary);
        }
      }
    }

    return monthlyDiaries;
  }

  Future<String?> getDiary(String date) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(date);
  }

  Future<void> deleteDiary(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(date);
  }

  // 다이어리 데이터만 삭제하도록 수정된 메서드
  Future<void> deleteAllDiary() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    for (var key in allKeys) {
      if (_isDiaryKey(key)) {
        await prefs.remove(key);
      }
    }
  }

  // 다이어리 키인지 확인하는 헬퍼 메서드
  bool _isDiaryKey(String key) {
    final RegExp diaryKeyPattern = RegExp(r'^\d{4}-\d{2}-\d{2}'); // YYYY-MM-DD 형식의 키
    return diaryKeyPattern.hasMatch(key);
  }
}
