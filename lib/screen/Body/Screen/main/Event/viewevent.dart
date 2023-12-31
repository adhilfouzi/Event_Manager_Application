import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_event/Core/Color/color.dart';
import 'package:project_event/Core/Color/font.dart';
import 'package:project_event/Database/model/Event/event_model.dart';
import 'package:project_event/screen/Body/Screen/Event_Planner/budget.dart';
import 'package:project_event/screen/Body/Screen/Event_Planner/guests.dart';
import 'package:project_event/screen/Body/Screen/Event_Planner/report.dart';
import 'package:project_event/screen/Body/Screen/Event_Planner/Settlement/settlement.dart';
import 'package:project_event/screen/Body/Screen/Event_Planner/task_list.dart';
import 'package:project_event/screen/Body/Screen/Event_Planner/vendors.dart';
import 'package:project_event/screen/Body/Screen/main/Event/edit_event.dart';
import 'package:project_event/screen/Body/Screen/main/Event/view_event_details.dart';
import 'package:project_event/screen/Body/widget/Scaffold/app_bar.dart';
import 'package:project_event/screen/Body/widget/Scaffold/bottomborderappbar.dart';
import 'package:project_event/screen/Body/widget/Scaffold/bottomnavigator.dart';
import 'package:sizer/sizer.dart';

class ViewEvent extends StatelessWidget {
  final Eventmodel eventModel;
  const ViewEvent({super.key, required this.eventModel});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MainBottom(profileid: eventModel.profile),
          ),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
          leading: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MainBottom(profileid: eventModel.profile),
              ),
              (route) => false,
            );
          },
          textcolor: Colors.white,
          actions: [
            AppAction(
                icon: Icons.more_vert,
                onPressed: () {
                  showMenu(
                    color: backgroundcolor,
                    context: context,
                    position: RelativeRect.fromLTRB(0.1.h, 0, 0, 0.5.h),
                    items: <PopupMenuEntry>[
                      PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            const Icon(Icons.visibility),
                            SizedBox(
                              width: 2.h,
                            ),
                            const Text('View Event Details')
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit),
                            SizedBox(
                              width: 2.h,
                            ),
                            const Text('Edit')
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete),
                            SizedBox(
                              width: 2.h,
                            ),
                            const Text('Delete')
                          ],
                        ),
                      )
                    ],
                  ).then((value) {
                    switch (value) {
                      case 'view':
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ViewEventDetails(eventModel: eventModel),
                        ));
                        break;
                      case 'Edit':
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditEvent(event: eventModel),
                        ));
                        break;
                      case 'Delete':
                        dodeleteevent(context, eventModel);
                        break;
                    }
                  });
                })
          ],
          titleText: 'Event Planner & Organizer',
          backgroundColor: Colors.transparent,
          bottom: const BottomBorderNull(),
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  color: const Color.fromARGB(255, 26, 27, 28),
                  elevation: 6,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  child: SizedBox(
                    height: 30.h,
                    width: double.infinity,
                    child: Image.file(
                      File(eventModel.imagex),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  height: 30.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.center,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3)
                      ],
                      stops: const [0.3, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 50,
                  right: 50,
                  child: Column(
                    children: [
                      Text(
                        eventModel.eventname,
                        style: racingSansOne(fontSize: 18.sp),
                      ),
                      Text(
                        eventModel.startingDay,
                        style: racingSansOne(fontSize: 15.sp),
                      ),
                      Text(
                        eventModel.startingTime,
                        style: racingSansOne(fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //----------------------------------------------------------//
            //----------------------------------------------------------//
            Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(1.h, 0, 1.h, 1.h),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctr) => TaskList(
                                    eventModel: eventModel,
                                    eventid: eventModel.id!,
                                  ),
                                ),
                              ),
                              child: Card(
                                margin: EdgeInsets.all(1.4.h),
                                elevation: 4,
                                color: const Color.fromRGBO(227, 100, 136, 1),
                                child: Column(
                                  children: [
                                    SizedBox(height: 2.4.h),
                                    Image(
                                        image: const AssetImage(
                                            'assets/UI/icons/Task List.png'),
                                        width: 11.h),
                                    Text(
                                      'Task List',
                                      style: raleway(color: Colors.white),
                                    ),
                                    SizedBox(height: 2.4.h)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctr) => Guests(
                                      eventid: eventModel.id!,
                                      eventModel: eventModel),
                                ),
                              ),
                              child: Card(
                                margin: EdgeInsets.all(1.4.h),
                                elevation: 4,
                                color: const Color.fromRGBO(234, 28, 140, 1),
                                child: Column(
                                  children: [
                                    SizedBox(height: 2.4.h),
                                    Image(
                                        image: const AssetImage(
                                            'assets/UI/icons/Guests.png'),
                                        width: 11.h),
                                    Text(
                                      'Guests',
                                      style: raleway(color: Colors.white),
                                    ),
                                    SizedBox(height: 2.4.h)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctr) => Budget(
                                    eventModel: eventModel,
                                    eventid: eventModel.id!,
                                  ),
                                ),
                              ),
                              child: Card(
                                margin: EdgeInsets.all(1.4.h),
                                elevation: 4,
                                color: const Color.fromRGBO(211, 234, 43, 1),
                                child: Column(
                                  children: [
                                    SizedBox(height: 2.4.h),
                                    Image(
                                        image: const AssetImage(
                                            'assets/UI/icons/budget.png'),
                                        width: 11.h),
                                    Text(
                                      'Budget',
                                      style: raleway(color: Colors.white),
                                    ),
                                    SizedBox(height: 2.4.h)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctr) => Vendors(
                                      eventid: eventModel.id!,
                                      eventModel: eventModel),
                                ),
                              ),
                              child: Card(
                                margin: EdgeInsets.all(1.4.h),
                                elevation: 4,
                                color: const Color.fromRGBO(250, 166, 68, 11),
                                child: Column(
                                  children: [
                                    SizedBox(height: 2.4.h),
                                    Image(
                                        image: const AssetImage(
                                            'assets/UI/icons/vendors.png'),
                                        width: 11.h),
                                    Text(
                                      'Vendors',
                                      style: raleway(color: Colors.white),
                                    ),
                                    SizedBox(height: 2.4.h)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctr) => Report(
                                    eventModel: eventModel,
                                    eventid: eventModel.id!,
                                  ),
                                ),
                              ),
                              child: Card(
                                margin: EdgeInsets.all(1.4.h),
                                elevation: 4,
                                color: const Color.fromRGBO(129, 236, 114, 1),
                                child: Column(
                                  children: [
                                    SizedBox(height: 2.4.h),
                                    Image(
                                        image: const AssetImage(
                                            'assets/UI/icons/report.png'),
                                        width: 11.h),
                                    Text(
                                      'Report',
                                      style: raleway(color: Colors.white),
                                    ),
                                    SizedBox(height: 2.4.h)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctr) => Settlement(
                                      eventID: eventModel.id!,
                                      eventModel: eventModel),
                                ),
                              ),
                              child: Card(
                                margin: EdgeInsets.all(1.4.h),
                                elevation: 4,
                                color: const Color.fromRGBO(67, 229, 181, 1),
                                child: Column(
                                  children: [
                                    SizedBox(height: 2.4.h),
                                    Image(
                                        image: const AssetImage(
                                            'assets/UI/icons/settlement.png'),
                                        width: 11.h),
                                    Text(
                                      'Settlementt',
                                      style: raleway(color: Colors.white),
                                    ),
                                    SizedBox(height: 2.4.h)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
