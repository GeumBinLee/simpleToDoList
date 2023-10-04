import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

/// 버킷 클래스
class Bucket {
  String job; // 할 일
  bool isDone; // 완료 여부

  Bucket(this.job, this.isDone); // 생성자
}

/// 홈 페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Bucket> bucketList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "TO DO LIST",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.pink[100],
      ),
      body: bucketList.isEmpty
          ? Center(child: Text("할 일을 작성해 주세요."))
          : ListView.builder(
              itemCount: bucketList.length, // bucketList 개수 만큼 보여주기
              itemBuilder: (context, index) {
                Bucket bucket = bucketList[index]; // index에 해당하는 bucket 가져오기

                return ListTile(
                  // 버킷 리스트 할 일
                  title: Text(
                    bucket.job,
                    style: TextStyle(
                      fontSize: 15,
                      color: bucket.isDone ? Colors.grey : Colors.black,
                    ),
                  ),
                  leading: IconButton(
                    icon: bucket.isDone
                        ? Icon(CupertinoIcons.checkmark_alt_circle_fill)
                        : Icon(CupertinoIcons.checkmark_alt_circle),
                    color: bucket.isDone ? Colors.red : Colors.black,
                    onPressed: () {
                      //체크 버튼 클릭 시
                      print('$bucket : 체크하기');
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 수정 아이콘 버튼
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.pencil,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // 수정 버튼 클릭시
                        },
                      ),
                      // 삭제 아이콘 버튼
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.delete,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // 삭제 버튼 클릭시
                          showDeleteDialog(context, index);
                        },
                      )
                    ],
                  ),
                  onTap: () {
                    // 아이템 클릭 시
                    setState(() {
                      bucket.isDone = !bucket.isDone;
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[100],
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          // + 버튼 클릭시 버킷 생성 페이지로 이동
          String? job = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreatePage()),
          );
          if (job != null) {
            setState(() {
              // bucketList.add(job); // 원래 코드
              Bucket newBucket = Bucket(job, false);
              bucketList.add(newBucket); // 버킷 리스트에 추가
            });
          }
        },
      ),
    );
  }

  void showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("정말로 삭제하시겠습니까?"),
          actions: [
            // 취소 버튼
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "취소",
                style: TextStyle(color: Colors.black),
              ),
            ),
            // 확인 버튼
            TextButton(
              onPressed: () {
                setState(() {
                  // index에 해당하는 항목 삭제
                  bucketList.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text(
                "확인",
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 버킷 생성 페이지
class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  // TextField의 값을 가져올 때 사용합니다.
  TextEditingController textController = TextEditingController();

  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "할 일 작성",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.pink[100],
        // 뒤로가기 버튼
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 텍스트 입력창
            TextField(
              onSubmitted: (_) {
                String job =
                    textController.text; // Get the value from the TextField
                if (job.isEmpty) {
                  setState(() {
                    error =
                        "내용을 입력해주세요."; // Show an error message if the TextField is empty
                  });
                } else {
                  setState(() {
                    error = null; // Clear the error message
                  });
                  Navigator.pop(context,
                      job); // Close the CreatePage and return the entered value
                }
              },
              controller: textController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "하고 싶은 일을 입력하세요",
                errorText: error,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 32),
            // 추가하기 버튼
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[100], // Background color
                ),
                child: Text(
                  "추가하기",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  String job = textController.text; // 값 가져오기
                  if (job.isEmpty) {
                    setState(() {
                      error = "내용을 입력해주세요."; // 내용이 없는 경우 에러 메세지
                    });
                  } else {
                    setState(() {
                      error = null; // 내용이 있는 경우 에러 메세지 숨기기
                    });
                    Navigator.pop(context, job); // job 변수를 반환하며 화면을 종료합니다.
                  }
                  print(job);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
