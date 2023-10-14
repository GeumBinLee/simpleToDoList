import 'package:flutter/material.dart';

import 'main.dart';

/// Bucket 담당
class ToDoList extends ChangeNotifier {
  List<Bucket> toDoList = [];

  // bucket 추가
  void createToDoList(String job) {
    toDoList.add(Bucket(job, false));
    notifyListeners(); // 모든 Consumer<bucketService>의 builder 함수 호출
  }

  void updateToDoList(Bucket bucket, int index) {
    toDoList[index] = bucket;
    notifyListeners();
  }

  void deleteToDoList(int index) {
    toDoList.removeAt(index);
    notifyListeners();
  }
}
