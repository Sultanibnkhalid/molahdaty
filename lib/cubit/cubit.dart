import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:my_notes/cubit/states.dart';
import 'package:my_notes/helpers/db_helper.dart';
import 'package:my_notes/models/note_model.dart';

class NoteApp extends Cubit<AppStates> {
  NoteApp() : super(InitialState());

  static NoteApp get(context) => BlocProvider.of(context);
  //varaiables and func to add not screen
  bool showColors = false;
  bool isShowBottomSheet = false;
  String color = ColorToHex(Colors.yellow.shade200).toString();
  changeBottomSheetState() {
    isShowBottomSheet = !isShowBottomSheet;
    emit(BottomSheetStateChanged());
  }

  setColor(String color) {
    color = color;
    emit(ChangedItemColorState());
  }

  addNote(content, col, context) async {
    DateTime now = DateTime.now();
    // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    int r = await DBHelper.insertNote(NoteModele(
        content: content,
        date: DateFormat('yyyy-MM-dd – kk:mm').format(now),
        id: 0,
        isLiked: 0,
        color: col));
    Navigator.pop(context);
    getNotes();
    emit(SaveNoteState());
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
}
