import 'dart:io';
import 'package:demo_todo_app/utils/colours.dart';
import 'package:demo_todo_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';

import '../screens/view_task.dart';

class HomePageController extends GetxController {
  late Future<List<Widget>> futureTasks;
  final List<Widget> loadedtasks = [];
  bool isLoading = false;
  BuildContext homePageContext;
  bool isDeletingNote = false;
  late Future<List<Widget>> completedTasks = Future.value([]);

  HomePageController(this.homePageContext);

  @override
  void onInit() {
    print('Initcalled!');
    futureTasks = loadtasks(homePageContext);
    completedTasks = getCompletedTasks(homePageContext);
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> deleteTask(String title) async {

      isDeletingNote = true;
      update();

    removeTask(homePageContext, title, false );
    updateTasksList(homePageContext);


      isDeletingNote = false;
      update() ;

  }

  Future<void> deleteCompletedTask(String title) async {

    isDeletingNote = true;
    update();

    removeCompletedTask(homePageContext, title);
    updateCompletedTasks();


    isDeletingNote = false;
    update() ;

  }

  void updateTasksList(context) {
    print('UPDATED !!!!!!!!!!!! ${futureTasks}');
    futureTasks = loadtasks(homePageContext);
    update();
  }

  Future<void> updateCompletedTasks() async {
    completedTasks = getCompletedTasks(homePageContext);
    update();
  }

  Future<List<Widget>> loadtasks(BuildContext homePageContext) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final noteFiles = appDirectory.listSync();
    final tasks = <Widget>[];

    for (final file in noteFiles) {
      if (file is File && file.path.endsWith('.nte')) {
        final filename = file.path.split('/').last;
        final title = filename.substring(0, filename.length - 4);

        final contents = await file.readAsString();

        if (homePageContext.mounted) {
          final note = getTaskContainer(homePageContext, contents, contents);
          tasks.add(note);
        } else {
          if (kDebugMode) print('Context isn\'t mounted, not adding cell.');
        }
      }
    }
    print('LENGTH::  ${tasks.length}');
    return tasks;
  }

  Future<bool> saveTask(String title, context) async {
    try {
      final appDirectory = await getApplicationDocumentsDirectory();
      final file = await File('${appDirectory.path}/$title.nte').create();

      await file.writeAsString(title);
      // Call the callback function to update the notes list
      updateTasksList(context);
      return true;
    } catch (e) {
      toast('Error while saving task $e');
      return false;
    }
  }

  Future<bool> moveTaskToCompletedList(String title) async {
    try {
      // Get the application directory
      final appDirectory = await getApplicationDocumentsDirectory();

      // Create a subdirectory called "completed"
      final completedDirectory = Directory('${appDirectory.path}/completed');
      if (!await completedDirectory.exists()) {
        await completedDirectory.create();
      }

      // Create a file path for the completed task
      final completedFilePath = '${completedDirectory.path}/$title.nte';

      // Create a file for the completed task
      final completedFile = await File(completedFilePath).create();

      // Move the task to the completed file
      await completedFile.writeAsString(title);

      // Remove the task from the todo tasks list
      removeTask(homePageContext, title, true);

      // Update both task lists
      updateTasksList(homePageContext);
      updateCompletedTasks() ;

      return true;
    } catch (e) {
      // Handle errors, display a toast, or log the error
      print('Error while moving task to completed list: $e');
      return false;
    }
  }

  Future<List<Widget>> getCompletedTasks(BuildContext context) async {
    try {
      final appDirectory = await getApplicationDocumentsDirectory();
      final completedDirectory = Directory('${appDirectory.path}/completed');

      if (!await completedDirectory.exists()) {
        // Return an empty list if the completed directory doesn't exist
        return [];
      }

      final completedFiles = completedDirectory.listSync();
      final completedTasks = <Widget>[];

      for (final file in completedFiles) {
        if (file is File && file.path.endsWith('.nte')) {
          final filename = file.path.split('/').last;
          final title = filename.substring(0, filename.length - 4);
          final contents = await file.readAsString();

          if (context != null && context.mounted) {
            final completedTask = getCompletedTaskContainer(context, title, contents);
            completedTasks.add(completedTask);
          } else {
            if (kDebugMode) print('Context isn\'t mounted, not adding completed task.');
          }
        }
      }

      return completedTasks;
    } catch (e) {
      // Handle errors, display a toast, or log the error
      print('Error while getting completed tasks: $e');
      return [];
    }
  }



  void removeTask(BuildContext context, String title, bool isCompleted) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final noteFilePath = '${appDirectory.path}/$title.nte';
    final noteFile = File(noteFilePath);

    if (await noteFile.exists()) {
      await noteFile.delete();
      if (context.mounted) {
        isCompleted ?  toast("Task has been Completed ", bgColor:  Colors.red) : toast("Task has been deleted!", bgColor:  Colors.red)  ;
        updateTasksList(context);
      }
    } else {
      if (context.mounted) {
        toast(
            "Couldn't remove task '$title'! There was an error while attempting to remove the file containing the note. Try again later.",
            );
      }
    }
  }

  void removeCompletedTask(BuildContext context, String title) async {
    try {
      final appDirectory = await getApplicationDocumentsDirectory();
      final noteFilePath = '${appDirectory.path}/completed/$title.nte';
      final noteFile = File(noteFilePath);

      if (await noteFile.exists()) {
        await noteFile.delete();
        if (context.mounted) {
          toast("Task has been deleted!", bgColor: Colors.red);
          updateCompletedTasks(); // Assuming you have this method to update the completed tasks list
        }
      } else {
        if (context.mounted) {
          toast("Task '$title' not found or already deleted.");
        }
      }
    } catch (e) {
      // Handle the error, display a toast, or log it
      print("Error while deleting completed task: $e");
      if (context.mounted) {
        toast("Error while deleting task. Try again later.");
      }
    }
  }


  Widget getTaskContainer(BuildContext context, String title, String body) {


    return Container(
      height: getHeight(context) * 0.15,
      width: getWidth(context),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  body,
                  style: TextStyle(color: darkAppColor),
                ),
              ),
            ).onTap((){
              ViewTask(title).launch(context, pageRouteAnimation: PageRouteAnimation.Slide) ;
            }),
          ),
          Container(
            height: getHeight(context) * 0.05,

            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      ),
                      color: Colors.green.shade400,
                    ),
                    child:  Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Completed'),
                        2.width,
                        Icon(Icons.done_all_outlined)
                      ],
                    )),
                  ).onTap((){
                    moveTaskToCompletedList(title);
                  }),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                      ),
                      color: Colors.red.shade400,
                    ),
                    child: Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Delete'),
                        2.width,
                        Icon(Icons.delete_forever)
                      ],
                    )),
                  ).onTap((){
                    showDeleteDialog(context, title);
                  }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getCompletedTaskContainer(BuildContext context, String title, String body) {


    return Container(
      height: getHeight(context) * 0.15,
      width: getWidth(context),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  body,
                  style: TextStyle(color: darkAppColor),
                ),
              ),
            ),
          ),
          Container(
            height: getHeight(context) * 0.05,

            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      color: Colors.red.withOpacity(0.5),
                    ),
                    child: Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Delete'),
                        2.width,
                        Icon(Icons.delete_forever)
                      ],
                    )),
                  ).onTap((){
                    deleteCompletedTask(title) ;
                  }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: primaryColor, // Set theme color with half opacity
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 48.0,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Delete Task',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Are you sure you want to delete this task?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Call the deleteNote function here
                        deleteTask(title);
                        Navigator.pop(context); // Close the dialog
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
                const SizedBox(height: 14.0),
              ],
            ),
          ),
        );
      },
    );
  }

  String getCurrentTimestamp() {
    final DateTime now = DateTime.now();
    final String formattedDate =
        "${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)} ${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}";
    return formattedDate;
  }


  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

}


