import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:my_notes/cubit/cubit.dart';
import 'package:my_notes/cubit/states.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //controoler
  var noteConteroller = TextEditingController();
  //key
  //var ScffoldKey = GlobalKey<ScaffoldState>();
  //
  // var showColors = false;
  // var isShowBottomSheet = true;

  var colors = [
    '#${Colors.amberAccent.value.toRadixString(16)}',
    '#${Colors.teal.shade100.value.toRadixString(16)}',
    '#${Colors.lime.shade100.value.toRadixString(16)}',
    '#${Colors.lightBlueAccent.value.toRadixString(16)}',
    '#${Colors.orange.shade100.value.toRadixString(16)}',
    '#${Colors.blue.shade100.value.toRadixString(16)}',
    '#${Colors.amber.shade100.value.toRadixString(16)}',
    '#${Colors.red.shade100.value.toRadixString(16)}',
  ];
  var selectedColor = '#${Colors.amber.shade100.value.toRadixString(16)}';
  var isWithAlarm = false;
  var alarmTime = "";
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteApp, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          // key: ScffoldKey,
          appBar: AppBar(
            backgroundColor: HexColor(NoteApp.get(context).color),
            bottomOpacity: 20,
            leading: IconButton(
              onPressed: () async {
                await NoteApp.get(context).addNote(noteConteroller.text,
                    selectedColor, context, isWithAlarm, alarmTime);
                //not this is first
                //second step add check for the navigator
                //when return to save the note
              },
              icon: const Icon(Icons.keyboard_arrow_left),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    //show option mene
                  },
                  icon: const Icon(Icons.menu))
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.yellow.shade400,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              //handel the event
              //  NoteApp.get(context).isShowBottomSheet?false:true;
              if (value == 3) {
                NoteApp.get(context).changeBottomSheetState();
              }
              if (value == 2) {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  alarmTime += (value!.format(context)).toString();
                });
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.parse('2025-03-15'),
                ).then((value) {
                  alarmTime += DateFormat.yMMMd().format(value!);
                });
                isWithAlarm = true;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.camera),
                label: "camera",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.image),
                label: "picture",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.alarm),
                label: "alarm",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.text_fields),
                label: "color",
              ),
            ],
          ),
          body: Container(
            color: HexColor(selectedColor),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: noteConteroller,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'new note'),
                      textInputAction: TextInputAction.newline,
                      // style: TextStyle(lain),
                    ),
                  ),
                  // Container(
                  //   child: Row(children: [buildColorsItems(Colors.amber.shade700)]),
                  // ),
                ],
              ),
            ),
          ),

          bottomSheet: NoteApp.get(context).isShowBottomSheet
              ? BottomSheet(
                  elevation: 10,
                  backgroundColor: Colors.white12,
                  shadowColor: Colors.black54,
                  enableDrag: false,

                  onClosing: () {
                    NoteApp.get(context).changeBottomSheetState();
                  },
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              colorItem(colors[index], context),
                          separatorBuilder: (context, index) => const SizedBox(
                                width: 20,
                              ),
                          itemCount: colors.length),
                    ),
                  ),
                  // Container(
                  //       width: double.infinity,
                  //       height: 250,
                  //       alignment: Alignment.center,
                  //       child: ElevatedButton(
                  //         child: const Text(
                  //           'Close this bottom sheet',
                  //         ),
                  //         onPressed: () {
                  //           setState(() {
                  //             isShowBottomSheet = false;
                  //           });
                  //         },
                  //       ),
                  //     ),
                )
              : null,
        );
      },
    );
  }

  Widget colorItem(String color, context) => GestureDetector(
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            shape: BoxShape.circle,
            color: HexColor(color),
          ),
        ),
        onTap: () {
          NoteApp.get(context).setColor(color);
          selectedColor = color;
          //handel color
        },
      );
}
