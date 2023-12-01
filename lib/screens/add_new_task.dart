import 'package:demo_todo_app/screens/homepage.dart';
import 'package:demo_todo_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/homepage_controller.dart';
import '../utils/colours.dart';


import 'package:flutter/material.dart';

class AddNewTaskScreen extends StatefulWidget {
  AddNewTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final HomePageController controller = Get.put(HomePageController(context));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task', style: TextStyle(
            color: darkAppColor,
            fontWeight: FontWeight.w600
        ),),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: darkAppColor.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: taskController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Enter your task',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor:lightAppColor, // Change as needed
                ),
              ),
            ),
            20.height,
          CustomButton(onPressed: (){
            String title = taskController.text.toString() ;
            if(taskController.text.isEmpty){
              toast( 'Task Can''t be Blank' );
            }
            else {
              controller.saveTask(title, context).then((success) {
                if (success) {
                  toast("Task has been saved", bgColor: Colors.green);
                  // HomePage().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                 finish(context);
                }
              });
              // HomePage().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
              finish(context);
            }

          }, title: 'Add Task')
          ],
        ).paddingAll(16),
      ),
    );
  }
}
