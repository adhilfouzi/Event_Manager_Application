import 'package:flutter/material.dart';
import 'package:project_event/Core/Color/color.dart';
import 'package:project_event/Core/Color/font.dart';
import 'package:project_event/Database/functions/fn_guestmodel.dart';
import 'package:project_event/Database/model/Guest_Model/guest_model.dart';
import 'package:project_event/screen/Body/Screen/Edit/edit_guest.dart';

class GuestSearch extends StatefulWidget {
  const GuestSearch({super.key});

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
      body: SafeArea(
        child: ValueListenableBuilder<List<GuestModel>>(
            valueListenable: guestlist,
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextField(
                        onChanged: (value) => _runFilter(value),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              color: buttoncolor,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: buttoncolor,
                              width: 1,
                            ),
                          ),
                          hintText: 'Search',
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    Expanded(
                      child: finduser.isEmpty
                          ? const Center(
                              child: Text(
                                'No Data Available',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              itemCount: finduser.length,
                              itemBuilder: (context, index) {
                                final finduserItem = finduser[index];
                                return Card(
                                  color: Colors.blue[100],
                                  elevation: 4,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
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
                                          dodeleteguest(context, finduserItem);
                                        }),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (ctr) =>
                                            EditGuest(guestdata: finduserItem),
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

void dodeleteguest(rtx, GuestModel student) {
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
                  delectYes(context, student);
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
    print('Error deleting data: $e');
  }
}

void delectYes(ctx, GuestModel student) {
  deleteGuest(student.id, student.eventid);
  ScaffoldMessenger.of(ctx).showSnackBar(
    const SnackBar(
      content: Text("Successfully Deleted"),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(10),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ),
  );
  Navigator.of(ctx).pop();
  Navigator.of(ctx).pop();
}