import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/component.dart';
import 'package:todo_app/shared/cubid/cubid.dart';
import 'package:todo_app/shared/cubid/states.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AppCubit , AppStates>(
        listener:(ctx , state){} ,
        builder: (ctx , state) {
          AppCubit cubit = AppCubit.get(context);
         return Container(
            color: Colors.grey[200],
            child: Form(
              key: cubit.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  defaultTextFormField(
                    label: "Title",
                    prefix: Icons.title,
                    controller: cubit.titleController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please Enter a title first";
                      }
                    },
                  ),
                  defaultTextFormField(
                      label: "Time",
                      prefix: Icons.access_time,
                      controller: cubit.timeController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please pick a time first";
                        }
                      },
                      onTab: () {
                        showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now())
                            .then((value) => cubit.timeController.text =
                            value!.format(context));
                      }),
                  defaultTextFormField(
                      label: "Date",
                      prefix: Icons.calendar_today,
                      controller: cubit.dateController,
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please pick a date first";
                        }
                      },
                      onTab: () {
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now()
                                .add(Duration(days: 30)))
                            .then((value) => cubit.dateController.text =
                            DateFormat("yMMMd")
                                .format(value!));
                      }),
                ],
              ),
            ),
          );
        },
      );


  }
}
