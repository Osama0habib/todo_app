import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Model/task_model.dart';
import 'package:todo_app/shared/cubid/cubid.dart';

defaultTextFormField({
  @required TextEditingController? controller,
  @required TextInputType? keyboardType,
  @required String? label,
  @required IconData? prefix,
  @required String? Function(String?)? validator,
  void Function(String)? onSubmit,
  void Function(String)? onChanged,
  VoidCallback? suffixPressed,
  VoidCallback? onTab,
  bool isPassword = false,
  IconData? suffix,
}) {
  return Container(
    padding: EdgeInsets.all(8.0),
    margin: EdgeInsets.all(8.0),
    height: 80,
    child: TextFormField(
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(fontSize: 18),
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: label,
          prefixIcon: Icon(prefix),
          suffix: suffix == null
              ? IconButton(
                  icon: Icon(suffix),
                  onPressed: suffixPressed,
                )
              : null),
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      onTap: onTab,
      obscureText: isPassword,
      validator: validator,
    ),
  );
}

defaultListItem({required Task model,@required context }) {
  return Dismissible(
    onDismissed: (direction){
      if(direction == DismissDirection.endToStart){
        BlocProvider.of<AppCubit>(context).updateDatabase("archived", model);
      }
  },
    key: UniqueKey(),
    child: ListTile(selected: model.isSelected,
      onLongPress: (){
        AppCubit.get(context).toggleSelectionMode(model);
        print(AppCubit.get(context).selectMode);
        print(model.isSelected);
      },
      onTap: (){
        AppCubit.get(context).toggleSelectedItem(model);
        print(AppCubit.get(context).selectMode);
        print("task id = ${model.id} isSelected = ${model.isSelected}");


      },
      leading: CircleAvatar(
         radius: 40,
        child: FittedBox(fit: BoxFit.cover, child: Container(margin: EdgeInsets.all(25),child: Text(model.time))),
      ),
      title: Text(model.title),
      subtitle: Text(model.date),
      trailing: IconButton(icon: Icon(Icons.check_box_outlined),onPressed: (){
        AppCubit.get(context).updateDatabase("done", model);
      },),
    ),
  );
}
