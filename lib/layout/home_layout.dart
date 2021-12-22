import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:todo_app/layout/widgets/bottom_sheet.dart';
import 'package:todo_app/shared/cubid/cubid.dart';
import 'package:todo_app/shared/cubid/states.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (BuildContext context, AppStates? state) {
          if(state is InsertToDatabaseState) Navigator.pop(context);
        },
        builder: (BuildContext context, AppStates? state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: cubit.scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.title[cubit.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isShow) {
                  if (cubit.formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                            title: cubit.titleController.text,
                            time: cubit.timeController.text,
                            date: cubit.dateController.text);

                  }
                } else {
                  cubit.scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => CustomBottomSheet()

                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(isShowBottomSheet: false, icon: Icons.edit);

                  });
                  cubit.changeBottomSheetState(isShowBottomSheet: true, icon: Icons.add);

                }
              },
              child: Icon(cubit.floatingIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
               cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_task), label: "New Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archived"),
              ],
            ),
            body: Conditional.single(
                context: context,
                conditionBuilder: (ctx) => state is! LoadingState,
                widgetBuilder: (ctx) => cubit.screen[cubit.currentIndex],
                fallbackBuilder: (ctx) =>
                    Center(child: CircularProgressIndicator())),
          );
        },
      ),
    );
  }
}
