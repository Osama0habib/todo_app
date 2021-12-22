import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/component.dart';
import 'package:todo_app/shared/const.dart';
import 'package:todo_app/shared/cubid/cubid.dart';
import 'package:todo_app/shared/cubid/states.dart';

class ArchivedTask extends StatelessWidget {
  const ArchivedTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:(ctx , state) {} ,
      builder: (ctx , state) {
        AppCubit cubit = AppCubit.get(context);
        return ListView.separated(
          separatorBuilder: (ctx , index) =>Divider(height: 1,thickness: 1,),
          itemCount: cubit.archivedTasks.length,
          itemBuilder: (ctx , index) {
            return defaultListItem(model: cubit.archivedTasks[index] ,context: context);
          },
        );
      },
    );
  }
}

