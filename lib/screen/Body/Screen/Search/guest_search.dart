import 'package:flutter/material.dart';
import 'package:project_event/Core/Color/font.dart';
import 'package:project_event/Database/functions/fn_guestmodel.dart';
import 'package:project_event/Database/model/Event/event_model.dart';
import 'package:project_event/Database/model/Guest_Model/guest_model.dart';
import 'package:project_event/screen/Body/Screen/Edit/edit_guest.dart';
import 'package:project_event/screen/Body/Screen/Event_Planner/guests.dart';
import 'package:sizer/sizer.dart';

class GuestSearch extends StatefulWidget {
  final Eventmodel eventModel;

  const GuestSearch({super.key, required this.eventModel});

  @override
  State<GuestSearch> createState() => _GuestSearchState();
}

class _GuestSearchState extends State<GuestSearch> {
  List<GuestModel> finduser = [];

  @override
  void initState() {
    super.initState();
    finduser = guestlist.value;
    // Initialize with the current student list
  }

  void _runFilter(String enteredKeyword) {
    List<GuestModel> result = [];
    if (enteredKeyword.isEmpty) {
      result = guestlist.value;
    } else {
      result = guestlist.value
          .where((student) =>
              student.gname
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              student.number!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      finduser = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor:
              Colors.white, //const Color.fromRGBO(255, 200, 200, 1),

          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: TextField(
              autofocus: true,
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          )),
      body: SafeArea(
        child: ValueListenableBuilder<List<GuestModel>>(
            valueListenable: guestlist,
            builder: (context, value, child) {
              return Padding(
                padding: EdgeInsets.all(1.h),
                child: Column(
                  children: [
                    Expanded(
                      child: finduser.isEmpty
                          ? Center(
                              child: Text(
                                'No Data Available',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            )
                          : ListView.builder(
                              itemCount: finduser.length,
                              itemBuilder: (context, index) {
                                final finduserItem = finduser[index];
                                return Card(
                                  color: Colors.blue[100],
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(vertical: 2.sp),
                                  child: ListTile(
                                    title: Text(
                                      finduserItem.gname,
                                      style: raleway(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    subtitle: Text(
                                      finduserItem.status == 0
                                          ? 'Pending invitation'
                                          : 'Invitation sent',
                                      style: TextStyle(
                                        color: finduserItem.status == 0
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          dodeleteguest(context, finduserItem,
                                              1, widget.eventModel);
                                        }),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (ctr) => EditGuest(
                                            guestdata: finduserItem,
                                            eventModel: widget.eventModel),
                                      ));
                                    },
                                  ),
                                );
                              }),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

void dodeleteguest(rtx, GuestModel student, int step, Eventmodel eventModel) {
  try {
    showDialog(
      context: rtx,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: Text('Do You Want delete  ${student.gname} ?'),
          actions: [
            TextButton(
                onPressed: () {
                  delectYes(context, student, step, eventModel);
                },
                child: const Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.pop(rtx);
                },
                child: const Text('No'))
          ],
        );
      },
    );
  } catch (e) {
    // print('Error deleting data: $e');
  }
}

void delectYes(ctx, GuestModel student, int step, Eventmodel eventModel) {
  deleteGuest(student.id, student.eventid);

  if (step == 2) {
    Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (ctx) => Guests(
                eventModel: eventModel,
                eventid: student.eventid,
              )),
      (route) => false,
    );
  } else if (step == 1) {
    Navigator.pop(ctx);
    refreshguestdata(student.eventid);
  }
}
