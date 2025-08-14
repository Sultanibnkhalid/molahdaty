import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:molahdaty/cubit/cubit.dart';
import 'package:molahdaty/cubit/states.dart';
import 'package:molahdaty/models/note_model.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  //controoler
  var noteConteroller = TextEditingController();

  var colors = [
    // '#${Colors.amber.value.toRadixString(16)}',
    '#${Colors.teal.shade100.value.toRadixString(16)}',
    '#${const Color.fromARGB(255, 243, 144, 236).value.toRadixString(16)}',
    '#${const Color.fromARGB(255, 111, 197, 234).value.toRadixString(16)}',
    '#${const Color.fromARGB(255, 216, 161, 83).value.toRadixString(16)}',
    '#${Colors.blue.shade100.value.toRadixString(16)}',
    '#${const Color.fromARGB(255, 122, 216, 235).value.toRadixString(16)}',
    '#${const Color.fromARGB(255, 249, 216, 220).value.toRadixString(16)}',
  ];
  var selectedColor =
      '#${const Color.fromARGB(255, 255, 255, 255).value.toRadixString(16)}';
  var isWithAlarm = false;
  DateTime? alarmTime;
  TimeOfDay? time;
  DateTime date = DateTime.now();
  NoteModele? note;
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteApp, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        //check the state
        isOpen = (state is OpenNoteState) ? true : false;
        if (isOpen) {
          String? tx = NoteApp.currentNote!.content;
          selectedColor = NoteApp.currentNote!.color;
          noteConteroller.text = tx!;
        }
        return PopScope(
          canPop: false,
          onPopInvokedWithResult:
              (didPop, result){
            if (isOpen) {
                NoteApp.get(context).updateNote(
                    noteConteroller.text, selectedColor, context, isWithAlarm, alarmTime);
              } else {
                NoteApp.get(context).addNote(
                    noteConteroller.text, selectedColor, context, isWithAlarm, alarmTime);
              }   
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () async {
                  if (isOpen) {
                    await NoteApp.get(context).updateNote(noteConteroller.text,
                        selectedColor, context, isWithAlarm, alarmTime);
                  } else {
                    await NoteApp.get(context).addNote(noteConteroller.text,
                        selectedColor, context, isWithAlarm, alarmTime);
                  }
                },
                icon: const Icon(Icons.keyboard_arrow_left),
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      if (isOpen) {
                        await NoteApp.get(context).updateNote(
                            noteConteroller.text,
                            selectedColor,
                            context,
                            isWithAlarm,
                            alarmTime);
                      } else {
                        await NoteApp.get(context).addNote(noteConteroller.text,
                            selectedColor, context, isWithAlarm, alarmTime);
                      }
                    },
                    icon: const Icon(Icons.save))
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              onTap: (value) async {
                
                if (value == 1) {
                  NoteApp.get(context).changeBottomSheetState();
                }
                if (value == 0) {
                  await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    time = value;
                  });
          
                  if (time != null) {
                    isWithAlarm = true;
                    alarmTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time!.hour,
                      time!.minute,
                    );
                  }
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.alarm),
                  label: "alarm".tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.text_fields),
                  label: "color".tr(),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'new note'.tr()),
                          textInputAction: TextInputAction.newline,
                          // style: TextStyle(lain),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: NoteApp.isShowBottomSheet
                ? BottomSheet(
                    elevation: 20,
                    backgroundColor: Colors.white,
                    shadowColor: Colors.black,
                    onClosing: () {
                      NoteApp.get(context).changeBottomSheetState();
                    },
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...colors.map(
                              (color) => Row(
                                children: [
                                  colorItem(color, context),
                                  const Gap(5),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  )
                : null,
            //handel android device screen back butto
          ),
      );
      }
    );
  }
  

  Widget colorItem(String color, context) => GestureDetector(

    
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: HexColor(color),
          ),
        ),
        onTap: () {
          NoteApp.get(context).setColor(color);
          selectedColor = color;
        },
      );
}
