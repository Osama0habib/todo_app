import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Model/task_model.dart';
import 'package:todo_app/layout/screen/archived_task.dart';
import 'package:todo_app/layout/screen/done_task.dart';
import 'package:todo_app/layout/screen/new_task.dart';
import 'package:todo_app/shared/cubid/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<String> title = ["New Task", "Done Task", "Archived Task"];
  List<Widget> screen = [NewTask(), DoneTask(), ArchivedTask()];
  int currentIndex = 0;

  void changeIndex(index) {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  late Database database;
  List<Task> tasks = [];
  List<Task> newTasks = [];
  List<Task> doneTasks = [];
  List<Task> archivedTasks = [];

  createDatabase() {
    openDatabase('task.db', version: 1, onCreate: (database, version) {
      print("Database Created");
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , time TEXT , date TEXT ,status TEXT)')
          .then((value) => {print("Table Created")})
          .catchError((error) {
        print("Error happened When Creating Table ${error.toString()}");
      });
    }, onOpen: (database) {
      emit(LoadingState());
      getFromDatabase(database);
      print("Database Opened");
    }).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  insertToDatabase({title, time, date}) async {
    await database.insert("tasks", {
      "title": "$title",
      "time": "$time",
      "date": "$date",
      "status": "new"
    }).then((value) {
      print('$value inserted successfully');
      emit(InsertToDatabaseState());
      emit(LoadingState());
      getFromDatabase(database);
    }).catchError((error) {
      print("Error happened When Inserting new record ${error.toString()}");

      // return await database.transaction((txn) {
      //   return txn
      //       .rawInsert(
      //           'INSERT INTO tasks(title,date,time,status) VALUES("$title" , "$time" , "$date" ,"new")')
      //       .then((value) => print('$value inserted successfully')).catchError((error) {
      //     print("Error happened When Inserting new record ${error.toString()}");
      //   });
      // });
    });
  }

  getFromDatabase(database) async {
    return await database.query("tasks").then((List<dynamic> value) {
      tasks = value
          .map((task) => Task(
              id: task["id"],
              title: task["title"],
              time: task["time"],
              date: task["date"],
              status: task["status"]))
          .toList();
      newTasks = tasks.where((task) => task.status == "new").toList();
      doneTasks = tasks.where((task) => task.status == "done").toList();
      archivedTasks = tasks.where((task) => task.status == "archived").toList();
      print(newTasks);
      print(doneTasks);
      print(archivedTasks);
      emit(GetFromDatabaseState());
    });
  }

  updateDatabase(status, Task taskId) {
    database
        .update("tasks", {"status": status}, where: 'id = ${taskId.id}')
        .then((value) {
      emit(UpdateFromDatabaseState());
      getFromDatabase(database);
    });
  }

  bool isShow = false;
  IconData floatingIcon = Icons.edit;

  void changeBottomSheetState(
      {required bool isShowBottomSheet, required IconData icon}) {
    isShow = isShowBottomSheet;
    floatingIcon = icon;
    emit(ChangeBottomSheetState());
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();



  late List<Task> select = [];
  bool selectMode = false;

  toggleSelectionMode(task) {
    if (selectMode == false) {selectMode = true;}
    toggleSelectedItem(task);
  }

  toggleSelectedItem(task) {
    if (selectMode == true)
       task.isSelected = !task.isSelected;
    if (tasks.every((element) => element.isSelected == false)) {selectMode = false;}
    select = tasks.where((element) => element.isSelected == true).toList();
    select.removeWhere((element) => element.isSelected == false);
    emit(ChangeSelectState());
  }
}
