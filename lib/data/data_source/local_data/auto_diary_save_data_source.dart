import 'dart:convert';

import 'package:frontend/domain/model/diary/diary_data.dart';
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

  Future<void> deleteAllDiary() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
