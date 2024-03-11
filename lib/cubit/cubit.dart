import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:my_notes/cubit/states.dart';
import 'package:my_notes/helpers/db_helper.dart';
import 'package:my_notes/layouts/add_note.dart';
import 'package:my_notes/layouts/main_layout.dart';
import 'package:my_notes/models/note_model.dart';

class NoteApp extends Cubit<AppStates> {
  NoteApp() : super(InitialState());

  static NoteApp get(context) => BlocProvider.of(context);
  //screensList
  static List<dynamic> screens = [
    HomeScreen(),
    AddNoteScreen(),
  ];
  static int selectedScreen = 0;
  static String selectedColor =
      '#${Colors.amberAccent.value.toRadixString(16)}';
  //varaiables and func to add not screen
  bool showColors = false;
  bool isShowBottomSheet = false;
  String color =
      '#${Colors.amberAccent.value.toRadixString(16)}'; //'#0xFFBBBD0';
  // '#${Colors.amberAccent.toString().replaceAll('X', 'x')}';
  changeBottomSheetState() {
    isShowBottomSheet = !isShowBottomSheet;
    emit(BottomSheetStateChanged());
  }

  setColor(String color) {
    selectedColor = color;
    emit(ChangedItemColorState());
  }

  addNote(String content, col, context, bool isAlarm, String time) async {
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
        setAlarm(
            id: r,
            time: time,
            text: content,
            title: DateFormat('yyyy-MM-dd:kk:mm').format(DateTime.now()));
      }
      selectedScreen = 0;
      getNotes();
    }
    // emit(SaveNoteState());
  }

  //retrive  notes data from db
  static List<NoteModele> notes = [];
  void getNotes() async {
    final List<Map<String, dynamic>> maps = await DBHelper.getNotes();
    // Convert the List<Map<String, dynamic> into a List<Breed>.
    notes =
        List.generate(maps.length, (index) => NoteModele.fromMap(maps[index]));
    emit(GetNotesFromDBState());
  }

  //go to add note
  newNote(context) {
    selectedScreen = 1;
    emit(NewNoteState());
  }

  //set alarm funcion
  static Future<void> setAlarm(
      {required id, required time, required text, required title}) async {
    await Alarm.init();
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: DateTime.parse(time),
      assetAudioPath: 'assets/audio/alarm1.mp3',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: title,
      notificationBody: text,
      enableNotificationOnKill: true,
    );
    await Alarm.set(alarmSettings: alarmSettings);
    // Alarm.ringStream.stream.listen((_) => yourOnRingCallback());
  }
}
