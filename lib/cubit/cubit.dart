import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:molahdaty/components/toast.dart';

import 'package:molahdaty/cubit/states.dart';
import 'package:molahdaty/helpers/db_helper.dart';
import 'package:molahdaty/helpers/notification_helper.dart';
import 'package:molahdaty/layouts/about_layout.dart';
import 'package:molahdaty/layouts/note_page.dart';
import 'package:molahdaty/layouts/main_layout.dart';
import 'package:molahdaty/layouts/settings_layout.dart';
import 'package:molahdaty/models/note_model.dart';

class NoteApp extends Cubit<AppStates> {
  NoteApp() : super(InitialState());

  static NoteApp get(context) => BlocProvider.of(context);
  static NoteModele? currentNote;
  //screensList
  static List<dynamic> screens = [
    const HomeScreen(),
    const AddNoteScreen(),
    const About(),
    const Settings(),
  ];
  //selected screen index
  static int selectedScreen = 0;
  // selected color for the note
  static String selectedColor = '#${Colors.white.value.toRadixString(16)}';
 
  bool showColors = false;
 
  static bool isShowBottomSheet = false;
  String color = '#${Colors.white.value.toRadixString(16)}'; //'#0xFFBBBD0';
 

  //function change bottom sheat stste
  void changeBottomSheetState() {
    isShowBottomSheet = !isShowBottomSheet;
    emit(BottomSheetStateChanged());
  }

  //function change note color stste
  void setColor(String color) {
    selectedColor = color;
    isShowBottomSheet = !isShowBottomSheet;
    emit(ChangedItemColorState());
  }

  //function add note
  Future<void> addNote(String content, col, context, bool isAlarm, DateTime? time) async {
    if (content.isEmpty || content.trim() == "") {
      // Toast.show("empty note not saved",
      //     duration: Toast.lengthLong, gravity: Toast.center);
      selectedScreen = 0;
      emit(NoteNotSavedState());
      showToast(
        text: 'empty note not saved',
        color: Colors.red,
        context: context, // Ensure context is not null
      );
    } else {
      String now = DateTime.now().toString();
      // String formattedDate = DateFormat('yyyy-MM-dd:kk:mm').format(now);
      int r = await DBHelper.insertNote(NoteModele(
          content: content, date: now, id: 0, isLiked: 0, color: col));
      // Navigator.pop(context);
      if (isAlarm) {
        String body = content.length > 50 ? content.substring(0, 30) : content;
        await NotificationHelper().addNoteAlarm(r,
            DateFormat('yyyy-MM-dd:kk:mm').format(DateTime.now()), body, time);
      }
      showToast(
      text: 'Note added successfully',
      color: Colors.green,
      context: context,  
    );
    }
    
    selectedScreen = 0;
    getNotes();
    
  }

  //store  notes data from db
  //()>modify this for db_helper
  static List<NoteModele> notes = [];
  //retrive  notes data from db
  void getNotes() async {
    final List<Map<String, dynamic>> maps =
        await DBHelper.getNotes().then((value) => value);
    // Convert the List<Map<String, dynamic> into a List<NoteModele>.
    notes =
        List.generate(maps.length, (index) => NoteModele.fromMap(maps[index]));
    emit(GetNotesFromDBState());
  }

  //function to open  note
  void openNote(int index) {
    selectedScreen = 1;
    //set current note
    currentNote = notes[index];
    //emit state
    emit(OpenNoteState());

  }

  //go to add note
  void newNote() {
    selectedScreen = 1;
    emit(NewNoteState());
  }
  //go to about us
 

  //function to update note
  Future<void> updateNote(String content, col, context, bool isAlarm, DateTime? time) async {
    String now = DateTime.now().toString();
    // String formattedDate = DateFormat('yyyy-MM-dd:kk:mm').format(now);
    int r = await DBHelper.updateNote(NoteModele(
        content: content,
        date: now,
        id: currentNote!.id,
        isLiked: 0,
        color: col));
    // Navigator.pop(context);
    if (isAlarm) {
      // Cancel any existing alarm for this note
      await NotificationHelper().cancelNotification(currentNote!.id);
      String body = content.length > 50 ? content.substring(0, 30) : content;
      await NotificationHelper().addNoteAlarm(
          r, DateFormat('yyyy-MM-dd:kk:mm').format(DateTime.now()), body, time);
    }
    // }
    selectedScreen = 0;
    getNotes();
    showToast(
      text: 'Note updated successfully',
      color: Colors.green,
      //current context is needed for showing the toast
      context: context, // Ensure context is not null
    );
  }

  //function to delete note
  Future<void> deleteNote(int id, context) async {
    await DBHelper.deleteNote(id);
    getNotes();
    showToast(
      text: 'One Note deleted',
      color: Colors.red,
      //current context is needed for showing the toast
      context: context, // Ensure context is not null
    );

    emit(DeleteNoteState());
  }
 
}
