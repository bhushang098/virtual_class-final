import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/modals/classModal.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

import '../constants.dart';

class CreateClass extends StatefulWidget {
  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  String className, about, fess = '0';
  String location, duration;
  bool _isFree = true;
  bool _isDaily = false;

  Uuid uuid;

  TextEditingController classNameController = new TextEditingController();
  TextEditingController aboutController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController durationController = new TextEditingController();
  TextEditingController feesController = new TextEditingController();
  FirebaseUser user;
  DateTime startDate, endDate;
  TimeOfDay startTime;
  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
    startTime = TimeOfDay.now();
    uuid = new Uuid();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Class '),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.supervised_user_circle,
                      color: PrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: classNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        hintText: "Class Name",
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.location_on,
                      color: PrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          hintText: "Location"),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Text('Start Date'),
                title: Text(
                    " :  ${startDate.day} / ${startDate.month} / ${startDate.year}"),
                trailing: Icon(
                  Icons.date_range,
                  color: PrimaryColor,
                ),
                onTap: _pickStartDate,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Text('End  Date'),
                title: Text(
                    " :  ${endDate.day} / ${endDate.month} / ${endDate.year}"),
                trailing: Icon(
                  Icons.date_range,
                  color: PrimaryColor,
                ),
                onTap: _pickEndDate,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Text('Start Time'),
                title: Text(" : ${startTime.format(context)}"),
                trailing: Icon(
                  Icons.access_time,
                  color: PrimaryColor,
                ),
                onTap: _pickStartTime,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.timelapse,
                      color: PrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: durationController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          hintText: "Time Duration in Minits"),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Text("Daily Recurring Class"),
                  Checkbox(
                    activeColor: PrimaryColor,
                    value: _isDaily,
                    onChanged: (bool value) {
                      setState(() {
                        _isDaily = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: aboutController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        hintText: "About ",
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Text("Free Class"),
                  Checkbox(
                    activeColor: PrimaryColor,
                    value: _isFree,
                    onChanged: (bool value) {
                      setState(() {
                        _isFree = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            _isFree
                ? Text('')
                : Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.attach_money,
                            color: PrimaryColor,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.numberWithOptions(),
                            controller: feesController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              hintText: "Fees ",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            GestureDetector(
              onTap: () {
                about = aboutController.text;
                className = classNameController.text;
                fess = feesController.text;
                location = locationController.text;
                duration = durationController.text;

                if (about.isEmpty ||
                    className.isEmpty ||
                    location.isEmpty ||
                    duration.isEmpty) {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                          title: Text(
                        'Fill All Fields',
                        style: TextStyle(color: Colors.black38, fontSize: 16),
                      )));
                } else {
                  Classes _class = new Classes();
                  _class.userId = user.uid;
                  _class.about = about;
                  _class.className = className;
                  _class.location = location;
                  _class.startDate = startDate;
                  _class.endDate = endDate;
                  _class.daily = _isDaily;
                  _class.fees = double.tryParse(fess);
                  _class.classId = uuid.v1();
                  _class.startTime = startTime;
                  new DbUserCollection(user.uid)
                      .makeNewClass(_class)
                      .then((onValue) {
                    showAlertDialog(context);
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 80),
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: PrimaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      " Create Class",
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.supervised_user_circle,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  _pickStartDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: startDate,
    );
    if (date != null)
      setState(() {
        startDate = date;
      });
  }

  _pickEndDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: endDate,
    );
    if (date != null)
      setState(() {
        endDate = date;
      });
  }

  _pickStartTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (t != null)
      setState(() {
        startTime = t;
      });
  }

  void showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("See Classes"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(" Class Created"),
      content: Text('Thanks For Creating  Class'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
