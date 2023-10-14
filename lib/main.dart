import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/to_do_list_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ToDoList())],
      child: const MyApp(),
    ),
  );
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
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoList>(builder: (context, toDoList, child) {
      // ToDoList의 toDoList 가져오기
      List<Bucket> bucketList = toDoList.toDoList;
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
                  var bucket = bucketList[index]; // index에 해당하는 bucket 가져오기
                  return ListTile(
                      // 버킷 리스트 할 일
                      title: Text(
                        bucket.job,
                        style: TextStyle(
                          fontSize: 20,
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
                          bucket.isDone = !bucket.isDone;
                          toDoList.updateToDoList(bucket, index);
                          print('$bucket : 체크하기');
                        },
                      ),
                      // 삭제 아이콘 버튼
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
                              toDoList.deleteToDoList(index);
                            },
                          )
                        ],
                      ),
                      onTap: () {
                        // 아이템 클릭 시
                      });
                },
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[100],
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () {
            // + 버튼 클릭시 버킷 생성 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreatePage()),
            );
          },
        ),
      );
    });
  }
} // <-- Missing closing bracket for HomePage

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
                // 텍스트 입력 시

                String job = textController.text; // 값 가져오기
                if (job.isEmpty) {
                  setState(() {
                    error = "내용을 입력해주세요."; // 내용이 없는 경우 에러 메세지
                  });
                } else {
                  setState(() {
                    error = null; // 내용이 있는 경우 에러 메세지 숨기기
                  });
                  //BucketService 가져오기
                  ToDoList toDoList = context.read<ToDoList>();
                  toDoList.createToDoList(job);

                  Navigator.pop(context, job); // job 변수를 반환하며 화면을 종료합니다.
                }
                print(job);
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
                    //BucketService 가져오기
                    ToDoList toDoList = context.read<ToDoList>();
                    toDoList.createToDoList(job);

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
