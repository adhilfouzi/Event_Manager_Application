import 'package:flutter/material.dart';
import 'package:project_event/Database/functions/fn_budgetmodel.dart';
import 'package:project_event/Database/model/Budget_Model/budget_model.dart';
import 'package:project_event/screen/Body/widget/List/categorydropdown.dart';
import 'package:project_event/screen/Body/widget/Scaffold/app_bar.dart';
import 'package:project_event/screen/Body/widget/box/textfield_blue.dart';
import 'package:project_event/screen/Body/widget/sub/paymentbar.dart';

class AddBudget extends StatefulWidget {
  final int eventid;

  const AddBudget({super.key, required this.eventid});

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          AppAction(
              icon: Icons.done,
              onPressed: () {
                addGuestclick(context);
              }),
        ],
        titleText: 'Add Budget',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFieldBlue(
              textcontent: 'Name',
              controller: _nameController,
              keyType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null; // Return null if the input is valid
              },
            ),
            CategoryDown(
              onCategorySelected: (String value) {
                _categoryController.text = value;
              },
            ),
            TextFieldBlue(textcontent: 'Note', controller: _noteController),
            TextFieldBlue(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Estimatrd Amount is required';
                  }
                  return null; // Return null if the input is valid
                },
                textcontent: 'Estimatrd Amount',
                controller: _budgetController,
                keyType: TextInputType.number),
            PaymentsBar(),
            // Payments(
            //     goto: AddPayments(
            //   payment1: paymentdata,
            // ))
          ]),
        ),
      ),
    );
  }

  // final PaymentModel paymentdata;
  final _budgetController = TextEditingController();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();
  //List<PaymentModel> store = [];
  Future<void> addGuestclick(mtx) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final name = _nameController.text.toUpperCase().trimLeft().trimRight();
      final category = _categoryController.text;
      final note = _noteController.text.trimLeft().trimRight();
      final budget = _budgetController.text.trimLeft().trimRight();
      final budgetdata = BudgetModel(
          name: name,
          category: category,
          eventid: widget.eventid,
          esamount: budget,
          note: note);

      await addBudget(budgetdata);
      refreshBudgetData(widget.eventid);
      ScaffoldMessenger.of(mtx).showSnackBar(
        const SnackBar(
          content: Text("Successfully added"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(mtx);
    } else {
      ScaffoldMessenger.of(mtx).showSnackBar(
        const SnackBar(
          content: Text("Fill the Name & Estimatrd Amount"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
