import 'package:demo_todo_app/controllers/homepage_controller.dart';
import 'package:demo_todo_app/utils/colours.dart';
import 'package:demo_todo_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import 'add_new_task.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomePageController(context),
      builder: (controller) {
        return DefaultTabController(
          initialIndex: 0,
          length: 2, // Number of tabs
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false ,
              title: const Text(
                'MyTask Planner',
                style: TextStyle(color: darkAppColor, fontWeight: FontWeight.w600),
              ),
              backgroundColor: primaryColor,
              actions: [
                  IconButton(
                    onPressed: () {
                      AddNewTaskScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                    },
                    icon: Icon(Icons.add),
                  ),
              ],
              bottom: TabBar(
                labelColor: darkAppColor,
                indicatorColor: darkAppColor,
                tabs: [
                  Tab(text: 'Todo Tasks'),
                  Tab(text: 'Completed Tasks'),
                ],
              ),
            ),
            body: TabBarView(
              children: [

                FutureBuilder<List<Widget>>(
                  future: controller.futureTasks,
                  builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: snapshot.data![index],
                          );
                        },
                      );
                    } else {
                      // Display the list of tasks
                      return Center(child: Text('No tasks available.'));
                    }
                  },
                ).paddingOnly(left: 15, right: 15, top: 10),

                // Completed Tasks Tab
                // You can replace this with the appropriate widget for displaying completed tasks
                // Completed Tasks Tab
                FutureBuilder<List<Widget>>(
                  future: controller.completedTasks, // Assuming you have a completedTasks Future in your controller
                  builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: snapshot.data![index],
                          );
                        },
                      );
                    } else {
                      // Display a message when there are no completed tasks
                      return Center(child: Text('No completed tasks.'));
                    }
                  },
                ).paddingOnly(left: 15, right: 15, top: 10),

              ],
            ),
          ),
        );
      },
    );
  }
}

