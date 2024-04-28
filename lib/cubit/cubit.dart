import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:my_notes/cubit/states.dart';
import 'package:my_notes/helpers/db_helper.dart';
import 'package:my_notes/helpers/notification_helper.dart';
import 'package:my_notes/layouts/note_page.dart';
import 'package:my_notes/layouts/main_layout.dart';
import 'package:my_notes/models/note_model.dart';

class NoteApp extends Cubit<AppStates> {
  NoteApp() : super(InitialState());

  static NoteApp get(context) => BlocProvider.of(context);
  static NoteModele? currentNote;
  //screensList
  static List<dynamic> screens = [
    HomeScreen(),
    AddNoteScreen(),
  ];
  //selected screen index
  static int selectedScreen = 0;
  // selected color for the note
  static String selectedColor = '#${Colors.white.value.toRadixString(16)}';
  //varaiables and func to add not screen
  //show colors varialbe
  bool showColors = false;
  //for bottom sheet check
  static bool isShowBottomSheet = false;
  String color = '#${Colors.white.value.toRadixString(16)}'; //'#0xFFBBBD0';
  // '#${Colors.amberAccent.toString().replaceAll('X', 'x')}';

  //function change bottom sheat stste
  changeBottomSheetState() {
    isShowBottomSheet = !isShowBottomSheet;
    emit(BottomSheetStateChanged());
  }

  //function change note color stste
  setColor(String color) {
    selectedColor = color;
    isShowBottomSheet = !isShowBottomSheet;
    emit(ChangedItemColorState());
  }

  //function add note
  addNote(String content, col, context, bool isAlarm, DateTime? time) async {
    if (content.isEmpty || content.trim() == "") {
      // Toast.show("empty note not saved",
      //     duration: Toast.lengthLong, gravity: Toast.center);
      selectedScreen = 0;
      emit(NoteNotSavedState());
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
    }
    selectedScreen = 0;
    getNotes();
    // emit(SaveNoteState());
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
  openNote(int index) {
    selectedScreen = 1;
    //set current note
    currentNote = notes[index];
    //emit state
    emit(OpenNoteState());
  }

  //go to add note
  newNote() {
    selectedScreen = 1;
    emit(NewNoteState());
  }

  //function to update note
  updateNote(String content, col, context, bool isAlarm, DateTime? time) async {
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
      String body = content.length > 50 ? content.substring(0, 30) : content;
      await NotificationHelper().addNoteAlarm(
          r, DateFormat('yyyy-MM-dd:kk:mm').format(DateTime.now()), body, time);
    }
    // }
    selectedScreen = 0;
    getNotes();
    // emit(SaveNoteState());
  }

  //set alarm funcion
  // static Future<void> setAlarm(
  //     {required id,
  //     required time,
  //     required String text,
  //     required title}) async {
  //   String body = text.length > 50 ? text.substring(0, 30) : text;
  //   await NotificationHelper().addNoteAlarm(id, title, body, time);
  //   // await Alarm.init();
  //   // final alarmSettings = AlarmSettings(
  //   //   id: id,
  //   //   dateTime: DateTime.parse(time),
  //   //   assetAudioPath: 'assets/audio/alarm1.mp3',
  //   //   loopAudio: true,
  //   //   vibrate: true,
  //   //   volume: 0.8,
  //   //   fadeDuration: 3.0,
  //   //   notificationTitle: title,
  //   //   notificationBody: text,
  //   //   enableNotificationOnKill: true,
  //   // );
  //   // await Alarm.set(alarmSettings: alarmSettings);
  //   // Alarm.ringStream.stream.listen((_) => yourOnRingCallback());
  // }
}
